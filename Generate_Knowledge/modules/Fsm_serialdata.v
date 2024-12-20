module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    typedef enum reg [2:0] {
        IDLE,       // Waiting for the start bit
        START,      // Start bit detected
        DATA,       // Receiving data bits
        STOP        // Stop bit verification
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;           // To count received bits (including start and stop bits)
    reg [7:0] data_shift_reg;      // Shift register to collect incoming data bits

    // Combinational logic for next state
    always @(*) begin
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0)  // Detect start bit
                    next_state = START;
            end

            START: begin
                next_state = DATA;
                bit_count = 0;
            end

            DATA: begin
                if (bit_count == 7)  // 8 bits received (0 to 7)
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1) begin  // Check for valid stop bit
                    next_state = IDLE;
                    done = 1;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            data_shift_reg <= 8'b0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA) begin
                data_shift_reg <= {in, data_shift_reg[7:1]};  // Shift in LSB first
                bit_count <= bit_count + 1;
            end else
                bit_count <= 0;

            if (done)
                out_byte <= data_shift_reg;  // Latch the data to output when done
        end
    end
endmodule