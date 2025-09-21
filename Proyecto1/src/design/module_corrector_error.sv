module module_corrector_error( 
    input  logic [2:0] sindrome,         // Síndrome de error
    input  logic [7:0] datos_recibidos,  // Palabra recibida (8 bits)
    input  logic       paridad_global,   // Señal de paridad global
    input  logic       error_doble,      // Señal del detector (no se recalcula aquí)
    output logic [7:0] datos_corregidos, // Palabra corregida
    output logic       error_simple,     // Bandera de error simple corregible
    output logic       no_error          // Bandera de palabra sin error
);

    always_comb begin
        // Por defecto, salida = entrada
        datos_corregidos = datos_recibidos;
        error_simple     = 1'b0;
        no_error         = 1'b0;

        // Caso 1: síndrome = 000 y paridad_global = 1 → error en bit p0 (bit 7)
        if (sindrome == 3'b000 && paridad_global && !error_doble) begin
            datos_corregidos[7] = ~datos_recibidos[7];
            error_simple = 1'b1;
        end
        // Caso 2: síndrome ≠ 000 y paridad_global = 1 → error simple en bits [0..6]
        else if (sindrome != 3'b000 && paridad_global && !error_doble) begin
            case (sindrome)
                3'b001: datos_corregidos[0] = ~datos_recibidos[0];
                3'b010: datos_corregidos[1] = ~datos_recibidos[1];
                3'b011: datos_corregidos[2] = ~datos_recibidos[2];
                3'b100: datos_corregidos[3] = ~datos_recibidos[3];
                3'b101: datos_corregidos[4] = ~datos_recibidos[4];
                3'b110: datos_corregidos[5] = ~datos_recibidos[5];
                3'b111: datos_corregidos[6] = ~datos_recibidos[6];
            endcase
            error_simple = 1'b1;
        end
        // Caso 3: síndrome ≠ 000 y paridad_global = 0 → error doble (no se corrige)
        else if (sindrome != 3'b000 && !paridad_global && error_doble) begin
            datos_corregidos = datos_recibidos; // se deja igual
        end
        // Caso 4: sin error (sindrome = 000, paridad_global = 0)
        else if (sindrome == 3'b000 && !paridad_global && !error_doble) begin
            no_error = 1'b1;
        end
    end

endmodule