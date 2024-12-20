module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output reg [3:0] q);

    // Counter logic
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000; // Reset counter to 0
        else
            q <= q + 1;   // Increment counter
    end

endmodule