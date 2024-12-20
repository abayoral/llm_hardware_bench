module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 

    // State definitions
    typedef enum reg [2:0] {
        IDLE,       // Waiting for the start bit
        START,      // Start bit detected, waiting for data bits
        DATA,       // Receiving data bits
        STOP,       // Stop bit detection
        ERROR       // Error state, waiting for stop bit
    } state_t;
    
    state_t state, next_state;
    reg [2:0] bit_count; // To count the data bits received

    // Synchronous state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
        end else begin
            state <= next_state;
            if (state == DATA)
                bit_count <= bit_count + 1;
            else
                bit_count <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default is to remain in current state
        done = 0;           // Default output

        case (state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1) begin // Correct stop bit
                    done = 1;
                    next_state = IDLE;
                end else begin // Incorrect stop bit
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1) // Correct stop bit found in error state
                    next_state = IDLE;
            end
        endcase
    end
endmodule