module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 

    // Heater should be on only in heating mode and only when it is too cold
    assign heater = mode & too_cold;

    // Air conditioner should be on only in cooling mode and only when it is too hot
    assign aircon = ~mode & too_hot;

    // Fan should be on whenever the heater is on, the air conditioner is on, or when fan_on is set
    assign fan = heater | aircon | fan_on;

endmodule