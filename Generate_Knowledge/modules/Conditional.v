module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min
);

    wire [7:0] min1, min2;

    // Find the minimum between a and b
    assign min1 = (a < b) ? a : b;

    // Find the minimum between c and d
    assign min2 = (c < d) ? c : d;

    // Find the minimum between min1 and min2
    assign min = (min1 < min2) ? min1 : min2;

endmodule