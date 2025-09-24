module module_decodi ( 
    input  logic [7:0] datos_cod,   // [p1,p2,d1,p4,d2,d3,d4,p0]
    output logic [3:0] datos_out    // [i3,i2,i1,i0]
);

    // Extracción de bits de datos 
    assign datos_out[0] = datos_cod[2]; // i0 (d1)
    assign datos_out[1] = datos_cod[4]; // i1 (d2)
    assign datos_out[2] = datos_cod[5]; // i2 (d3)
    assign datos_out[3] = datos_cod[6]; // i3 (d4)

endmodule