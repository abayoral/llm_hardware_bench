module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_d; // Register to hold the previous state of 'in'

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end
        else begin
            // Detect 1 to 0 transition and set the corresponding out bit to 1
            out <= out | (in_d & ~in);
        end
        // Update the previous state of 'in'
        in_d <= in;
    end
endmodule