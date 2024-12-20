module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_delayed;

    always @(posedge clk) begin
        in_delayed <= in;
        pedge <= in & ~in_delayed;
    end

endmodule