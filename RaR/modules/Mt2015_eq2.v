module top_module (
    input [1:0] A,  // 2-bit input A
    input [1:0] B,  // 2-bit input B
    output z        // 1-bit output z
); 
    // Assign z to 1 if A is equal to B, otherwise assign 0
    assign z = (A == B) ? 1'b1 : 1'b0;
endmodule