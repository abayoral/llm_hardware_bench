module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    parameter A = 3'b0001, B = 3'b0010, C = 3'b0100, D = 3'b1000;

    // State transition logic
    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);
    assign next_state[B] = (state[A] & in) | (state[B] & in) | (state[D] & in);
    assign next_state[C] = (state[B] & ~in) | (state[D] & ~in);
    assign next_state[D] = (state[C] & in);

    // Output logic
    assign out = state[D];

endmodule