module top_module(
    input a, b, c,
    output w, x, y, z );

    // Connecting inputs to corresponding outputs
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule