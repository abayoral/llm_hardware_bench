module top_module (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Combine the outputs of the flip-flops
    assign q = clk ? q_pos : q_neg;

endmodule