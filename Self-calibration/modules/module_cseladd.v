module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire [15:0] sum_lower, sum_upper_0, sum_upper_1;
    wire cout_lower, cout_0, cout_1;

    // Lower 16-bit addition (using add16)
    add16 adder_lower (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),        
        .sum(sum_lower),
        .cout(cout_lower)
    );

    // Upper 16-bit addition with carry-in = 0
    add16 adder_upper_0 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b0),
        .sum(sum_upper_0),
        .cout(cout_0)
    );

    // Upper 16-bit addition with carry-in = 1
    add16 adder_upper_1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b1),
        .sum(sum_upper_1),
        .cout(cout_1)
    );

    // Multiplexer to select sum based on the carry-out of the lower adder
    mux2to1_16 mux_sum (
        .in0(sum_upper_0),
        .in1(sum_upper_1),
        .sel(cout_lower),
        .out(sum[31:16])
    );

    // Assign sum lower bits directly
    assign sum[15:0] = sum_lower;

endmodule