module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg done);

    // Define states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    // State flip-flops (sequential)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State transition logic (combinational)
    always_comb begin
        next_state = state;
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
            end

            BYTE1: begin
                next_state = BYTE2;
            end

            BYTE2: begin
                next_state = BYTE3;
            end

            BYTE3: begin
                next_state = IDLE;
                done = 1'b1;
            end
        endcase
    end
endmodule