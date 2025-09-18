module module_corrector_error( 
    input  logic [2:0] sindrome,         // Síndrome de error
    input  logic [7:0] datos_recibidos,  // Palabra recibida
    input  logic       paridad_global,   // Señal de paridad global (1=error detectado)
    output logic [7:0] datos_corregidos, // Palabra corregida
    output logic       error_simple,     // Flag: error de un solo bit corregido
    output logic       error_doble,      // Flag: error doble detectado
    output logic       no_error          // Flag: palabra sin error
);

always_comb begin
    // Por defecto
    datos_corregidos = datos_recibidos;
    error_simple = 0;
    error_doble  = 0;
    no_error     = 0;

    // Caso 1: error en paridad global
    if (sindrome == 3'b000 && paridad_global == 1) begin
        datos_corregidos[7] = ~datos_recibidos[7];
        error_simple = 1;
    end
    // Caso 2: error simple en [0..6]
    else if (sindrome != 3'b000 && paridad_global == 1) begin
        case (sindrome)
            3'b001: datos_corregidos[0] = ~datos_recibidos[0];
            3'b010: datos_corregidos[1] = ~datos_recibidos[1];
            3'b011: datos_corregidos[2] = ~datos_recibidos[2];
            3'b100: datos_corregidos[3] = ~datos_recibidos[3];
            3'b101: datos_corregidos[4] = ~datos_recibidos[4];
            3'b110: datos_corregidos[5] = ~datos_recibidos[5];
            3'b111: datos_corregidos[6] = ~datos_recibidos[6];
        endcase
        error_simple = 1;
    end
    // Caso 3: error doble
    else if (sindrome != 3'b000 && paridad_global == 0) begin
        error_doble = 1;
    end
    // Caso 4: sin error
    else begin
        no_error = 1;
    end
end

endmodule