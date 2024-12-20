module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss); 

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_ones, hour_tens;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_ones <= 4'b0000;
            sec_tens <= 4'b0000;
            min_ones <= 4'b0000;
            min_tens <= 4'b0000;
            hour_ones <= 4'b0010; // '2'
            hour_tens <= 4'b0001; // '1'
            pm <= 0;
        end else if(ena) begin
            // Increment seconds
            if (sec_ones == 4'b1001) begin
                sec_ones <= 4'b0000;
                if (sec_tens == 4'b0101) begin
                    sec_tens <= 4'b0000;
                    // Increment minutes
                    if (min_ones == 4'b1001) begin
                        min_ones <= 4'b0000;
                        if (min_tens == 4'b0101) begin
                            min_tens <= 4'b0000;
                            // Increment hours
                            if (hour_ones == 4'b1001) begin
                                hour_ones <= 4'b0000;
                                hour_tens <= hour_tens + 1;
                            end else if (hour_ones == 4'b0010 && hour_tens == 4'b0001) begin
                                hour_ones <= 4'b0001;
                                hour_tens <= 4'b0000;
                                pm <= ~pm; // Switch AM/PM
                            end else if (hour_ones == 4'b0012) begin
                                hour_ones <= 4'b0001;
                            end else begin
                                hour_ones <= hour_ones + 1;
                            end
                        end else begin
                            min_tens <= min_tens + 1;
                        end
                    end else begin
                        min_ones <= min_ones + 1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1;
                end
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    always @(*) begin
        ss = {sec_tens, sec_ones};
        mm = {min_tens, min_ones};
        hh = {hour_tens, hour_ones};
    end
endmodule