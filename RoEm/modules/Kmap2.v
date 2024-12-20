module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
    );

    // Simplified Sum-of-Products (SOP) form from the K-map:
    // out = a'b'c' + a'b'c + a'b d' + a c d' + a b c + ab' d

    assign out = (~a & ~b & ~c) | (~a & ~b & c) | (~a & b & ~d) | (a & ~b & ~d) | (a & b & c);

endmodule