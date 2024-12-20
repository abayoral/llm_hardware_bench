module top_module(
    input clk,
    input in,
    input areset,
    output out);

    // State encoding
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;
    
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            STATE_B: begin
                if (in == 1'b0)
                    next_state = STATE_C;
                else
                    next_state = STATE_B;
            end
            STATE_C: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_D;
            end
            STATE_D: begin
                if (in == 1'b0)
                    next_state = STATE_C;
                else
                    next_state = STATE_B;
            end
            default: next_state = STATE_A; // default state
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == STATE_D) ? 1'b1 : 1'b0;

endmodule