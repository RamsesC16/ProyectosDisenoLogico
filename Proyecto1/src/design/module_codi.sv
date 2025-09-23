module module_codi (
    input  logic [3:0] datos_in,   // Entrada de 4 bits [i3,i2,i1,i0]
    output logic [7:0] datos_cod   // Salida de 8 bits [p1,p2,d1,p4,d2,d3,d4,p0]
);

    // Asignación de los datos originales
    assign datos_cod[2] = datos_in[0]; // d1 = i0
    assign datos_cod[4] = datos_in[1]; // d2 = i1
    assign datos_cod[5] = datos_in[2]; // d3 = i2
    assign datos_cod[6] = datos_in[3]; // d4 = i3

    // Bits de paridad de Hamming(7,4)
    // p1 cubre posiciones 1,3,5,7 → d1,d2,d4
    assign datos_cod[0] = datos_in[0] ^ datos_in[1] ^ datos_in[3];

    // p2 cubre posiciones 2,3,6,7 → d1,d3,d4
    assign datos_cod[1] = datos_in[0] ^ datos_in[2] ^ datos_in[3];

    // p4 cubre posiciones 4,5,6,7 → d2,d3,d4
    assign datos_cod[3] = datos_in[1] ^ datos_in[2] ^ datos_in[3];

    // Bit de paridad global (XOR de todos los 7 bits anteriores)
    assign datos_cod[7] = datos_cod[0] ^ datos_cod[1] ^ datos_cod[2] ^
                          datos_cod[3] ^ datos_cod[4] ^ datos_cod[5] ^ datos_cod[6];

endmodule