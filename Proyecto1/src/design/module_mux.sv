module module_mux(
    input  logic [6:0] siete_seg,   // display de la palabra corregida
    input  logic [6:0] error,       // display de error/síndrome
    input  logic       swi,         // switch: 0 = palabra, 1 = error
    input  logic       error_simple,
    input  logic       error_doble,
    input  logic       no_error,
    output logic [6:0] salida_mux
);

    always_comb begin
        if (error_doble) begin
            salida_mux = error;       // mostrar "E"
        end else if (error_simple || no_error) begin
            salida_mux = siete_seg;   // palabra corregida
        end else begin
            salida_mux = swi ? error : siete_seg; // fallback
        end
    end

endmodule