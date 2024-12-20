module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
);

    localparam IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;

    reg [2:0] state, next_state;
    reg [7:0] data;
    reg [3:0] bit_counter;

    wire parity_odd;
    reg parity_bit, stop_bit;
    
    // Instantiation of the parity calculating module
    parity parity_inst (
        .clk(clk),
        .reset(reset | (next_state == IDLE)),
        .in(in),
        .odd(parity_odd)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 0;
            bit_counter <= 0;
            parity_bit <= 0;
            stop_bit <= 0;
        end else begin
            state <= next_state;

            if (state == DATA) begin
                data <= {in, data[7:1]};     // Shift in the new bit
                bit_counter <= bit_counter + 1;
            end else if (state == PARITY) begin
                parity_bit <= in;
            end else if (state == STOP) begin
                stop_bit <= in;
            end else if (state == IDLE) begin
                bit_counter <= 0;
                data <= 0;
                parity_bit <= 0;
                stop_bit <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in == 0) next_state = START;
            START: next_state = (in == 0) ? DATA : IDLE;
            DATA: if (bit_counter == 8) next_state = PARITY;
            PARITY: next_state = STOP;
            STOP: next_state = (in == 1) ? IDLE : START;
        endcase
    end

    assign out_byte = data;
    assign done = (state == STOP) && (in == 1) && (parity_odd == 1);

endmodule