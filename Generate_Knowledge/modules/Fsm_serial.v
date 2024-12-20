module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 
    // Define state encoding
    typedef enum reg [2:0] {
        IDLE,
        START_BIT, 
        DATA_BITS,
        STOP_BIT
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] data;

    // Next state logic
    always @(*) begin
        done = 0;
        next_state = state;
        
        case (state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = DATA_BITS;
                bit_counter = 0;
            end

            DATA_BITS: begin
                if (bit_counter == 7)
                    next_state = STOP_BIT;
                else
                    bit_counter = bit_counter + 1;
            end

            STOP_BIT: begin
                if (in == 1) begin // Stop bit detected
                    done = 1;
                    next_state = IDLE;
                end else
                    next_state = IDLE; // Error, wait for idle (stop bit)
            end

            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            if (state == DATA_BITS) begin
                data[bit_counter] <= in;
            end
        end
    end
endmodule