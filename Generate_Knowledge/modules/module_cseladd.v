module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2, cout3;
    wire cin1, cin2, cin3;
  
    assign cin1 = 1'b0;
    assign cin2 = cout1;
    assign cin3 = cout2;

    add16 adder0 (.a(a[15:0]), .b(b[15:0]), .cin(cin1), .sum(sum0), .cout(cout1));
    add16 adder1 (.a(a[31:16]), .b(b[31:16]), .cin(cin2), .sum(sum1), .cout(cout2));
    mux16to1 mux0 (.sel(cout1), .a(sum1), .b(sum2), .y(sum[31:16]));

    add16 adder2 (.a(a[31:16]), .b(b[31:16]), .cin(cin3), .sum(sum2), .cout(cout3));  
    mux16to1 mux1 (.sel(cout2), .a(sum2), .b(sum3), .y(sum[31:16]));

    assign sum[15:0] = sum0;
endmodule