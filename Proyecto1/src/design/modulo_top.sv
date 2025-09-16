module modulo_top (
    input  logic [3:0] entrada,       // palabra original (4 bits desde switches)
    input  logic [7:0] palabra_rx,    // palabra recibida/alterada (8 bits desde switches)
    input  logic       select_pos,    // switch: 0 => displays muestran palabra; 1 => derecho muestra error
    output logic [6:0] display_left,  // display izquierdo (palabra)
    output logic [6:0] display_right, // display derecho (palabra o error)
    output logic [3:0] led_out        // LEDs muestran la palabra corregida
);

    // Señales internas
    logic [7:0] corregido;     
    logic [3:0] datos_out;    
    logic [2:0] sindrome;     
    logic       paridad_global;
    logic       bit_error;
    logic       error_doble;
    logic       error_simple;
    logic       no_error;

    // Detector: calcula sindrome y paridad global
    modulo_detector_error detector (
        .datos_recibidos(palabra_rx),
        .sindrome(sindrome),
        .paridad_global(paridad_global),
        .bit_error(bit_error),
        .error_doble(error_doble)
    );

    // Corrector: corrige palabra_rx usando sindrome + paridad
    modulo_corrector_error corrector (
        .sindrome(sindrome),
        .datos_recibidos(palabra_rx),
        .paridad_global(paridad_global),
        .datos_corregidos(corregido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .no_error(no_error)
    );

    // Decodificador: obtiene los 4 bits de datos desde palabra corregida
    modulo_decodi decod (
        .datos_cod(corregido),
        .datos_out(datos_out)
    );

    // LEDs: muestran la palabra corregida
    modulo_led leds_mod (
        .in(datos_out),
        .out(led_out)
    );

    // Display izquierdo: siempre muestra la palabra recibida (HEX)
    modulo_7segmentos disp_word (
        .data(datos_out),
        .display(display_left)
    );

    // Display derecho: MUX entre palabra o error
    logic [6:0] seg_word;
    logic [6:0] seg_error;

    // Conversión de la palabra a display (como el izquierdo)
    modulo_7segmentos seg_word_inst (
        .data(datos_out),
        .display(seg_word)
    );

    // Conversión del error a display
    modulo_display_error seg_error_inst (
        .sindrome(sindrome),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .no_error(no_error),
        .display(seg_error)
    );

    // MUX para decidir qué mostrar en el display derecho
    always_comb begin
        if (select_pos == 1'b0) begin
            display_right = seg_word;   // mostrar palabra
        end else begin
            display_right = seg_error;  // mostrar error
        end
    end

endmodule