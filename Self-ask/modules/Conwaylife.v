module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q ); 

    reg [15:0][15:0] grid, next_grid;

    integer i, j;

    // Function to count the number of alive neighbors for cell (r, c)
    function [3:0] count_neighbors;
        input integer r, c;
        integer nr, nc, dr, dc;
        begin
            count_neighbors = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (dr != 0 || dc != 0) begin
                        nr = (r + dr + 16) % 16;
                        nc = (c + dc + 16) % 16;
                        if (grid[nr][nc]) begin
                            count_neighbors = count_neighbors + 1;
                        end
                    end
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    grid[i][j] = data[i*16 + j];
                end
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(i, j))
                        4'b0000, 4'b0001: next_grid[i][j] = 0;
                        4'b0010: next_grid[i][j] = grid[i][j];
                        4'b0011: next_grid[i][j] = 1;
                        default: next_grid[i][j] = 0;
                    endcase
                end
            end
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    grid[i][j] = next_grid[i][j];
                end
            end
        end
        
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                q[i*16 + j] = grid[i][j];
            end
        end
    end

endmodule