module modulo_detector_error(
    input  logic [7:0] datos_recibidos,  // Entrada de 8 bits [p0,i3,i2,i1,c2,i0,c1,c0]
    output logic [2:0] sindrome,         // Síndrome de error (p2,p1,p0)
    output logic       bit_error,        // Señal general de error (1 = hay error)
    output logic       error_doble       // Señal de error doble detectado
);

// Cálculo del síndrome (igual que en Hamming(7,4))
assign sindrome[0] = datos_recibidos[0] ^ datos_recibidos[2] ^ datos_recibidos[4] ^ datos_recibidos[6]; // p1
assign sindrome[1] = datos_recibidos[1] ^ datos_recibidos[2] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p2
assign sindrome[2] = datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p3

// Cálculo de la paridad global
logic paridad_global;
assign paridad_global = datos_recibidos[0] ^ datos_recibidos[1] ^ datos_recibidos[2] ^
                        datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^
                        datos_recibidos[6] ^ datos_recibidos[7];

// Señales de error
assign bit_error   = (sindrome != 3'b000) || (paridad_global == 1);
assign error_doble = (sindrome != 3'b000) && (paridad_global == 0);

endmodule