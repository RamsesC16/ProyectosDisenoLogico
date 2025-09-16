module modulo_detector_error(
    input  logic [7:0] datos_recibidos,  // Entrada de 8 bits [p1,p2,d1,p3,d2,d3,d4,p0]
    output logic [2:0] sindrome,         // Síndrome de error (p2,p1,p0)
    output logic       paridad_global,   // Paridad global (1 = número impar de 1s)
    output logic       bit_error,        // Señal general de error (1 = hay error)
    output logic       error_doble       // Señal de error doble detectado
);

    // Cálculo del síndrome (Hamming base)
    assign sindrome[0] = datos_recibidos[0] ^ datos_recibidos[2] ^ datos_recibidos[4] ^ datos_recibidos[6]; // p1
    assign sindrome[1] = datos_recibidos[1] ^ datos_recibidos[2] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p2
    assign sindrome[2] = datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p3

    // Cálculo de la paridad global (XOR de todos los bits 0..7)
    assign paridad_global = datos_recibidos[0] ^ datos_recibidos[1] ^ datos_recibidos[2] ^
                            datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^
                            datos_recibidos[6] ^ datos_recibidos[7];

    // Señales de error
    // bit_error = hay síndrome o la paridad global indica un número impar de 1s
    assign bit_error   = (sindrome != 3'b000) || (paridad_global == 1'b1);
    // error_doble = hay síndrome pero la paridad global indica número par -> doble error detectado
    assign error_doble = (sindrome != 3'b000) && (paridad_global == 1'b0);

endmodule