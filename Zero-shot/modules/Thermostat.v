module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater logic
    assign heater = mode & too_cold;

    // Air conditioner logic
    assign aircon = ~mode & too_hot;

    // Fan logic
    assign fan = heater | aircon | fan_on;

endmodule