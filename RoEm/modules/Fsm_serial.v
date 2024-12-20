module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 

    // Define FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b10,
        STOP = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] data_byte;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
            data_byte <= 8'b00000000;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            if (state == START || state == DATA) begin
                bit_counter <= bit_counter + 1;
            end
            else if (state == STOP) begin
                bit_counter <= 3'b000;
            end
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit
                    next_state = START;
            end

            START: begin
                if (bit_counter == 3'b000) // Ensure it stays in START state for one cycle
                    next_state = DATA;
            end

            DATA: begin
                if (bit_counter == 3'b111) begin // After 8 bits of data
                    next_state = STOP;
                end
            end

            STOP: begin
                if (in == 1'b1) begin // Validate stop bit
                    done = 1'b1;
                    next_state = IDLE;
                end
                else begin // Wait until a valid stop bit is detected
                    next_state = STOP;
                end
            end
        endcase
    end
endmodule