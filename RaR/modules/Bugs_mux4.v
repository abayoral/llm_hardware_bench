module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out
);

    wire [7:0] mux0_out, mux1_out;
    
    // Instantiate the first layer of 2-to-1 multiplexers
    mux2 mux0 ( .sel(sel[0]), .a(a), .b(b), .out(mux0_out) );
    mux2 mux1 ( .sel(sel[0]), .a(c), .b(d), .out(mux1_out) );

    // Instantiate the final 2-to-1 multiplexer to choose between the outputs of mux0 and mux1
    mux2 mux2 ( .sel(sel[1]), .a(mux0_out), .b(mux1_out), .out(out) );

endmodule