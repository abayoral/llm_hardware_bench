module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] sum_lower;
    wire [15:0] sum_upper;
    wire cout_lower;
    
    add16 lower_adder (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(cout_lower)
    );
    
    add16 upper_adder (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(cout_lower),
        .sum(sum_upper),
        .cout()
    );
    
    assign sum = {sum_upper, sum_lower};
endmodule