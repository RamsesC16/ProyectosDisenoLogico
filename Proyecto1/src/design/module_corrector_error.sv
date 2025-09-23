module module_corrector_error(
    input  logic [7:0] datos_recibidos,   // [p1,p2,d1,p4,d2,d3,d4,p0]
    input  logic [2:0] sindrome,          // {p4,p2,p1}
    input  logic       paridad_global,    // 1 = número impar de 1s
    input  logic       error_doble_i,     // de detector
    output logic [7:0] datos_corregidos,  // palabra corregida
    output logic       error_simple,      // 1 = error de un bit corregido
    output logic       no_error           // 1 = sin error
);

    always_comb begin
        // Por defecto, salida = entrada
        datos_corregidos = datos_recibidos;
        error_simple     = 1'b0;
        no_error         = 1'b0;

        if (sindrome == 3'b000 && paridad_global == 1'b0) begin
            // Caso: sin error
            no_error = 1'b1;

        end else if (sindrome == 3'b000 && paridad_global == 1'b1) begin
            // Caso: error solo en p0 (bit 7)
            datos_corregidos[7] = ~datos_recibidos[7];
            error_simple = 1'b1;

        end else if (sindrome != 3'b000 && paridad_global == 1'b1) begin
            // Caso: error de un bit en posiciones 1..7
            // El valor binario de sindrome indica la posición (1–7)
            // Restamos 1 porque el vector es [0..6]
            datos_corregidos[sindrome-1] = ~datos_recibidos[sindrome-1];
            error_simple = 1'b1;

        end else if (error_doble_i) begin
            // Caso: error doble detectado -> no corregir
            // datos_corregidos queda igual
        end
    end

endmodule