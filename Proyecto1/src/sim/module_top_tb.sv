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