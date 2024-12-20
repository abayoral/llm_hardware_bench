module top_module (
    input clk,
    input d,
    output q
);

    reg q_pos;
    reg q_neg;
    
    // Positive-edge triggered flip-flop 
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative-edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output q determined by the current edge of the clock
    assign q = (clk) ? q_pos : q_neg;

endmodule