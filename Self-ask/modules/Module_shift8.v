module top_module (
    input clk,
    input [7:0] d,
    input [1:0] sel,
    output reg [7:0] q
);
    wire [7:0] q0, q1, q2;

    my_dff8 dff0 (.clk(clk), .d(d), .q(q0));
    my_dff8 dff1 (.clk(clk), .d(q0), .q(q1));
    my_dff8 dff2 (.clk(clk), .d(q1), .q(q2));

    always @(*) begin
        case (sel)
            2'b00: q = d;
            2'b01: q = q0;
            2'b02: q = q1;
            2'b03: q = q2;
            default: q = 8'b0;
        endcase
    end
endmodule