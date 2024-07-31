module top_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo 
);
    // Assign the lower 8 bits of in to out_lo
    assign out_lo = in[7:0];
    
    // Assign the upper 8 bits of in to out_hi
    assign out_hi = in[15:8];

endmodule