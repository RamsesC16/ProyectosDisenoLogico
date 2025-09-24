# Nombre del proyecto
**Proyecto 1**: Diseño digital combinacional en
dispositivos programables. 
**Integrantes del grupo**: Julio David Quesada Hernández y Ramses Cortes Torres 
El propósito de este proyecto fue familiarizarse con herramientas fundamentales en el campo de la electrónica y la ingeniería en general, específicamente el uso del lenguaje de descripción de hardware (HDL) y su aplicación práctica mediante una FPGA para el desarrollo de sistemas digitales.
## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Ars
### 1.1 Descripción de proyecto y diagramas generales
El sistema desarrollado corresponde a un circuito digital orientado a la recuperación de información, implementado mediante el código de Hamming y descrito en SystemVerilog a partir de lógica combinacional. Su funcionamiento parte de dos entradas principales: una palabra de referencia y una palabra transmitida.

Mediante la aplicación del algoritmo de Hamming, el circuito comprueba la presencia de posibles errores en la palabra transmitida. Si se detecta un error de un solo bit, este se corrige automáticamente y la palabra resultante es decodificada para su visualización en un display de siete segmentos. Paralelamente, la palabra de referencia es mostrada en los LEDs de la FPGA, lo que permite realizar una comparación directa entre ambos valores.

Para organizar su diseño, el sistema se ha dividido en subsistemas funcionales, lo que facilita su construcción y comprensión. En términos generales, se identifican dos bloques principales:

Subsistema de procesamiento: encargado de la codificación, verificación, detección y corrección de errores, así como de la decodificación de las palabras según el algoritmo de Hamming.

Subsistema de visualización: responsable de presentar los resultados obtenidos en los dispositivos de salida (LEDs y displays de siete segmentos).

Finalmente, en la figura siguiente se ilustra el esquema de interconexión entre estos subsistemas.
<img width="1296" height="666" alt="image" src="https://github.com/user-attachments/assets/f6adce4b-153c-49e5-8a70-e31fabaa07b4" />
En el desarrollo del sistema, cada módulo se considera como un bloque de lógica combinacional, y su funcionamiento se organiza según la siguiente estructura de interconexión entre los distintos bloques:
<img width="1541" height="349" alt="image" src="https://github.com/user-attachments/assets/9cccb431-c14c-4315-b9b2-04cc50ba01a5" />
### 1.2 Desarrollo de los Módulos del Sistema

A continuación, se describen los módulos que conforman el sistema implementado para la codificación, detección y corrección de errores basado en el algoritmo de Hamming SEC-DED (Single Error Correction – Double Error Detection).

## Módulo Top

Es el módulo principal que integra todos los submódulos del sistema. Recibe como entradas la palabra original y la palabra recibida, gestiona la detección y corrección de errores, y entrega los datos corregidos tanto en LEDs como en displays de siete segmentos. Además, mediante un interruptor externo, permite alternar entre la visualización de la palabra corregida y la indicación de error detectado.

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

## Módulo Codificador

Implementa el esquema de codificación Hamming(7,4) con bit de paridad global adicional, logrando un sistema SEC-DED. A partir de 4 bits de datos, el módulo produce una palabra de 8 bits que contiene: los bits de datos originales, tres bits de paridad de Hamming y un bit de paridad general. De esta manera, la palabra queda protegida contra errores simples y dobles.

module module_codi (
    input  logic [3:0] datos_in,   // Entrada de 4 bits [3,2,1,0]
    output logic [7:0] datos_cod   // Salida de 8 bits [7..0]
);

// Mapeo de posiciones en el vector de salida datos_cod:
// datos_cod[0] = p1 (c0) -> paridad sobre d1,d2,d4
// datos_cod[1] = p2 (c1) -> paridad sobre d1,d3,d4
// datos_cod[2] = d1      -> bit de dato 0
// datos_cod[3] = p3 (c2) -> paridad sobre d2,d3,d4
// datos_cod[4] = d2      -> bit de dato 1
// datos_cod[5] = d3      -> bit de dato 2
// datos_cod[6] = d4      -> bit de dato 3
// datos_cod[7] = p0      -> paridad global de todo el código (bits 0..6)

// Asignación de los datos originales
assign datos_cod[2] = datos_in[0]; // d1
assign datos_cod[4] = datos_in[1]; // d2
assign datos_cod[5] = datos_in[2]; // d3
assign datos_cod[6] = datos_in[3]; // d4

// Bits de paridad de Hamming(7,4)
assign datos_cod[0] = datos_in[0] ^ datos_in[1] ^ datos_in[3]; // p1
assign datos_cod[1] = datos_in[0] ^ datos_in[2] ^ datos_in[3]; // p2
assign datos_cod[3] = datos_in[1] ^ datos_in[2] ^ datos_in[3]; // p3

// Bit de paridad global (XOR de todos los 7 bits anteriores)
assign datos_cod[7] = datos_cod[0] ^ datos_cod[1] ^ datos_cod[2] ^
                      datos_cod[3] ^ datos_cod[4] ^ datos_cod[5] ^ datos_cod[6];

endmodule

## Módulo Comparador

Define una interfaz de comparación entre palabras codificadas, pero en esta implementación no contiene lógica funcional. Puede ser empleado como base para verificar equivalencias entre la palabra transmitida y la palabra recibida.

module comparador(
    input  logic [6:0] data_paridad, 
    input  logic [6:0] comparacion
);
endmodule

## Módulo Detector de Error

Implementa la lógica de detección de errores mediante el cálculo del síndrome de Hamming y la evaluación de la paridad global. Sus salidas permiten identificar si no existen errores, si ocurrió un error simple o si se detecta un error doble. En conjunto con el corrector, garantiza la robustez del sistema frente a fallas en la transmisión.

module module_detector_error(
    input  logic [7:0] datos_recibidos,  // Entrada de 8 bits [p1,p2,d1,p3,d2,d3,d4,p0]
    output logic [2:0] sindrome,         // Síndrome de error (p2,p1,p0)
    output logic       paridad_global,   // Paridad global (1 = número impar de 1s)
    output logic       bit_error,        // Señal general de error (1 = hay error)
    output logic       error_doble       // Señal de error doble detectado
);

    // Cálculo del síndrome (Hamming base)
    assign sindrome[0] = datos_recibidos[0] ^ datos_recibidos[2] ^ datos_recibidos[4] ^ datos_recibidos[6]; // p1
    assign sindrome[1] = datos_recibidos[1] ^ datos_recibidos[2] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p2
    assign sindrome[2] = datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^ datos_recibidos[6]; // p3

    // Cálculo de la paridad global (XOR de todos los bits 0..7)
    assign paridad_global = datos_recibidos[0] ^ datos_recibidos[1] ^ datos_recibidos[2] ^
                            datos_recibidos[3] ^ datos_recibidos[4] ^ datos_recibidos[5] ^
                            datos_recibidos[6] ^ datos_recibidos[7];

    // Señales de error
    // bit_error = hay síndrome o la paridad global indica un número impar de 1s
    assign bit_error   = (sindrome != 3'b000) || (paridad_global == 1'b1);
    // error_doble = hay síndrome pero la paridad global indica número par -> doble error detectado
    assign error_doble = (sindrome != 3'b000) && (paridad_global == 1'b0);

endmodule

## Módulo Corrector de Error

Este bloque recibe como entradas la palabra recibida, el síndrome de error y la paridad global. Su función es corregir automáticamente errores simples de un solo bit, incluyendo el caso en que el error se encuentre en el bit de paridad global. Si se detecta un error doble, el módulo no realiza correcciones pero genera una señal de advertencia. Asimismo, distingue entre las condiciones de error simple, error doble y ausencia de error mediante banderas de salida.

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

## Módulo Decodificador

Extrae los 4 bits de información original a partir de la palabra codificada de 8 bits, eliminando los bits de paridad. Este proceso se realiza después de la etapa de corrección de errores, asegurando que los datos obtenidos correspondan a la versión libre de errores.

module module_decodi ( 
    input  logic [7:0] datos_cod,   // Entrada de 8 bits [p0,i3,i2,i1,c2,i0,c1,c0]
    output logic [3:0] datos_out    // Salida de 4 bits [i3,i2,i1,i0]
);

// Mapeo (igual que en el encoder):
// datos_cod[0] = p1 (c0)
// datos_cod[1] = p2 (c1)
// datos_cod[2] = d1 = i0
// datos_cod[3] = p3 (c2)
// datos_cod[4] = d2 = i1
// datos_cod[5] = d3 = i2
// datos_cod[6] = d4 = i3
// datos_cod[7] = p0 (paridad global)

// Extracción de bits de datos
assign datos_out[0] = datos_cod[2]; // i0
assign datos_out[1] = datos_cod[4]; // i1
assign datos_out[2] = datos_cod[5]; // i2
assign datos_out[3] = datos_cod[6]; // i3

endmodule

## Módulo 7 Segmentos

Este módulo implementa un decodificador hexadecimal a display de siete segmentos. Recibe como entrada un valor de 4 bits y genera el patrón de activación de los segmentos necesarios para representar los dígitos hexadecimales de 0 a F. En caso de recibir un valor inválido, el display se apaga.

module module_7segmentos (
    input  logic [3:0] data,      // Entrada: valor en hex (0–F)
    output logic [6:0] display    // Salida: segmentos [a..g]
);

    always_comb begin
        case (data)
            4'h0: display = 7'b0000001; // 0
            4'h1: display = 7'b1001111; // 1
            4'h2: display = 7'b0010010; // 2
            4'h3: display = 7'b0000110; // 3
            4'h4: display = 7'b1001100; // 4
            4'h5: display = 7'b0100100; // 5
            4'h6: display = 7'b0100000; // 6
            4'h7: display = 7'b0001111; // 7
            4'h8: display = 7'b0000000; // 8
            4'h9: display = 7'b0000100; // 9
            4'hA: display = 7'b0001000; // A
            4'hB: display = 7'b1100000; // b
            4'hC: display = 7'b0110001; // C
            4'hD: display = 7'b1000010; // d
            4'hE: display = 7'b0110000; // E
            4'hF: display = 7'b0111000; // F
            default: display = 7'b1111111; // apagado
        endcase
    end

endmodule

## Módulo Display de Error

Convierte la información del estado de error en un valor hexadecimal que se muestra en un display de siete segmentos. Representa con “E” un error doble, con un número del 1 al 7 la posición del bit erróneo en caso de error simple, y con “0” la condición de ausencia de error. Este módulo reutiliza la lógica de module_7segmentos para generar los patrones de salida.

module module_display_error (
    input  logic [2:0] sindrome,      // Síndrome de error (posición bit 0..7 en 3 bits)
    input  logic       error_simple,  // Flag: error simple corregido
    input  logic       error_doble,   // Flag: error doble no corregible
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

    // Reutiliza el decodificador de hex a 7-seg
    module_7segmentos seg_decoder (
        .data(value_hex),
        .display(display)
    );

endmodule

## Módulo LEDs

Permite visualizar en formato binario los 4 bits de la palabra corregida mediante LEDs. En esta implementación los LEDs son activos bajos, por lo que las salidas se encuentran invertidas respecto a los datos.

module module_led (
    input  logic [3:0] in,   // datos originales corregidos (4 bits)
    output logic [3:0] out   // LEDs de la TangNano 9k (salida)
);

    // Si los LEDs son activos bajos en la placa, mantenemos la inversión:
    assign out = ~in;

endmodule

## Módulo MUX

Selecciona cuál información será enviada al display de siete segmentos según el estado del sistema. En caso de error doble, prioriza la visualización del código de error; en presencia de error simple o ausencia de error, muestra la palabra corregida. También puede depender de una señal externa de control para alternar entre la palabra y el error.

module module_mux(
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

## 1.3 Testbench

## Testbench top
El testbench del top valida la integración de todos los módulos del sistema SEC-DED, generando estímulos de prueba que incluyen datos correctos y con errores. Permite comprobar la codificación, detección, corrección y visualización de errores, asegurando que el sistema completo funcione de forma coherente.

`timescale 1ns/1ns

module module_top_tb;

    // Entradas al top
    reg  [3:0] entrada;       // palabra original (4 bits)
    reg  [7:0] palabra_rx;    // palabra recibida con posible error (8 bits)
    reg        select_pos;    // switch: 0=mostrar palabra; 1=mostrar error (posicion/sindrome)

    // Salidas del top
    wire [6:0] seg;           // segmentos compartidos (a..g)
    wire [1:0] an;            // enables de displays (an[0]=izq, an[1]=der)
    wire [3:0] led_out;       // LEDs palabra corregida
    wire       led_ded;       // indicador DED

    // Instancio el codificador para generar el código correcto desde 'entrada'
    wire [7:0] encoded;
    module_codi enc (
        .datos_in(entrada),
        .datos_cod(encoded)
    );

    // DUT
    module_top dut (
        .entrada(entrada),
        .palabra_rx(palabra_rx),
        .select_pos(select_pos),
        .seg(seg),
        .an(an),
        .led_out(led_out),
        .led_ded(led_ded)
    );

    // rutina de pruebas
    initial begin
        $display("Time | entrada | palabra_rx | select | led_out | led_ded | seg | an");
        $display("-----+---------+------------+--------+---------+---------+-----+----");

        // Prueba 1: sin error
        entrada = 4'b0101; #2;         // establece datos
        palabra_rx = encoded; #5;      // palabra recibida = codificación perfecta
        select_pos = 0; #10;
        $display("%4t |  %b  | %b |   %b    |  %b  |    %b   | %b | %b", $time, entrada, palabra_rx, select_pos, led_out, led_ded, seg, an);

        // Prueba 2: error simple (cambiar 1 bit en palabra_rx)
        palabra_rx = encoded ^ 8'b0000_0100; #10; // ejemplo: flip del bit 2
        select_pos = 0; #10;
        $display("%4t |  %b  | %b |   %b    |  %b  |    %b   | %b | %b", $time, entrada, palabra_rx, select_pos, led_out, led_ded, seg, an);

        // Prueba 3: mostrar posición de error en display (select=1)
        select_pos = 1; #10;
        $display("%4t |  %b  | %b |   %b    |  %b  |    %b   | %b | %b", $time, entrada, palabra_rx, select_pos, led_out, led_ded, seg, an);

        // Prueba 4: doble error (no corregible)
        palabra_rx = encoded ^ 8'b0000_1100; #10; // example: flip de 2 bits
        select_pos = 0; #10;
        $display("%4t |  %b  | %b |   %b    |  %b  |    %b   | %b | %b", $time, entrada, palabra_rx, select_pos, led_out, led_ded, seg, an);

        #20;
        $finish;
    end

    initial begin
        $dumpfile("module_top_tb.vcd");
        $dumpvars(0, module_top_tb);
    end

endmodule
<img width="603" height="169" alt="image" src="https://github.com/user-attachments/assets/e99b6058-e957-42d6-a164-7abb8abbaf7e" />

## 1.4 Consumo de recursos 
<img width="374" height="602" alt="image" src="https://github.com/user-attachments/assets/775449db-81b4-468d-ba7e-afed7a6a1fe9" />

## 1.5 Problemas encontrados 
Durante la implementación física del circuito en la FPGA se presentaron diversos inconvenientes que impidieron su correcto funcionamiento. Aunque la palabra de entrada sin error lograba visualizarse adecuadamente, el display de 7 segmentos destinado a mostrar el síndrome nunca funcionó como se esperaba. Adicionalmente, el switch encargado de seleccionar entre la visualización de la palabra corregida y la del síndrome presentó fallas, por lo que terminó utilizándose únicamente como un puente: al estar conectado mostraba el display del síndrome y al desconectarse mostraba la palabra corregida. A pesar de que los 7 segmentos encendían, las combinaciones desplegadas carecían de sentido.
## 2. Informe parte 2 del proyecto 1
[Ver Proyecto1_Parte2.pdf](Proyecto1_Parte2.pdf)

## 3. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3


