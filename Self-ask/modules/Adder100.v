module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum
);
    
    // Internal signal for carry
    wire [99:0] carry;

    // Assign the first carry-in
    assign carry[0] = cin;

    // Generate the sum and carry for each bit
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin: adder
            if (i == 0) begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign carry[i + 1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
            end else if (i == 99) begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign cout = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
            end else begin
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                assign carry[i + 1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
            end
        end
    endgenerate
    
endmodule