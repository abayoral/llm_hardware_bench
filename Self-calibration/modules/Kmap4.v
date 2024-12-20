module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
); 

    // Simplified Sum of Products form of the Karnaugh map
    assign out = (~a & b & ~d) | (a & ~b & d) | (~a & b & c) | (a & ~b & ~c);

endmodule