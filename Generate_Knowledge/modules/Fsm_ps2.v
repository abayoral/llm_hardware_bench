module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg done
);
    // States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE_1 = 2'b01,
        BYTE_2 = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE_1;
                else
                    next_state = IDLE;
            end
            BYTE_1: next_state = BYTE_2;
            BYTE_2: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic (combinational)
    always @(*) begin
        done = (current_state == DONE);
    end

endmodule