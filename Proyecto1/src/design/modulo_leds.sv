module module_leds (
    input  logic [3:0] datos_out, // datos originales corregidos (4 bits)
    output logic [3:0] leds       // 4 LEDs de la TangNano 9k
);

    // Mostrar los 4 bits en los LEDs (activos bajos en la mayoría de FPGAs)
    assign leds[0] = ~datos_out[0];
    assign leds[1] = ~datos_out[1];
    assign leds[2] = ~datos_out[2];
    assign leds[3] = ~datos_out[3];

endmodule