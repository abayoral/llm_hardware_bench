module top_module (
    input [3:0] in,
    output reg [1:0] pos  );

    always @(*) begin
        casez (in)    // Use casez to handle don't-care conditions
            4'b1000: pos = 2'd3;  // Highest priority
            4'b?100: pos = 2'd2;
            4'b??10: pos = 2'd1;
            4'b???1: pos = 2'd0;  // Lowest priority
            default: pos = 2'd0;  // Output zero if none of the input bits are high
        endcase
    end

endmodule