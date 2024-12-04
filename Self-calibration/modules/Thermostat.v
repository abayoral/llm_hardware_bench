module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
); 

    // Heater is on in heating mode and if it is too cold
    assign heater = (mode && too_cold);

    // Air conditioner is on in cooling mode and if it is too hot
    assign aircon = (~mode && too_hot);

    // Fan is on if either heater or air conditioner is on, or if fan_on is requested
    assign fan = (heater || aircon || fan_on);

endmodule