module module_detector_error(
    input  logic [7:0] datos_recibidos,  // [p1,p2,d1,p4,d2,d3,d4,p0]
    output logic [2:0] sindrome,         // {p4,p2,p1}
    output logic       paridad_global,   // 1 = número impar de 1s
    output logic       bit_error,        // 1 = hay error
    output logic       error_doble       // 1 = error doble detectado
);

    // Recalcular paridades locales
    logic p1_calc, p2_calc, p4_calc, p0_calc;
    assign p1_calc = datos_recibidos[0] ^ datos_recibidos[2] ^ datos_recibidos[4] ^ datos_recibidos[6];
    assign p2_calc = datos_recibidos[1] ^ datos_recibidos[2] ^ datos_recibidos[5] ^ datos_recibidos[6];
    assign p4_calc = datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^ datos_recibidos[6];
    assign p0_calc = datos_recibidos[0] ^ datos_recibidos[1] ^ datos_recibidos[2] ^
                     datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^
                     datos_recibidos[6];

    // Síndrome en orden clásico {p4,p2,p1}
    assign sindrome = {datos_recibidos[3] ^ p4_calc,
                       datos_recibidos[1] ^ p2_calc,
                       datos_recibidos[0] ^ p1_calc};

    // Paridad global (XOR de todos los bits, incluido p0)
    assign paridad_global = ^datos_recibidos;

    // Señales de error
    assign bit_error   = (sindrome != 3'b000) || paridad_global;
    assign error_doble = (sindrome != 3'b000) && (paridad_global == 1'b0);

endmodule