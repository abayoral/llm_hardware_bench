module top_module (
    input clk,                // Clock signal
    input [7:0] in,           // 8-bit input vector to monitor for transitions
    output reg [7:0] pedge    // 8-bit output vector indicating positive edge detection
);

    reg [7:0] prev_in;        // Register to hold the previous state of the input vector

    always @(posedge clk) begin
        // Detect positive edges on each bit
        pedge <= (in & ~prev_in);
        // Update the previous state
        prev_in <= in;
    end
    
endmodule