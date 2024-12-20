module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in; // Register to store the previous state of input

    always @(posedge clk) begin
        anyedge <= (in & ~prev_in); // Detecting the 0 to 1 edge for each bit
        prev_in <= in; // Storing the current input state for the next clock cycle
    end

endmodule