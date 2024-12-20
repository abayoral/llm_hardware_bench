module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );

    // Concatenate inputs and add two 1 bits at the end
    wire [31:0] concatenated = {a, b, c, d, e, f, 2'b11};

    // Assign the 8-bit chunks to outputs
    assign {w, x, y, z} = concatenated;

endmodule