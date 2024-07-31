module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);

    // Use reduction operators to aggregate all 100 inputs
    assign out_and = &in;  // AND reduction
    assign out_or = |in;   // OR reduction
    assign out_xor = ^in;  // XOR reduction

endmodule