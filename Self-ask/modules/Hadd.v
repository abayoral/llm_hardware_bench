module top_module( 
    input a, b,
    output cout, sum );

    // Using the addition operation to calculate sum and carry-out
    assign {cout, sum} = a + b;

endmodule