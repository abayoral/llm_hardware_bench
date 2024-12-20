module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire [31:0] b_xor; // 32-bit XOR result of b and {32{sub}}
    wire carry_out1, carry_out2;

    // Create a 32-bit XOR operation where each bit of b is XOR-ed with sub.
    assign b_xor = b ^ {32{sub}};

    // Instantiate two 16-bit adders.
    add16 adder0 (
        .a(a[15:0]),
        .b(b_xor[15:0]),
        .cin(sub),
        .sum(sum[15:0]),
        .cout(carry_out1)
    );

    add16 adder1 (
        .a(a[31:16]),
        .b(b_xor[31:16]),
        .cin(carry_out1),
        .sum(sum[31:16]),
        .cout(carry_out2)
    );

endmodule