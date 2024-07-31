module top_module( 
    input a, 
    input b, 
    output out );

// Implement XNOR gate
assign out = ~(a ^ b);

endmodule