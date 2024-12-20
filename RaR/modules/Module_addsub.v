module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] b_xor_sub;
    wire cout_lower;
    
    // XOR b with sub to conditionally invert the bits of b
    assign b_xor_sub = b ^ {32{sub}};
    
    // First 16-bit adder for lower part
    add16 lower_adder (
        .a(a[15:0]),
        .b(b_xor_sub[15:0]),
        .cin(sub),
        .sum(sum[15:0]),
        .cout(cout_lower)
    );
    
    // Second 16-bit adder for upper part
    add16 upper_adder (
        .a(a[31:16]),
        .b(b_xor_sub[31:16]),
        .cin(cout_lower),
        .sum(sum[31:16]),
        .cout()
    );

endmodule