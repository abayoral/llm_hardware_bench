module top_module(
    input clk,
    input reset,     // Active-high synchronous reset to 32'h1
    output reg [31:0] q
); 
    
    wire feedback;

    // Feedback tap positions: 32, 22, 2, and 1 (0-indexed positions: 31, 21, 1, and 0)
    assign feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;           // Set LFSR to initial value 32'h1 on reset
        end else begin
            q <= {q[30:0], feedback};  // Shift left and insert feedback bit at position 0
        end
    end

endmodule