module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg done); //
    
    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        BYTE1   = 2'b01,
        BYTE2   = 2'b10,
        BYTE3   = 2'b11
    } state_t;
    
    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1)    // Look for the first byte with bit[3] = 1
                    next_state = BYTE1;
                else
                    next_state = IDLE;
                done = 0;
            end
            BYTE1: begin
                next_state = BYTE2;
                done = 0;
            end
            BYTE2: begin
                next_state = BYTE3;
                done = 0;
            end
            BYTE3: begin
                next_state = IDLE; // After the third byte, go back to IDLE
                done = 1;          // Signal done for one cycle
            end
            default: begin
                next_state = IDLE;
                done = 0;
            end
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule