module top_module( 
    input a, b,
    output cout, sum );
    
    // The primary purpose of a half adder is to add two single-bit binary numbers. It produces a sum and a carry-out.
    
    // Inputs:
    // a: First single-bit binary number
    // b: Second single-bit binary number
    
    // Outputs:
    // sum: Sum of the two binary numbers (a and b)
    // cout: Carry-out bit, which is set if the addition of a and b generates a carry
    
    // Logic and Operations:
    // sum is the result of 'a' XOR 'b'. XOR operation gives a high output (1) only when the number of high inputs is odd.
    // cout (carry-out) is the result of 'a' AND 'b'. AND operation gives a high output (1) only when both inputs are high.
    
    assign sum = a ^ b;   // XOR operation for sum
    assign cout = a & b;  // AND operation for carry-out

endmodule