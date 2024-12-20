module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);

    wire c0, c1, c2, c3;

    decade_counter U0 (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .q(q[3:0]),
        .carry(c0)
    );

    assign ena[1] = c0;

    decade_counter U1 (
        .clk(clk),
        .reset(reset),
        .enable(c0),
        .q(q[7:4]),
        .carry(c1)
    );

    assign ena[2] = c1;

    decade_counter U2 (
        .clk(clk),
        .reset(reset),
        .enable(c1),
        .q(q[11:8]),
        .carry(c2)
    );

    assign ena[3] = c2;

    decade_counter U3 (
        .clk(clk),
        .reset(reset),
        .enable(c2),
        .q(q[15:12]),
        .carry(c3)
    );

endmodule