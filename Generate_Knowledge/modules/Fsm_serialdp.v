module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);
    // FSM State Definitions
    typedef enum reg [2:0] {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP,
        DONE
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_cnt;    // Bit counter for tracking received bits
    reg [7:0] shift_reg;  // Shift register to store received data bits
    wire odd_parity;      // Parity check output

    // Instantiate parity module
    parity parity_check(
        .clk(clk),
        .reset(reset || state == IDLE),
        .in(in),
        .odd(odd_parity)
    );

    // State transition logic
    always @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                done = 0;
                if (in == 0) 
                    next_state = START;  // Start bit detected
            end
            START: begin
                if (bit_cnt == 0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 7)
                    next_state = PARITY;
            end
            PARITY: begin
                if (odd_parity == in) 
                    next_state = STOP;
                else 
                    next_state = IDLE;  // Parity failed, go back to IDLE
            end
            STOP: begin
                if (in == 1) 
                    next_state = DONE;  // Stop bit detected
                else 
                    next_state = IDLE;  // Stop bit failed, go back to IDLE
            end
            DONE: begin
                done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
      
    // Output and Bit counter logic
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 0;
            shift_reg <= 0;
        end
        else if (state == START) 
            bit_cnt <= 0;  // Reset bit counter at start
        else if (state == DATA) begin
            shift_reg <= {in, shift_reg[7:1]}; // Shift in the new bit
            bit_cnt <= bit_cnt + 1;
        end
    end

    // Output assignment
    always @(posedge clk) begin
        if (state == DONE)
            out_byte <= shift_reg;
    end
    
endmodule