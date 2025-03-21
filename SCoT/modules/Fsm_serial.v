module top_module (
    input wire clk,
    input wire reset,
    input wire in,
    output reg done
);

    // State definition
    typedef enum logic [2:0] {
        IDLE    = 3'b000,
        START   = 3'b001,
        DATA0   = 3'b010,
        DATA1   = 3'b011,
        DATA2   = 3'b100,
        DATA3   = 3'b101,
        DATA4   = 3'b110,
        DATA5   = 3'b111,
        DATA6   = 3'b110,
        DATA7   = 3'b111,
        STOP    = 3'b011,
        ERROR   = 3'b100
    } state_t;
    
    // State and bit counter register
    state_t state, next_state;
    reg [2:0] bit_counter;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b000;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;  // Default state remains the same
        done = 1'b0;  // Default done signal is low
        
        case (state)
            IDLE: begin
                if (in == 1'b0)  // Start bit detected
                    next_state = START;
            end
            START: begin
                next_state = DATA0;
            end
            DATA0: begin
                next_state = DATA1;
            end
            DATA1: begin
                next_state = DATA2;
            end
            DATA2: begin
                next_state = DATA3;
            end
            DATA3: begin
                next_state = DATA4;
            end
            DATA4: begin
                next_state = DATA5;
            end
            DATA5: begin
                next_state = DATA6;
            end
            DATA6: begin
                next_state = DATA7;
            end
            DATA7: begin
                next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) begin  // Stop bit correct
                    done = 1'b1;
                    next_state = IDLE;
                end else begin  // Stop bit incorrect
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1)  // Wait until the line is idle (stop bit detected)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule