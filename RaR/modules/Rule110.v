module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            reg [511:0] new_q;
            integer i;
            for (i = 0; i < 512; i = i + 1) begin
                if (i == 0) begin
                    // For the leftmost cell
                    new_q[i] = (q[1] == 1'b1 && q[0] == 1'b0) || // 011 -> 1
                               (q[0] == 1'b1 && q[1] == 1'b0) || // 010 -> 1, 011 -> 1
                               (q[1] == 1'b1); // 011 -> 1, 111 -> 0
                end else if (i == 511) begin
                    // For the rightmost cell
                    new_q[i] = (q[510] == 1'b1 && q[511] == 1'b0) || // 110 -> 1, 011 -> 1
                               (q[510] == 1'b0 && q[511] == 1'b1) || // 111 -> 0, 011 -> 1
                               (q[510] == 1'b0); // 100 -> 0, 000 -> 0
                end else begin
                    // General case for cells in the middle
                    new_q[i] = (q[i-1] == 1'b1 && q[i] == 1'b0 && q[i+1] == 1'b0) || // 100 -> 0
                               (q[i-1] == 1'b1 && q[i] == 1'b0 && q[i+1] == 1'b1) || // 101 -> 1
                               (q[i-1] == 1'b1 && q[i] == 1'b1 && q[i+1] == 1'b0) || // 110 -> 1
                               (q[i-1] == 1'b0 && q[i] == 1'b1); // 010 -> 1, 011 -> 1
                end
            end
            q <= new_q;
        end
    end

endmodule