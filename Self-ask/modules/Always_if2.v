module top_module (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving  ); //

    // Fix the bug in the following code
    
    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1;
        else
            shut_off_computer = 0; // Ensure shut_off_computer is set to 0 when not overheated
    end

    always @(*) begin
        if (arrived || gas_tank_empty)
            keep_driving = 0; // Ensure keep_driving is set to 0 if arrived or gas tank is empty
        else
            keep_driving = 1;
    end

endmodule