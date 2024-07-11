module top_module( 
    input [2:0] a, b,
    input cin,
    output reg [2:0] cout,
    output reg [2:0] sum );

    wire c0, c1, c2;

    full_adder U1 (.a(a[0]), .b(b[0]), .cin(cin),       .sum(sum[0]), .cout(cout[0]));
    full_adder U2 (.a(a[1]), .b(b[1]), .cin(cout[0]),   .sum(sum[1]), .cout(cout[1]));
    full_adder U3 (.a(a[2]), .b(b[2]), .cin(cout[1]),   .sum(sum[2]), .cout(cout[2]));

endmodule