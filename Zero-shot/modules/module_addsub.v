module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] binv;
    wire [15:0] sum1, sum2;
    wire c1, c2;

    assign binv = b ^ {32{sub}};
   
    add16 adder1(.a(a[15:0]),
                 .b(binv[15:0]),
                 .cin(sub),
                 .sum(sum1),
                 .cout(c1));

    add16 adder2(.a(a[31:16]),
                 .b(binv[31:16]),
                 .cin(c1),
                 .sum(sum2),
                 .cout(c2));

    assign sum = {sum2, sum1};

endmodule