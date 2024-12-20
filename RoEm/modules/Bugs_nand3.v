module top_module (input a, input b, input c, output out);
    wire and_out;
    wire vcc = 1'b1;  // Constant high signal
    wire gnd = 1'b0;  // Constant low signal

    andgate inst1 (.out(and_out), .a(a), .b(b), .c(c), .d(vcc), .e(vcc));
    
    assign out = ~and_out; // NAND gate

endmodule