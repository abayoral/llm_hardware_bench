module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_cd;
    
    // Find the minimum of a and b
    assign min_ab = (a < b) ? a : b;

    // Find the minimum of c and d
    assign min_cd = (c < d) ? c : d;
    
    // Find the minimum of the previous results
    assign min = (min_ab < min_cd) ? min_ab : min_cd;
    
endmodule