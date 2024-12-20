module top_module (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;

    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge-triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Combining both edges' outputs
    always @(*) begin
        q = clk ? q_pos : q_neg;
    end

endmodule