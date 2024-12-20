module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified Expression from K-map: out = a'b + ab' + cd + c'd'

assign out = (~a & b) | (a & ~b) | (c & d) | (~c & ~d);

endmodule