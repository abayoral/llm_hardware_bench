module top_module( 
    input a, 
    input b, 
    input cin,
    output cout, 
    output sum );

    // Explanation:
    // A full adder adds three bits: a, b, and cin (carry-in).
    // The sum bit is derived using XOR gate logic: sum = a ^ b ^ cin
    // The carry-out bit reflects if there was any carry in the addition,
    // which occurs in cases where we have two or more 1s among the inputs.

    assign sum  = a ^ b ^ cin; // XOR-ing all three inputs gives the sum bit
    assign cout = (a & b) | (b & cin) | (cin & a); // Carry-out bit is 1 if any two inputs out of the three are 1

endmodule