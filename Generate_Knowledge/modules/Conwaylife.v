module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    // Function to calculate the number of live neighbors for a given cell
    function automatic [3:0] count_neighbors(
        input [255:0] grid,
        input [3:0] x,
        input [3:0] y
    );
        integer i, j;
        reg [3:0] nx, ny;
        begin
            count_neighbors = 0;
            for (i = -1; i <= 1; i = i + 1) begin
                for (j = -1; j <= 1; j = j + 1) begin
                    if (!(i == 0 && j == 0)) begin
                        nx = (x + i) & 4'hF; // Wrap around using bit masking
                        ny = (y + j) & 4'hF; // Wrap around using bit masking
                        count_neighbors = count_neighbors + grid[nx * 16 + ny];
                    end
                end
            end
        end
    endfunction

    // Always block to update the grid state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            integer x, y;
            for (x = 0; x < 16; x = x + 1) begin
                for (y = 0; y < 16; y = y + 1) begin
                    // Calculate the number of live neighbors
                    case (count_neighbors(q, x, y))
                        4'd2: next_q[x * 16 + y] = q[x * 16 + y]; // Maintain the same state
                        4'd3: next_q[x * 16 + y] = 1;  // Cell becomes alive
                        default: next_q[x * 16 + y] = 0; // Cell becomes dead
                    endcase
                end
            end
            q <= next_q;
        end
    end

endmodule