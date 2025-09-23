module module_display_error (
    input  logic [2:0] sindrome,      // {p4,p2,p1}, valor 0–7
    input  logic       error_simple,
    input  logic       error_doble,
    input  logic       no_error,
    output logic [6:0] display        // activo-bajo (por module_7segmentos)
);

    logic [3:0] value_hex;

    always_comb begin
        if (error_doble) begin
            value_hex = 4'hE;              // "E"
        end else if (error_simple) begin
            value_hex = {1'b0, sindrome};  // posición 1–7
        end else if (no_error) begin
            value_hex = 4'h0;              // "0"
        end else begin
            value_hex = 4'hF;              // "F"
        end
    end

    // Reutiliza decodificador a 7 segmentos (ya activo-bajo)
    module_7segmentos seg_decoder (
        .data(value_hex),
        .display(display)
    );

endmodule