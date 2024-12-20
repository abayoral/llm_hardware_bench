module top_module( 
    input x3,
    input x2,
    input x1,  // three inputs
    output f   // one output
);

	// Sum-of-Products form: f = x3'x2x1' + x3'x2x1 + x3x2'x1 + x3x2x1
    assign f = (~x3 & x2 & ~x1) | // row 2
               (~x3 & x2 & x1)  | // row 3
               (x3 & ~x2 & x1)  | // row 5
               (x3 & x2 & x1);    // row 7

endmodule