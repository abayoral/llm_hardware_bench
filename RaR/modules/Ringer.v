module top_module (
    input ring,
    input vibrate_mode,
    output ringer,       // Activate the sound ringer
    output motor         // Activate the vibration motor
);

    // Output logic:
    // Activate the motor when ring is 1 and vibrate_mode is 1
    assign motor = ring & vibrate_mode;
    
    // Activate the ringer when ring is 1 and vibrate_mode is 0
    assign ringer = ring & ~vibrate_mode;

endmodule