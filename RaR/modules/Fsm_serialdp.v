module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
);
    reg [3:0] state, next_state;
    reg [7:0] data;
    reg [3:0] bit_count;
    reg [1:0] stop_count;
    wire parity_odd;
    reg parity_reset;
    reg parity_in;
    reg done_reg;
    
    localparam IDLE        = 4'b0000,
               START       = 4'b0001,
               DATA        = 4'b0010,
               PARITY      = 4'b0011,
               STOP        = 4'b0100,
               WAIT_STOP   = 4'b0101;
    
    // Instantiate the parity module
    parity parity_inst (
        .clk(clk),
        .reset(parity_reset),
        .in(parity_in),
        .odd(parity_odd)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            stop_count <= 0;
            parity_reset <= 1;
        end else begin
            state <= next_state;
            if (next_state == DATA) bit_count <= bit_count + 1;
            else if (next_state == PARITY) bit_count <= 0;

            if (next_state == STOP) stop_count <= stop_count + 1;
            else if (next_state == IDLE) stop_count <= 0;

            if (next_state == START) parity_reset <= 1;
            else if (next_state == DATA) parity_reset <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        done_reg = 0;
        parity_in = 0;

        case (state)
            IDLE: begin
                if (!in) next_state = START;  // Detect the start bit
            end
            START: begin
                next_state = DATA;  // Move to the data state
            end
            DATA: begin
                parity_in = in;
                if (bit_count == 8) next_state = PARITY;  // After receiving 8 data bits, move to the parity state
            end
            PARITY: begin
                if (parity_odd == in) next_state = STOP;  // Check the parity; if correct, move to stop state
                else next_state = WAIT_STOP;  // If parity check fails, wait for the stop bit
            end
            STOP: begin
                if (in) begin
                    done_reg = 1;
                    next_state = IDLE;  // If stop bit is correct, signal done and return to idle
                end
                else next_state = WAIT_STOP;  // Otherwise, wait until stop bit is detected
            end
            WAIT_STOP: begin
                if (in) next_state = IDLE;  // Wait for the stop bit before returning to idle
            end
        endcase
    end
    
    // Capture the received byte when done is asserted
    always @(posedge clk) begin
        if (state == DATA && bit_count < 8) 
            data[bit_count] <= in;
    end

    assign out_byte = data;
    assign done = done_reg;
endmodule