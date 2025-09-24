module module_top_test (
    input  logic [3:0] entrada,   // switches de entrada
    output logic [3:0] led_out    // LEDs integrados
);

    // Los LEDs de la TangNano son activos-bajo.
    // Invertimos la señal: switch arriba = LED encendido.
    assign led_out = ~entrada;

endmodule