module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011, CHECK = 3'b100;
    
    reg [2:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // FSM: State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM: Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit (0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count < 3'd7)
                    next_state = DATA;
                else
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) // Detect stop bit (1)
                    next_state = CHECK;
                else
                    next_state = IDLE;
            end
            CHECK: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // FSM: Output and datapath logic
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                end
                START: begin
                    bit_count <= 3'd0; // reset bit counter
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift in data bits
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // Do nothing, wait for stop bit
                end
                CHECK: begin
                    out_byte <= shift_reg; // latch the received byte
                    done <= 1'b1; // signal that a byte has been received
                end
            endcase
        end
    end

endmodule