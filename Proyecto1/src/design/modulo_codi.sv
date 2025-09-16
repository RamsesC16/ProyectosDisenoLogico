module module_codificador (
    input  logic [3:0] datos_in,   // Entrada de 4 bits [3,2,1,0]
    output logic [7:0] datos_cod   // Salida de 8 bits [7..0]
);

// Mapeo de posiciones en el vector de salida datos_cod:
// datos_cod[0] = p1 (c0) -> paridad sobre d1,d2,d4
// datos_cod[1] = p2 (c1) -> paridad sobre d1,d3,d4
// datos_cod[2] = d1      -> bit de dato 0
// datos_cod[3] = p3 (c2) -> paridad sobre d2,d3,d4
// datos_cod[4] = d2      -> bit de dato 1
// datos_cod[5] = d3      -> bit de dato 2
// datos_cod[6] = d4      -> bit de dato 3
// datos_cod[7] = p0      -> paridad global de todo el código (bits 0..6)

// Asignación de los datos originales
assign datos_cod[2] = datos_in[0]; // d1
assign datos_cod[4] = datos_in[1]; // d2
assign datos_cod[5] = datos_in[2]; // d3
assign datos_cod[6] = datos_in[3]; // d4

// Bits de paridad de Hamming(7,4)
assign datos_cod[0] = datos_in[0] ^ datos_in[1] ^ datos_in[3]; // p1
assign datos_cod[1] = datos_in[0] ^ datos_in[2] ^ datos_in[3]; // p2
assign datos_cod[3] = datos_in[1] ^ datos_in[2] ^ datos_in[3]; // p3

// Bit de paridad global (XOR de todos los 7 bits anteriores)
assign datos_cod[7] = datos_cod[0] ^ datos_cod[1] ^ datos_cod[2] ^
                      datos_cod[3] ^ datos_cod[4] ^ datos_cod[5] ^ datos_cod[6];

endmodule