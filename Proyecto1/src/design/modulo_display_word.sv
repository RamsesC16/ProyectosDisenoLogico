module modulo_display_word (
    input  logic [3:0] datos_word,   // palabra de 4 bits (corregida)
    output logic [6:0] display       // salida a 7 segmentos
);

    // Reutiliza el decodificador genérico
    modulo_7segmentos hex_display (
        .data(datos_word),
        .display(display)
    );

endmodule