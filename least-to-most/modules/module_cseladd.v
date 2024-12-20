module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire [15:0] sum1, sum2, sum3;
    wire cout1, cout2, cout3;

    // First 16-bit add
    add16 adder1 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(0),
        .sum(sum1),
        .cout(cout1)
    );
    
    // Second 16-bit add with Cin = 0
    add16 adder2 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(0),
        .sum(sum2),
        .cout(cout2)
    );
    
    // Second 16-bit add with Cin = 1
    add16 adder3 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1),
        .sum(sum3),
        .cout(cout3)
    );

    // 16-bit 2-to-1 multiplexer to select the second half sum
    mux2to1_16bit mux(
        .in0(sum2),
        .in1(sum3),
        .sel(cout1),
        .out(sum[31:16])
    );

    assign sum[15:0] = sum1;

endmodule