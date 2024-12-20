module top_module( 
    input x3,
    input x2,
    input x1,  // three inputs
    output f   // one output
);

    // Intermediary wires for each minterm
    wire m2, m3, m5, m7;

    // Define the minterms where f is 1
    assign m2 = ~x3 & x2 & ~x1;
    assign m3 = ~x3 & x2 & x1;
    assign m5 = x3 & ~x2 & x1;
    assign m7 = x3 & x2 & x1;

    // OR all minterms together to get the function output
    assign f = m2 | m3 | m5 | m7;

endmodule