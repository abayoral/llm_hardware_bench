module top_module (
        input wire [255:0] in,
        input wire [7:0] sel,
        output wire out
    );
        // Multiplexer logic: out is the sel-th bit of the input vector
        assign out = in[sel];
    endmodule