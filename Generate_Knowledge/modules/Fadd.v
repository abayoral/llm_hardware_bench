module top_module( 
    input a, b, cin,
    output cout, sum );

    // Sum is the XOR of the input bits and carry-in.
    assign sum = a ^ b ^ cin;

    // Carry-out is the majority function of the input bits and carry-in.
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule