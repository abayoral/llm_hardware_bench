module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss); 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hh <= 8'h12;    // 12 AM
            mm <= 8'h00;    // 00 minutes
            ss <= 8'h00;    // 00 seconds
            pm <= 1'b0;     // AM
        end else if (ena) begin
            if (ss == 8'h59) begin
                ss <= 8'h00;
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                        pm <= ~pm;
                    end else if (hh == 8'h11) begin
                        hh <= 8'h12;
                    end else if (hh[3:0] == 4'h9) begin
                        hh[3:0] <= 4'h0;
                        hh[7:4] <= hh[7:4] + 1;
                    end else begin
                        hh <= hh + 1;
                    end
                end else if (mm[3:0] == 4'h9) begin
                    mm[3:0] <= 4'h0;
                    mm[7:4] <= mm[7:4] + 1;
                end else begin
                    mm <= mm + 1;
                end
            end else if (ss[3:0] == 4'h9) begin
                ss[3:0] <= 4'h0;
                ss[7:4] <= ss[7:4] + 1;
            end else begin
                ss <= ss + 1;
            end
        end
    end
endmodule