module modulo_mux(
    input  logic [6:0] siete_seg,   // display de la palabra corregida
    input  logic [6:0] error,       // display de error/síndrome (incluye 'E' en caso de doble error)
    input  logic       swi,         // switch: 0 = mostrar palabra, 1 = mostrar error
    input  logic       error_simple,// flag: error simple detectado
    input  logic       error_doble, // flag: error doble detectado
    input  logic       no_error,    // flag: sin error
    output logic [6:0] salida_mux   // salida al display
);

    always_comb begin
        if (error_doble) begin
            // Error doble → mostrar display de error (síndrome = "E")
            salida_mux = error;
        end 
        else if (error_simple) begin
            // Error simple → siempre mostrar la palabra corregida
            salida_mux = siete_seg;
        end 
        else if (no_error) begin
            // Sin error → palabra corregida
            salida_mux = siete_seg;
        end 
        else begin
            // Caso raro → depende del switch
            salida_mux = swi ? error : siete_seg;
        end
    end

endmodule