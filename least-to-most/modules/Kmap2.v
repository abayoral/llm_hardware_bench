module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
); 

    assign out = (~c & ~d) | (~a & ~d) | (a & c) | (b & ~d);

endmodule