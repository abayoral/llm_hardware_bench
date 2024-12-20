module top_module(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out); //

    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;

    // State transition logic: next_state = f(state, in)
    always @(*) begin
        case(state)
            A: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: next_state = A; // Default state
        endcase
    end
    
    // Output logic:  out = f(state) for a Moore state machine
    always @(*) begin
        case(state)
            A: out = 0;
            B: out = 0;
            C: out = 0;
            D: out = 1;
            default: out = 0; // Default output
        endcase
    end

endmodule