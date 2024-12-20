module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);

    wire [7:0] min1, min2;

    // Compare a and b
    assign min1 = (a < b) ? a : b;
    // Compare c and d
    assign min2 = (c < d) ? c : d;
    // Compare the results of the first two comparisons to get the final min
    assign min = (min1 < min2) ? min1 : min2;

endmodule