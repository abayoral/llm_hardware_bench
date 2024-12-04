module top_module ( 
    input a, 
    input b, 
    input c,
    input d,
    output out1,
    output out2
);
    // Instantiate mod_a
    mod_a inst (
        .out1(out1),
        .out2(out2),
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );
endmodule