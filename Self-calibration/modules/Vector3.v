module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );

    // Concatenate the input vectors and two '1' bits, then split into 8-bit output vectors
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11}; 

endmodule