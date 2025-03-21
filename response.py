#!/usr/bin/env python3

import os
import sys
import getopt
from collections import Counter
import languagemodels as lm
import conversation as cv
import regex as reg  # Assumes this contains the extract_verilog_code function

def generate_response(system_prompt, design_prompt, model_type, prompt_strategy=None):
    """
    Generates a response from the language model based on the design prompt.
    """
    conv = cv.Conversation()

    if system_prompt:
        conv.add_message("system", system_prompt)
    else:
        conv.add_message("system", get_sys_prompt(prompt_strategy))
    
    conv.add_message("user", design_prompt)

    response = generate_verilog(conv, model_type)

    return response

def find_mistakes_and_correct(response, model_type):
    """
    Passes the generated response through an additional verification step
    to find and correct mistakes.
    """
    conv = cv.Conversation()
    conv.add_message("system", (
        "You are a Verilog verification assistant. Your task is to analyze the given Verilog module, "
        "identify any logical, syntax, or functional errors, and provide a corrected version. "
        "Ensure that the corrected module adheres to best practices and security constraints."
    ))
    conv.add_message("user", f"Here is the generated Verilog code:\n\n{response}\n\nPlease find and correct any errors.")

    corrected_response = generate_verilog(conv, model_type)

    return corrected_response

def get_sys_prompt(prompt_strategy=None):
    framework_name = os.environ.get('framework_name', 'default_framework')
    sys_prompt_file = os.path.join(framework_name, 'sys_prompt.txt')
    
    if os.path.isfile(sys_prompt_file):
        with open(sys_prompt_file, 'r') as file:
            return file.read()
    else:
        if prompt_strategy == 'Self-ask':
            return (
                "You are an advanced assistant for designing Verilog modules. "
                "You will first ask clarifying questions to ensure the specification is clear and complete. "
                "After getting answers to your questions, you will generate the complete Verilog module. "
                "Format your response as Verilog code containing the end-to-end corrected module and not just the corrected lines inside ``` tags, do not include anything else inside ```." 
            )
        elif prompt_strategy == 'Least-to-most':
            return (
                "You are an advanced Verilog design assistant. You will first break the problem into smaller, manageable sub-problems without solving them. "
                "Once the sub-problems are identified, solve them one by one, appending the solution of each sub-problem to the prompt until a complete solution is achieved. "
                "Format your response strictly as follows:\n"
                "1. Sub-problems: List each sub-problem clearly, prefixed with 'Sub-problem X:'.\n"
                "2. Solution: Provide the solution for each sub-problem, prefixed with 'Solution for Sub-problem X:'.\n"
                "Ensure that the final response is a complete Verilog code containing all sub-solutions appended together, and maintain consistency throughout." 
            )
        else:
            return (
                "You are an autocomplete engine for Verilog code. "
                "Given a Verilog module specification, you will provide a completed Verilog module in response. "
                "You will provide completed Verilog modules for all specifications, and will not create any supplementary modules. "
                "Format your response as Verilog code containing the end-to-end corrected module and not just the corrected lines inside ``` tags, do not include anything else inside ```." 
            )

def generate_verilog(conv, model_type, model_id=""):
    if model_type == "ChatGPT4":
        model = lm.ChatGPT4()
    elif model_type == "Claude":
        model = lm.Claude()
    elif model_type == "ChatGPT3p5":
        model = lm.ChatGPT3p5()
    elif model_type == "ChatGPT4o":
        model = lm.ChatGPT4o()
    elif model_type == "ChatGPT4o-mini":
        model = lm.ChatGPT4omini()
    elif model_type == "ChatGPTo3-mini":
        model = lm.ChatGPTo3mini()
    elif model_type == "PaLM":
        model = lm.PaLM()
    elif model_type == "CodeLlama":
        model = lm.CodeLlama(model_id)
    else:
        sys.exit(2)

    return model.generate(conv)


def get_most_consistent_response(responses):
    """
    Selects the most consistent response from a list of responses.

    Parameters:
    responses (list): A list of responses from the language model.

    Returns:
    str: The most consistent response.
    """
    response_counts = Counter(responses)
    most_common_response = response_counts.most_common(1)[0][0]
    return most_common_response

def get_response(design_prompt, module, model_type, outdir="", log=None, prompt_strategy=None, dirname="responses"):
    if outdir:
        outdir += "/"

    conv = cv.Conversation()
    conv.add_message("system", get_sys_prompt(prompt_strategy))
    conv.add_message("user", design_prompt)

    # Generate the directory path
    model_name = os.environ.get('model_name', 'default_model')
    dir_path = os.path.join(outdir, prompt_strategy, model_name, dirname)

    os.makedirs(dir_path, exist_ok=True)

    # Generate the filename within the new directory
    filename = os.path.join(dir_path, f"{module}.txt")

    framework_name = os.environ.get('framework_name', 'default_framework')

    if framework_name == "Self-calibration":
        # Step 1: Generate initial response
        initial_response = generate_verilog(conv, model_type)
        
        # Step 2: Pass through verification to correct mistakes
        final_response = find_mistakes_and_correct(initial_response, model_type)

    else:
        if prompt_strategy == 'Self-consistency':
            responses = []
            for i in range(5): 
                response = generate_verilog(conv, model_type)
                responses.append(reg.extract_verilog_code(response))
            final_response = get_most_consistent_response(responses)
        elif prompt_strategy == 'Self-ask':
            final_response = handle_self_ask(conv, model_type, module)
        elif prompt_strategy == 'Least-to-most':
            final_response = handle_least_to_most(conv, design_prompt, model_type)
        else:
            final_response = generate_verilog(conv, model_type)

    with open(filename, 'w') as file:
        file.write(final_response)

    print(f"Response written to {filename}")
    return final_response


def handle_self_ask(conv, model_type, module):
    """
    Handles the 'Self-ask' prompt strategy by engaging in a multi-turn conversation with the LLM.

    Parameters:
    conv (cv.Conversation): The conversation object.
    model_type (str): The type of LLM to use.
    module (str): The name of the Verilog module.

    Returns:
    str: The final response after self-asking.
    """

    clarifying_question_prompt = (
        "Identify the one clarifying question that is absolutely necessary to understand the specification of this Verilog module. "
        "This question should be crucial to understanding the problem, without which a solution cannot be developed. "
        "If no such question is needed, it is acceptable to proceed without asking any. "
        "Please avoid asking any question that hints towards a solution."
    )
    
    # Ask for clarifying questions
    conv.add_message("user", clarifying_question_prompt)
    question_response = generate_verilog(conv, model_type)

    # Determine the solution directory and file name
    if module.startswith("RTLLM_"):
        solution_dir = "RTLLM_solutions"
        verified_module_name = module.replace("RTLLM_", "verified_", 1)  # Replace only the first occurrence
        solution_file_name = f"{verified_module_name}.v"
    else:
        solution_dir = "hdlbits_solutions"
        solution_file_name = f"{module}.v"

    # Construct the path to the solution file
    solution_file_path = os.path.join(solution_dir, solution_file_name)

    # Read the solution file
    if os.path.isfile(solution_file_path):
        with open(solution_file_path, 'r') as file:
            solution_code = file.read()
        
        # Ask for a short answer based on the question and the solution
        answer_prompt = question_response + ": " + solution_code
        conv2 = cv.Conversation()
        conv2.add_message("system", (
            "You are an advanced Verilog design assistant. Based on the following Verilog module and the provided solution, generate a short, "
            "one-sentence answer to the question. Ensure the response is concise and directly addresses the question."
        ))
        conv2.add_message("user", answer_prompt)
        user_answer = generate_verilog(conv2, model_type)
    else:
        user_answer = "Question cannot be answered, proceed to generate the Verilog code"

    conv.add_message("user", user_answer)

    # Finalize the Verilog module based on the clarifications
    final_response = generate_verilog(conv, model_type)

    return final_response


def handle_least_to_most(conv, design_prompt, model_type):
    """
    Handles the 'Least-to-most' prompting strategy by breaking the problem into sub-problems and solving them sequentially.

    Parameters:
    conv (cv.Conversation): The conversation object.
    design_prompt (str): The original design prompt for the Verilog module.
    model_type (str): The type of LLM to use.

    Returns:
    str: The final response after solving the sub-problems.
    """
    # Step 1: Ask the LLM to break the problem into sub-problems
    breakdown_prompt = (
        "Break the following Verilog design problem into smaller sub-problems. "
        "Do not solve the sub-problems yet, just list them clearly."
        "Format each sub-problem as 'Sub-problem X: <description>'.")
    conv.add_message("user", breakdown_prompt + "\n" + design_prompt)
    breakdown_response = generate_verilog(conv, model_type)
    
    # Step 2: Extract sub-problems from the response
    sub_problems = extract_sub_problems(breakdown_response)
    
    # Step 3: Solve each sub-problem sequentially
    final_solution = ""
    for i, sub_problem in enumerate(sub_problems):
        conv.add_message("user", f"Solve sub-problem {i+1}: {sub_problem}")
        sub_solution = generate_verilog(conv, model_type)
        final_solution += f"Solution for Sub-problem {i+1}:\n{sub_solution}\n"
        
        # Add the solution of the sub-problem back to the conversation
        conv.add_message("assistant", sub_solution)
    
    return final_solution

def extract_sub_problems(response):
    """
    Extracts sub-problems from the language model's response.

    Parameters:
    response (str): The response from the language model.

    Returns:
    list: A list of sub-problems extracted from the response.
    """
    sub_problems = []
    for line in response.split('\n'):
        if line.strip().startswith("Sub-problem"):
            sub_problems.append(line.strip())
    return sub_problems

def main():
    usage = ("Usage: response.py [--help] --prompt=<prompt> --name=<module name> --testbench=<testbench file> --model=<llm model> --model_id=<model id> --technique=<technique>\n\n"
             "\t-h|--help: Prints this usage message\n"
             "\t-p|--prompt: The initial design prompt for the Verilog module\n"
             "\t-n|--name: The module name, must match the testbench expected module name\n"
             "\t-t|--testbench: The testbench file to be run\n"
             "\t-i|--iter: [Optional] Number of iterations before the tool quits (defaults to 10)\n"
             "\t-m|--model: The LLM to use for this generation. Must be one of the following\n"
             "\t\t- ChatGPT3p5\n"
             "\t\t- ChatGPT4\n"
             "\t\t- ChatGPT4o\n"
             "\t\t- Claude\n"
             "\t\t- PaLM\n"
             "\t\t- CodeLlama\n"
             "\t-l|--log: [Optional] Log the output of the model to the given file")

    try:
        opts, args = getopt.getopt(sys.argv[1:], "hp:n:t:i:m:l", ["help", "prompt=", "name=", "testbench=", "model=", "model_id=", "technique=", "outdir="])
    except getopt.GetoptError as err:
        print(err)
        print(usage)
        sys.exit(2)

    prompt = None
    module = None
    testbench = None
    model = None
    model_id = ""
    outdir = ""
    log = None
    prompt_strategy = os.environ.get('framework_name', 'default_framework')

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(usage)
            sys.exit()
        elif opt in ("-p", "--prompt"):
            if os.path.isfile(arg):
                with open(arg, 'r') as file:
                    prompt = file.read()
            else:
                prompt = arg
        elif opt in ("-n", "--name"):
            module = arg
        elif opt in ("-t", "--testbench"):
            testbench = arg
        elif opt in ("-m", "--model"):
            model = arg
        elif opt in ("--model_id"):
            model_id = arg
        elif opt in ("-o", "--outdir"):
            outdir = arg
        elif opt in ("--technique"):
            os.environ['framework_name'] = arg  # Set environment variable based on input
            prompt_strategy = arg

    if not (prompt and module and model):
        print("Missing required argument(s).")
        print(usage)
        sys.exit(2)

    if outdir and not os.path.exists(outdir):
        os.makedirs(outdir)

    if log:
        logfile = os.path.join(outdir, log)
    else:
        logfile = None

    get_response(prompt, module, model, outdir, logfile, prompt_strategy)

if __name__ == "__main__":
    main()