module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up);

    always @(*) begin
        // Initialize all outputs to 0.
        up = 1'b0; 
        down = 1'b0; 
        left = 1'b0; 
        right = 1'b0;

        // Determine which arrow key, if any, is pressed based on scancode.
        case (scancode)
            16'he06b: left = 1'b1;   // Left arrow key
            16'he072: down = 1'b1;   // Down arrow key
            16'he074: right = 1'b1;  // Right arrow key
            16'he075: up = 1'b1;     // Up arrow key
            default: begin
                left = 1'b0;
                down = 1'b0;
                right = 1'b0;
                up = 1'b0;  
            end
        endcase
    end
endmodule