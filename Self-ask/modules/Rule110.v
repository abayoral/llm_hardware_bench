module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    
    always @(*) begin
        next_q[0] = (q[1] == 1 && q[0] == 0) || (q[1] == 0 && q[0] == 1); // Careful with boundaries
        next_q[511] = (q[510] == 1 && q[511] == 0) || (q[510] == 0 && q[511] == 1); // Careful with boundaries
        for (integer i = 1; i < 511; i = i + 1) begin
            next_q[i] = (q[i-1] == 1 && q[i] == 1 && q[i+1] == 0) ||
                        (q[i-1] == 1 && q[i] == 0 && q[i+1] == 1) ||
                        (q[i-1] == 0 && q[i] == 1);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
    
endmodule