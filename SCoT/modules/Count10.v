module top_module (
    input wire clk,
    input wire reset,
    output reg [3:0] q
);
    // Decade counter logic: Reset q when reset is high, 
    // otherwise increment q on each rising edge of clk, 
    // and roll back to 0 when q equals 9.
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (q == 4'd9)
            q <= 4'b0000;
        else
            q <= q + 1;
    end
endmodule