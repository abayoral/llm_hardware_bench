module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

integer i;  // Row index
integer j;  // Column index
integer ni; // Neighbor row index
integer nj; // Neighbor column index
integer neighbor_count;
reg [3:0] neighbors; // For storing the number of neighbors

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate the number of neighbors
                neighbor_count = 0;
                for (ni = i-1; ni <= i+1; ni = ni + 1) begin
                    for (nj = j-1; nj <= j+1; nj = nj + 1) begin
                        if (!(ni == i && nj == j)) begin
                            // Use modulo operation for wrapping
                            neighbor_count = neighbor_count + q[(16*((ni+16)%16) + (nj+16)%16)];
                        end
                    end
                end

                // Apply the Game of Life rules
                if (q[16*i + j] == 1) begin
                    // Currently alive
                    if (neighbor_count < 2 || neighbor_count > 3) begin
                        next_q[16*i + j] = 0; // Dies
                    end else begin
                        next_q[16*i + j] = 1; // Stays alive
                    end
                end else begin
                    // Currently dead
                    if (neighbor_count == 3) begin
                        next_q[16*i + j] = 1; // Becomes alive
                    end else begin
                        next_q[16*i + j] = 0; // Stays dead
                    end
                end
            end
        end
        // Update the state
        q <= next_q;
    end
end

endmodule