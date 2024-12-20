module top_module (input a, input b, input c, output out);
    wire and_out;
    // Instantiate the 5-input AND gate with the last two inputs set to 1
    // This way, the three inputs directly determine the AND output
    andgate inst1 ( .out(and_out), .a(a), .b(b), .c(c), .d(1'b1), .e(1'b1) ); 
    // Implement the NAND functionality by inverting the output of AND gate
    assign out = ~and_out;
endmodule