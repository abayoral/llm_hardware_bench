module top_module (
        input wire [7:0] in,
        output reg [2:0] pos
    );

    // Priority encoder logic: Check each bit from least significant to most significant
    always @(*) begin
        pos = 3'd0;
        for (integer i = 0; i < 8; i = i+1) begin
            if (in[i]) begin
                pos = i;
                break;
            end
        end
    end
    endmodule