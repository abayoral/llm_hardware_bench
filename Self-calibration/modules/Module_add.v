module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire [15:0] sum1, sum2;
    wire cout1;

    // Instantiate first add16 to compute lower 16 bits
    add16 adder1 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum1),
        .cout(cout1)
    );

    // Instantiate second add16 to compute upper 16 bits
    add16 adder2 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(cout1),
        .sum(sum2),
        .cout() // Ignoring cout as mentioned
    );

    // Combine the results to form the final 32-bit sum
    assign sum = {sum2, sum1};

endmodule