module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);

    // Intermediate results
    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Find min between a and b
    assign min_ab = (a < b) ? a : b;
    
    // Find min between c and d
    assign min_cd = (c < d) ? c : d;

    // Find min between min_ab and min_cd
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule