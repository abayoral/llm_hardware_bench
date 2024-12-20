module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire [15:0] sum0_carry0, sum0_carry1, sum1, sum2;
    wire cout0_carry0, cout0_carry1, cout1, cout2;
    
    // Lower 16 bits additions with carry-in 0 and 1
    add16 add_lower0 (a[15:0], b[15:0], 1'b0, sum0_carry0, cout0_carry0);
    add16 add_lower1 (a[15:0], b[15:0], 1'b1, sum0_carry1, cout0_carry1);
    
    // Select the correct lower 16 bits based on carry-out
    mux2_1 mux_lower (sum0_carry0, sum0_carry1, cout0_carry0, sum[15:0]);
    
    // Upper 16 bits additions based on carry-out of lower bit additions
    add16 add_upper0 (a[31:16], b[31:16], cout0_carry0, sum1, cout1);
    add16 add_upper1 (a[31:16], b[31:16], cout0_carry1, sum2, cout2);
    
    // Select the correct upper 16 bits based on carry-out
    mux2_1 mux_upper (sum1, sum2, cout0_carry0, sum[31:16]);

endmodule