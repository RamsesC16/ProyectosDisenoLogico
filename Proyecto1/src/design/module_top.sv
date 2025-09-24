module module_top (
    input  logic [3:0]  entrada,       // palabra original (4b switches)
    input  logic [7:0]  palabra_rx,    // palabra recibida (8b switches)
    input  logic        select_pos,    // switch: 0 => palabra original; 1 => error/síndrome
    output logic [6:0]  seg,           // segmentos hacia pines (activo-bajo)
    output logic [1:0]  an,            // enable dígitos hacia pines (activo-bajo)
    output logic [3:0]  led_out,       // LEDs integrados
    output logic        led_ded        // LED doble error
);

    // 1) Codificar palabra de referencia (transmitida)
    logic [7:0] palabra_tx;
    module_codi u_codi (
        .datos_in (entrada),
        .datos_cod(palabra_tx)
    );

    // 2) Detector de errores
    logic [2:0] sindrome;
    logic       paridad_global;
    logic       error_doble_i;
    module_detector_error u_det (
        .datos_recibidos (palabra_rx),
        .sindrome        (sindrome),
        .paridad_global  (paridad_global),
        .error_doble     (error_doble_i)
    );

    assign led_ded = error_doble_i;

    // 3) Corrector
    logic [7:0] corregido;
    logic       error_simple, no_error;
    module_corrector_error u_corr (
        .sindrome        (sindrome),
        .datos_recibidos (palabra_rx),
        .paridad_global  (paridad_global),
        .error_doble_i   (error_doble_i),
        .datos_corregidos(corregido),
        .error_simple    (error_simple),
        .no_error        (no_error)
    );

    // 4) Decodificador
    logic [3:0] datos_out;
    module_decodi u_dec (
        .datos_cod (corregido),
        .datos_out (datos_out)
    );

    // 5) Selección de qué datos mostrar (entrada o corregido)
    logic [3:0] datos_mostrar;
    always_comb begin
        if (!select_pos)
            datos_mostrar = entrada;     // mostrar palabra original
        else
            datos_mostrar = datos_out;   // mostrar palabra corregida
    end

    // 6) LEDs
    module_led u_led (
        .in (datos_mostrar),
        .out(led_out)
    );

    // 7) Displays
    logic [6:0] seg_word_int, seg_error_int;
    module_7segmentos    u_7seg_word  (.data(datos_mostrar), .display(seg_word_int));
    module_display_error u_7seg_error (.sindrome(sindrome),
                                       .error_simple(error_simple),
                                       .error_doble(error_doble_i),
                                       .no_error(no_error),
                                       .display(seg_error_int));

    // 8) MUX de salida a displays
    always_comb begin
        if (!select_pos) begin
            seg = ~seg_word_int;   // común ánodo → activo-bajo
            an  = 2'b10;           // enciende dígito derecho
        end else begin
            seg = ~seg_error_int;
            an  = 2'b01;           // enciende dígito izquierdo
        end
    end

endmodule