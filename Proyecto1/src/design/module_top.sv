module module_top (
    input  logic [3:0] entrada,       // palabra original (4 bits desde switches)
    input  logic [7:0] palabra_rx,    // palabra recibida/alterada (8 bits desde switches)
    input  logic       select_pos,    // switch: 0 => mostrar palabra; 1 => mostrar posición de error
    output logic [6:0] seg,           // segmentos compartidos (a..g)
    output logic [1:0] an,            // enable de los dos displays (a través de dip-switch hacia ánodos)
    output logic [3:0] led_out,       // LEDs: palabra corregida
    output logic       led_ded        // LED extra para doble error
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

    // Detector de error
    module_detector_error detector (
        .datos_recibidos(palabra_rx),
        .sindrome(sindrome),
        .paridad_global(paridad_global),
        .bit_error(bit_error),
        .error_doble(error_doble)
    );

    // Corrector de error
    module_corrector_error corrector (
        .sindrome(sindrome),
        .datos_recibidos(palabra_rx),
        .paridad_global(paridad_global),
        .datos_corregidos(corregido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .no_error(no_error)
    );

    // Decodificador de palabra corregida
    module_decodi decod (
        .datos_cod(corregido),
        .datos_out(datos_out)
    );

    // LEDs para la palabra corregida
    module_led leds_mod (
        .in(datos_out),
        .out(led_out)
    );
    assign led_ded = error_doble;

    // Conversión de palabra a 7 segmentos
    logic [6:0] seg_word;
    module_7segmentos seg_word_inst (
        .data(datos_out),
        .display(seg_word)
    );

    // Conversión del error/síndrome a 7 segmentos
    logic [6:0] seg_error;
    module_display_error seg_error_inst (
        .sindrome(sindrome),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .no_error(no_error),
        .display(seg_error)
    );

    // MUX para decidir qué patrón se envía a los segmentos
    always_comb begin
        if (select_pos == 1'b0) begin
            seg = seg_word;   // mostrar palabra
            an  = 2'b10;      // habilita display izquierdo (dip-switch debe estar ON)
        end else begin
            seg = seg_error;  // mostrar posición de error
            an  = 2'b01;      // habilita display derecho (dip-switch debe estar ON)
        end
    end

endmodule