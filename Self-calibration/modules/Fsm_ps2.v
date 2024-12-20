module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = state; // Default state transition
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic
    assign done = (state == DONE);

endmodule