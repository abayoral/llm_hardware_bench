module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire cout_lower, cout_upper;
    
    add16 lower_adder (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(cout_lower)
    );

    add16 upper_adder (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(cout_lower),
        .sum(sum[31:16]),
        .cout(cout_upper)
    );
endmodule