module modulo_decodi ( 
    input  logic [7:0] datos_cod,   // Entrada de 8 bits [p0,i3,i2,i1,c2,i0,c1,c0]
    output logic [3:0] datos_out    // Salida de 4 bits [i3,i2,i1,i0]
);

// Mapeo (igual que en el encoder):
// datos_cod[0] = p1 (c0)
// datos_cod[1] = p2 (c1)
// datos_cod[2] = d1 = i0
// datos_cod[3] = p3 (c2)
// datos_cod[4] = d2 = i1
// datos_cod[5] = d3 = i2
// datos_cod[6] = d4 = i3
// datos_cod[7] = p0 (paridad global)

// Extracción de bits de datos
assign datos_out[0] = datos_cod[2]; // i0
assign datos_out[1] = datos_cod[4]; // i1
assign datos_out[2] = datos_cod[5]; // i2
assign datos_out[3] = datos_cod[6]; // i3

endmodule