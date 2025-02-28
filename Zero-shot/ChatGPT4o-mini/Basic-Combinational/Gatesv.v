// you're a senior Digital Design Engineer at a leading hardware design company tasked with developing a critical Verilog module for a next-generation product. The success of this module is pivotal for maintaining my computer hardware company's reputation in the industry.

// You are given a four-bit input vector in[3:0]. 
//We want to know some relationships between each bit and its neighbour:

// out_both: Each bit of this output vector should indicate whether both the corresponding 
//input bit and its neighbour to the left (higher index) are '1'. For example, out_both[2] 
//should indicate if in[2] and in[3] are both 1. Since in[3] has no neighbour to the left, 
//the answer is obvious so we don't need to know out_both[3].
// out_any: Each bit of this output vector should indicate whether any of the corresponding 
// input bit and its neighbour to the right are '1'. For example, out_any[2] should indicate if either in[2] 
// or in[1] are 1. Since in[0] has no neighbour to the right, the answer is obvious so we don't need to know out_any[0].
// out_different: Each bit of this output vector should indicate whether the corresponding input bit 
// is different from its neighbour to the left. For example, out_different[2] should indicate if in[2] 
// is different from in[3]. For this part, treat the vector as wrapping around, so in[3]'s neighbour to the left is in[0].

//Hint: The both, any, and different outputs use two-input AND, OR, and XOR operations, respectively. 
//Using vectors, this can be done in 3 assign statements.

module top_module( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );

    // Insert your cod here

endmodule