module modulo_corrector_error( 
    input  logic [2:0] sindrome,         // Entrada de 3 bits [p2,p1,p0]. Síndrome de error.
    input  logic [7:0] datos_recibidos,  // Entrada de 8 bits [p0,i3,i2,i1,c2,i0,c1,c0].
    input  logic       paridad_global,   // Señal de paridad global calculada en el detector
    output logic [7:0] datos_corregidos  // Salida de 8 bits corregidos
);

always_comb begin
    // Por defecto, salida = entrada
    datos_corregidos = datos_recibidos;

    // Caso 1: síndrome = 000 y paridad_global = 1 → error en el bit p0 (bit 7)
    if (sindrome == 3'b000 && paridad_global == 1) begin
        datos_corregidos[7] = ~datos_recibidos[7];
    end
    // Caso 2: síndrome ≠ 000 y paridad_global = 1 → error en uno de los bits [0..6]
    else if (sindrome != 3'b000 && paridad_global == 1) begin
        case (sindrome)
            3'b001: datos_corregidos[0] = ~datos_recibidos[0]; // Error en bit 0
            3'b010: datos_corregidos[1] = ~datos_recibidos[1]; // Error en bit 1
            3'b011: datos_corregidos[2] = ~datos_recibidos[2]; // Error en bit 2
            3'b100: datos_corregidos[3] = ~datos_recibidos[3]; // Error en bit 3
            3'b101: datos_corregidos[4] = ~datos_recibidos[4]; // Error en bit 4
            3'b110: datos_corregidos[5] = ~datos_recibidos[5]; // Error en bit 5
            3'b111: datos_corregidos[6] = ~datos_recibidos[6]; // Error en bit 6
            default: datos_corregidos = datos_recibidos;
        endcase
    end
    // Caso 3: síndrome ≠ 000 y paridad_global = 0 → error doble (no se corrige)
    else if (sindrome != 3'b000 && paridad_global == 0) begin
        datos_corregidos = datos_recibidos; // se deja igual
    end
    // Caso 4: sin error (sindrome = 000, paridad_global = 0) → salida = entrada
end

endmodule