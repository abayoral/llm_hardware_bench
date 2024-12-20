module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal register for storing the result
    reg [N-1:0] res;

    // Extend sign for correct subtraction
    wire signed [N:0] ext_a = {a[N-1], a};
    wire signed [N:0] ext_b = {b[N-1], b};

    always @(*) begin
        // Perform subtraction
        res[N-1:0] = ext_a - ext_b;

        // Assign result
        c = res[N-1:0];

        // Handle the zero case explicitly: If result is zero, set sign bit to 0
        if (res[N-1:0] == 0) begin
            c[N-1] = 0;
        end
    end

endmodule