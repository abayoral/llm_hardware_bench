module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire [31:0] b_xored;
    wire cout1, cout2;
    
    // XOR b with sub replicated 32 times
    assign b_xored = b ^ {32{sub}};
    
    // Instantiate two 16-bit adders
    add16 adder1 (
        .a(a[15:0]),
        .b(b_xored[15:0]),
        .cin(sub),
        .sum(sum[15:0]),
        .cout(cout1)
    );

    add16 adder2 (
        .a(a[31:16]),
        .b(b_xored[31:16]),
        .cin(cout1),
        .sum(sum[31:16]),
        .cout(cout2)
    );

endmodule