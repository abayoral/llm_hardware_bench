module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_delayed;

    always @(posedge clk) begin
        in_delayed <= in;
        anyedge <= in & ~in_delayed; // Detect rising edges
    end

endmodule