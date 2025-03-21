import os
import re

def read_generated_code(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def extract_verilog_code(text):
    #verilog_pattern = r'(?s)module\s+top_module\s*\(.*?\);\s*.*?endmodule'
    verilog_pattern  = r'module\s+\w+\s*(?:#\([^)]*\))?\s*\([\s\S]*?\)\s*;[\s\S]*?endmodule'



    matches = re.findall(verilog_pattern, text, re.DOTALL)
    return '\n\n'.join(matches).strip()

def save_extracted_code(file_path, extracted_code):
    with open(file_path, 'w') as file:
        file.write(extracted_code)

def main():
    framework_name = os.environ.get('framework_name')  # Set default if not provided
    module_name = os.environ.get('module_name', 'default_module')  # Set default if not provided
    model_name = os.environ.get('model_name', 'default_model')
    base_path = os.path.join(f'{framework_name}')
    model_name = os.environ.get('model_name', 'default_model')
    generated_code_path = os.path.join(base_path,model_name, "responses", f'{module_name}.txt')
    extracted_code_path = os.path.join(base_path, model_name, 'modules', f'{module_name}.v')

    if not os.path.exists(generated_code_path):
        print(f"Error: {generated_code_path} does not exist.")
        return

    generated_code = read_generated_code(generated_code_path)
    verilog_code = extract_verilog_code(generated_code)
    
    if verilog_code:
        os.makedirs(os.path.dirname(extracted_code_path), exist_ok=True)  # Ensure directory exists
        save_extracted_code(extracted_code_path, verilog_code)
        print(f"Extracted Verilog code has been written to {extracted_code_path}")
    else:
        print(f"No Verilog code found in {generated_code_path}")

if __name__ == "__main__":
    main()