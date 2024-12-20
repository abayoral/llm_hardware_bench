module top_module( 
    input x3,
    input x2,
    input x1,
    output f
);

    wire term_2, term_3, term_5, term_7;

    // Create the product terms for each of the rows where output f is 1
    assign term_2 = ~x3 & x2 & ~x1;  // For input (0, 1, 0)
    assign term_3 = ~x3 & x2 & x1;   // For input (0, 1, 1)
    assign term_5 = x3 & ~x2 & x1;   // For input (1, 0, 1)
    assign term_7 = x3 & x2 & x1;    // For input (1, 1, 1)

    // Sum-of-products
    assign f = term_2 | term_3 | term_5 | term_7;

endmodule