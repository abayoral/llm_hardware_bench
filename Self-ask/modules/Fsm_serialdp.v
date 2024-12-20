module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
); 
    // Declare state encoding
    typedef enum logic [2:0] {IDLE, START_WAIT, DATA_WAIT, PARITY_WAIT, STOP_WAIT} state_t;

    state_t state, next_state;
    reg [3:0] bit_count;  // Since we need to count up to 9 bits (0 to 8)
    reg [7:0] data;       // To store the received byte
    wire odd;
    reg parity_reset;

    // Instantiate parity checker
    parity parity_checker (
        .clk(clk),
        .reset(parity_reset),
        .in(in),
        .odd(odd)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;  // Default to hold state
        case (state)
            IDLE: begin
                if (in == 0)  // Start bit detected
                    next_state = START_WAIT;
            end
            START_WAIT: begin
                if (bit_count == 1)
                    next_state = DATA_WAIT;
            end
            DATA_WAIT: begin
                if (bit_count == 9)  // Move to parity wait after 8 data bits
                    next_state = PARITY_WAIT;
            end
            PARITY_WAIT: begin
                next_state = STOP_WAIT;
            end
            STOP_WAIT: begin
                if (in == 1)  // Expected stop bit
                    next_state = IDLE;
            end
        endcase
    end

    // Bit count and data handling
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
            data <= 0;
            out_byte <= 0;
            done <= 0;
            parity_reset <= 1;  // Reset parity checker
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    parity_reset <= 1;  // Reset parity checker
                end
                START_WAIT: begin
                    parity_reset <= 0;  // Start parity checking
                    if (bit_count == 1)
                        bit_count <= 0;  // Move to data
                end
                DATA_WAIT: begin
                    bit_count <= bit_count + 1;
                    if (bit_count < 8) begin
                        data[bit_count] <= in;
                    end
                end
                PARITY_WAIT: begin
                    // Parity bit is received here, update parity checker
                end
                STOP_WAIT: begin
                    if (in == 1) begin
                        if (odd) begin
                            out_byte <= data;
                            done <= 1;
                        end
                        parity_reset <= 1;  // Reset parity checker for next byte
                        bit_count <= 0;
                    end
                end
            endcase
        end
    end
endmodule