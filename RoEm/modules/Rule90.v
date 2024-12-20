module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q );

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            integer i;
            reg [511:0] new_q;
            new_q[0] <= q[1]; // q[-1] is 0, hence next state of q[0] is q[1]
            for (i = 1; i < 511; i = i + 1) begin
                new_q[i] <= q[i-1] ^ q[i+1];
            end
            new_q[511] <= q[510]; // q[512] is 0, hence next state of q[511] is q[510]
            q <= new_q;
        end
    end
    
endmodule