module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer i, j, ni, nj;

    // Next state of the grid
    reg [255:0] next_q;

    // Count alive neighbors for a given cell
    function [3:0] count_neighbors(
        input [255:0] grid,
        input integer x,
        input integer y
    );
        integer dx, dy, nx, ny;
        reg [3:0] count;
        begin
            count = 0;
            for (dx = -1; dx <= 1; dx = dx + 1) begin
                for (dy = -1; dy <= 1; dy = dy + 1) begin
                    if (dx != 0 || dy != 0) begin
                        nx = (x + dx + 16) % 16;  // wrap around horizontally
                        ny = (y + dy + 16) % 16;  // wrap around vertically
                        if (grid[nx + 16*ny] == 1)
                            count = count + 1;
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    always @(*) begin
        // Compute next state based on current state
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                case (count_neighbors(q, i, j))
                    2: next_q[i + 16*j] = q[i + 16*j];  // 2 neighbors, stay the same
                    3: next_q[i + 16*j] = 1;           // 3 neighbors, become alive
                    default: next_q[i + 16*j] = 0;     // 0-1 or 4+ neighbors, become dead
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            // Load the new data on load signal
            q <= data;
        end else begin
            // Otherwise, advance the state
            q <= next_q;
        end
    end
endmodule