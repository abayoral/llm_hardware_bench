module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] ones_seconds, tens_seconds;
reg [3:0] ones_minutes, tens_minutes;
reg [3:0] ones_hours, tens_hours;

// Reset has higher priority than enable
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the clock to 12:00:00 AM
        ss <= 8'b0000_0000; // 00 seconds
        mm <= 8'b0000_0000; // 00 minutes
        hh <= 8'b0001_0010; // 12 hours (BCD for 12)
        pm <= 0;            // AM
    end else if (ena) begin
        // Increment seconds
        ones_seconds <= ss[3:0];
        tens_seconds <= ss[7:4];
        
        ones_seconds <= ones_seconds + 1;
        if (ones_seconds == 4'b1010) begin
            ones_seconds <= 4'b0000;
            tens_seconds <= tens_seconds + 1;
            if (tens_seconds == 4'b0101) begin
                // Increment minutes when seconds roll over to 00
                tens_seconds <= 4'b0000;

                ones_minutes <= mm[3:0];
                tens_minutes <= mm[7:4];

                ones_minutes <= ones_minutes + 1;
                if (ones_minutes == 4'b1010) begin
                    ones_minutes <= 4'b0000;
                    tens_minutes <= tens_minutes + 1;
                    if (tens_minutes == 4'b0101) begin
                        // Increment hours when minutes roll over to 00
                        tens_minutes <= 4'b0000;

                        ones_hours <= hh[3:0];
                        tens_hours <= hh[7:4];

                        ones_hours <= ones_hours + 1;
                        if (ones_hours == 4'b1010 || (tens_hours == 4'b0001 && ones_hours == 4'b0010)) begin
                            ones_hours <= 4'b0000;
                            tens_hours <= tens_hours + 1;
                            if (tens_hours == 4'b0010) begin
                                // Handle the transition from 12 to 01
                                tens_hours <= 4'b0000;
                                ones_hours <= 4'b0010; // 12 -> 01
                                pm <= ~pm; // Toggle AM/PM
                            end
                        end
                    end
                end
                mm <= {tens_minutes, ones_minutes};
            end
        end
        ss <= {tens_seconds, ones_seconds};
    end
end

// Ensure hours are updated correctly
always @(posedge clk or posedge reset) begin
    if (reset) begin
        hh <= 8'b0001_0010; // BCD for 12
    end else if (ena) begin
        // Update hour digits separately to handle BCD transitions correctly
        if (ss == 8'b0000_0000 && mm == 8'b0000_0000) begin
            ones_hours <= hh[3:0];
            tens_hours <= hh[7:4];
            
            ones_hours <= ones_hours + 1;
            if ((ones_hours == 4'b1001 && tens_hours == 4'b0001) || (ones_hours == 4'b1000)) begin
                ones_hours <= 4'b0000;
                tens_hours <= tens_hours + 1;
                if (tens_hours == 4'b0010) begin
                    tens_hours <= 0;
                end
            end
            hh <= {tens_hours, ones_hours};
        end
    end
end

endmodule