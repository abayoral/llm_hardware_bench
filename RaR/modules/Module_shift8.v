module top_module (
    input clk,
    input [7:0] d,
    input [1:0] sel,
    output [7:0] q
);
    wire [7:0] q1, q2, q3;

    // Instantiate three my_dff8 modules
    my_dff8 dff1(.clk(clk), .d(d), .q(q1));
    my_dff8 dff2(.clk(clk), .d(q1), .q(q2));
    my_dff8 dff3(.clk(clk), .d(q2), .q(q3));
    
    // 4-to-1 multiplexer implementation
    always @(*) begin
        case (sel)
            2'b00: q = d;
            2'b01: q = q1;
            2'b02: q = q2;
            2'b03: q = q3;
            default: q = 8'b00000000;
        endcase
    end

endmodule