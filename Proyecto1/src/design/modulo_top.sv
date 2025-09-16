module modulo_top (
    input  logic [3:0] entrada,          // palabra original (4 bits desde switches)
    input  logic [7:0] palabra_rx,       // palabra recibida/alterada (8 bits desde switches)
    output logic [6:0] display_word,     // display de la palabra (hex)
    output logic [3:0] led_out,          // LEDs (palabra corregida)
    output logic [6:0] display_error     // display de error/sindrome
);

    // Señales internas
    logic [7:0] codificado;          // salida del codificador (8 bits)
    logic [7:0] corregido;           // palabra corregida (8 bits)
    logic [3:0] datos_out;           // palabra decodificada (4 bits)
    logic [2:0] sindrome;            // síndrome (3 bits)
    logic       bit_error;           // error simple o paridad
    logic       error_doble;         // error doble detectado
    logic       no_error;            // bandera sin error

    // ---------------------------
    // Codificación de la palabra original
    // ---------------------------
    modulo_codi codificador (
        .datos_in(entrada),
        .datos_cod(codificado)
    );

    // ---------------------------
    // Detector de error sobre palabra recibida
    // ---------------------------
    modulo_detector_error detector (
        .datos_recibidos(palabra_rx),
        .sindrome(sindrome),
        .bit_error(bit_error),
        .error_doble(error_doble)
    );

    // ---------------------------
    // Corrector de error
    // ---------------------------
    modulo_corrector_error corrector (
        .sindrome(sindrome),
        .datos_recibidos(palabra_rx),
        .paridad_global(bit_error), // se puede ajustar según salida detector
        .datos_corregidos(corregido)
    );

    // ---------------------------
    // Decodificador (de 8 bits a 4 bits originales)
    // ---------------------------
    modulo_decodi decodificador (
        .datos_cod(corregido),
        .datos_out(datos_out)
    );

    // ---------------------------
    // LEDs (muestran los 4 bits corregidos)
    // ---------------------------
    modulo_leds leds (
        .datos_out(datos_out),
        .leds(led_out)
    );

    // ---------------------------
    // Display de la palabra en hex
    // ---------------------------
    modulo_display_word disp_word (
        .datos_word(datos_out),
        .display(display_word)
    );

    // ---------------------------
    // Display del error (síndrome o E)
    // ---------------------------
    modulo_display_error disp_error (
        .sindrome(sindrome),
        .error_simple(bit_error),
        .error_doble(error_doble),
        .no_error(~bit_error & ~error_doble), // caso sin error
        .display(display_error)
    );

endmodule