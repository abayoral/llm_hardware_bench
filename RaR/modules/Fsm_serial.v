module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 

    // State declaration
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        DONE = 3'b100
    } state_t;
    
    state_t current_state, next_state;

    reg [2:0] bit_counter;
    reg [7:0] data_byte;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 0;
            data_byte <= 8'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == DATA) begin
                data_byte[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
            end
            if (next_state == DONE) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (!in) // Start bit detected
                    next_state = START;
            end
            START: begin
                next_state = DATA;
                bit_counter = 0;
            end
            DATA: begin
                if (bit_counter == 8)
                    next_state = STOP;
            end
            STOP: begin
                if (in) // Stop bit detected
                    next_state = DONE;
                else
                    next_state = IDLE;
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule