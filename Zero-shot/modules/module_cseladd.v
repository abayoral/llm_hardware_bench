module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] add16_1_sum;
    wire [15:0] add16_2_sum;
    wire [15:0] add16_3_sum;
    wire add16_1_cout;
    wire add16_2_cout;
    wire add16_3_cout;
    wire sel;

    add16 add16_1( a[15:0],  b[15:0], 1'b0, add16_1_sum, add16_1_cout);
    add16 add16_2( a[15:0],  b[15:0], 1'b1, add16_2_sum, add16_2_cout);
    add16 add16_3( a[31:16], b[31:16], add16_1_cout, add16_3_sum, add16_3_cout);

    assign sel = add16_2_cout;

    mux2to1_16bit mux1(add16_1_sum, add16_2_sum, sel, sum[15:0]);
    mux2to1_16bit mux2(add16_3_sum, add16_3_sum, sel, sum[31:16]);
endmodule