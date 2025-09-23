module module_top (
    input  logic        clk,           // si multiplexas displays, necesitas reloj
    input  logic        rst_n,
    input  logic [3:0]  entrada,       // palabra original (4b switches)
    input  logic [7:0]  palabra_rx,    // palabra recibida (8b switches)
    input  logic        select_pos_i,  // switch: 0 => palabra; 1 => posición error
    output logic [6:0]  seg,           // segmentos hacia pines (activo-bajo)
    output logic [1:0]  an,            // enable dígitos hacia pines (activo-bajo)
    output logic [3:0]  led_out,       // LEDs integrados (ajusta polaridad)
    output logic        led_ded        // LED doble error
);

    // 1) Sincroniza el selector
    logic select_pos;
    always_ff @(posedge clk or negedge rst_n) begin
      if(!rst_n) select_pos <= 1'b0;
      else       select_pos <= select_pos_i;
    end

    // 2) Codificar palabra de referencia (transmitida)
    logic [7:0] palabra_tx;
    module_codi u_codi (
        .datos_in (entrada),
        .datos_cod(palabra_tx)
    );

    // 3) Comparador (si sigues la especificación “transmitida vs recibida”)
    // Opcional según tu arquitectura; si tu detector calcula todo desde palabra_rx, puedes omitirlo.
    // module_comparador u_comp (
    //     .tx(palabra_tx),
    //     .rx(palabra_rx),
    //     .p1_mismatch(...), .p2_mismatch(...), .p4_mismatch(...),
    //     .p0_mismatch(...)
    // );

    // 4) Detector de errores (desde recibida: recomputa paridades y arma síndrome)
    logic [2:0] sindrome;
    logic       paridad_global;  // P = p0_rx ^ p0_re
    logic       error_doble_i;
    module_detector_error u_det (
        .datos_recibidos (palabra_rx),
        .sindrome        (sindrome),
        .paridad_global  (paridad_global),
        .error_doble     (error_doble_i)
        // .bit_error(...) si lo necesitas
    );

    assign led_ded = error_doble_i;

    // 5) Corrector (usa info del detector; NO debe manejar la misma net de error_doble)
    logic [7:0] corregido;
    logic       error_simple, no_error;
    module_corrector_error u_corr (
        .sindrome        (sindrome),
        .datos_recibidos (palabra_rx),
        .paridad_global  (paridad_global),
        .error_doble_i   (error_doble_i),  // entrada
        .datos_corregidos(corregido),
        .error_simple    (error_simple),
        .no_error        (no_error)
    );

    // 6) Decodificar datos (4b) desde palabra corregida
    logic [3:0] datos_out;
    module_decodi u_dec (
        .datos_cod (corregido),
        .datos_out (datos_out)
    );

    // 7) LEDs (ajusta polaridad si son activos-bajo)
    module_led u_led (
        .in (datos_out),
        .out(led_out)     // si son activos-bajo: asigna ~interno en este módulo
    );

    // 8) 7-seg: palabra corregida (hex) y síndrome/estado
    logic [6:0] seg_word_int, seg_error_int;
    module_7segmentos   u_7seg_word  (.data(datos_out), .display(seg_word_int));
    module_display_error u_7seg_error (.sindrome(sindrome),
                                       .error_simple(error_simple),
                                       .error_doble(error_doble_i),
                                       .no_error(no_error),
                                       .display(seg_error_int));

    // 9) MUX de lo que se muestra y activación de dígitos (activo-bajo)
    // Por diseño del enunciado: un solo dígito encendido según el selector.
    always_comb begin
        if (!select_pos) begin
            seg = ~seg_word_int;   // común ánodo -> activo-bajo
            an  = 2'b10;           // 0 = ON, 1 = OFF (ajusta cuál es “izquierdo/derecho”)
        end else begin
            seg = ~seg_error_int;
            an  = 2'b01;
        end
    end

endmodule