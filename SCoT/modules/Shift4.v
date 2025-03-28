module top_module (
    input wire clk,
    input wire areset,
    input wire load,
    input wire ena,
    input wire [3:0] data,
    output reg [3:0] q
);
    // Shift register logic with asynchronous reset and load capability
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 4'b0000;       // Asynchronous reset to zero
        else if (load)
            q <= data;          // Load data into the register
        else if (ena)
            q <= {1'b0, q[3:1]}; // Shift right with the most significant bit set to 0
    end
endmodule