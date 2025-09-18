module modulo_led (
    input  logic [3:0] in,   // datos originales corregidos (4 bits)
    output logic [3:0] out   // LEDs de la TangNano 9k (salida)
);

    // Si los LEDs son activos bajos en la placa, mantenemos la inversión:
    assign out = ~in;

endmodule