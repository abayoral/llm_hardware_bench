module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;      // Reset counter to 0
    end else if (q == 4'd9) begin
        q <= 4'd0;      // Wrap around to 0 when count reaches 9
    end else begin
        q <= q + 4'd1;  // Increment the counter
    end
end

endmodule