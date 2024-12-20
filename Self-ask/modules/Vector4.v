module top_module (
    input [7:0] in,
    output [31:0] out
);//
    
    // Sign-extend by replicating the sign bit (in[7]) 24 times and then add the 8-bit input (in)
    assign out = {{24{in[7]}}, in};

endmodule