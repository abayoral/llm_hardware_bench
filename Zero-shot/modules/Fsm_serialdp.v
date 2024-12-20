module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;
    reg start_bit, stop_bit;
    wire parity_bit;

    reg [3:0] state;
    parameter IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4, DONE = 5, ERROR = 6;

    reg parity_reset;
    wire odd_parity;
    
    // Instantiating the parity module
    parity p1 (.clk(clk), .reset(parity_reset), .in(shift_reg[0]), .odd(odd_parity));

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            parity_reset <= 1;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (!in) begin // Detect start bit
                        state <= START;
                        parity_reset <= 1;
                    end
                end
                START: begin
                    if (in) begin // Spike false start bit
                        state <= IDLE;
                    end else if (bit_cnt == 4'd0) begin
                        parity_reset <= 0;
                        state <= DATA;
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[9:1]}; // Shift in the data bits
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 4'd8) begin
                        state <= PARITY;
                    end
                end
                PARITY: begin
                    shift_reg <= {in, shift_reg[9:1]}; // Shift in the parity bit
                    if (odd_parity == 1) begin
                        if (in == 1) begin
                            state <= STOP;
                        end else begin
                            state <= ERROR;
                        end
                    end else begin
                        if (in == 0) begin
                            state <= STOP;
                        end else begin
                            state <= ERROR;
                        end
                    end
                end
                STOP: begin
                    if (in) begin // Correct stop bit
                        out_byte <= shift_reg[8:1];
                        done <= 1;
                        state <= DONE;
                    end else begin
                        state <= ERROR;
                    end
                end
                DONE: begin
                    done <= 0;
                    state <= IDLE;
                end
                ERROR: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule