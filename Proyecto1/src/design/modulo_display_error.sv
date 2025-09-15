module module_display_error (
    input  logic [2:0] sindrome,      // Síndrome de error (posición del bit)
    input  logic       error_simple,  // Flag: error simple
    input  logic       error_doble,   // Flag: error doble
    input  logic       no_error,      // Flag: sin error
    output logic [6:0] display        // Salida hacia display de 7 segmentos
);

    logic [3:0] value_hex; // Valor intermedio en hex

    always_comb begin
        if (error_doble) begin
            value_hex = 4'hE;  // Mostrar "E" en caso de doble error
        end
        else if (error_simple) begin
            value_hex = {1'b0, sindrome}; // Mostrar la posición de error (0–7)
        end
        else if (no_error) begin
            value_hex = 4'h0;  // Mostrar "0" si no hay error
        end
        else begin
            value_hex = 4'hF;  // Estado indefinido → "F"
        end
    end

    // Instancia del decodificador 4→7 segmentos
    module_7segmentos seg_decoder (
        .data(value_hex),
        .display(display)
    );

endmodule