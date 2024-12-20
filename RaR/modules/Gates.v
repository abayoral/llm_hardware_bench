module top_module( 
    input a, 
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);
    // Logic for 'out_and': a AND b
    assign out_and = a & b;
    
    // Logic for 'out_or': a OR b
    assign out_or = a | b;
    
    // Logic for 'out_xor': a XOR b
    assign out_xor = a ^ b;
    
    // Logic for 'out_nand': a NAND b
    assign out_nand = ~(a & b);
    
    // Logic for 'out_nor': a NOR b
    assign out_nor = ~(a | b);
    
    // Logic for 'out_xnor': a XNOR b
    assign out_xnor = ~(a ^ b);
    
    // Logic for 'out_anotb': a AND (NOT b)
    assign out_anotb = a & ~b;
    
endmodule