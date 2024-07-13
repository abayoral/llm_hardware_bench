module top_module (
    input wire clk,
    input wire [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] old_state;

    always @(posedge clk) begin
        anyedge = old_state ^ in;  // edge detection: XOR the current and previous input signals
        old_state = in;            // update the old input signal state for the next clock cycle
    end

endmodule