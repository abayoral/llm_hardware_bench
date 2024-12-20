module top_module ( 
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
    );

    // This always block should define the combinational logic for the multiplexer.
    always @(*) begin 
        // Use a case statement to determine the output based on the value of 'sel'.
        case(sel)
            // Include cases for sel = 0 to sel = 5 to select the appropriate data input.
            3'b000: out = data0;
            3'b001: out = data1;
            3'b010: out = data2;
            3'b011: out = data3;
            3'b100: out = data4;
            3'b101: out = data5;
            // Provide a default case to ensure 'out' is 0 for any sel value outside the range of 0 to 5.
            default: out = 4'b0000;
        endcase
    end

endmodule