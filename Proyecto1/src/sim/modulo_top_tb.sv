`timescale 1ns/1ns

module modulo_top_tb;

    // Entradas
    reg  [3:0] entrada;       // palabra original (4 bits)
    reg  [7:0] palabra_rx;    // palabra recibida con posible error
    reg        select_pos;    // switch: 0=palabra, 1=error

    // Salidas
    wire [6:0] display_left;
    wire [6:0] display_right;
    wire [3:0] led_out;
    wire       led_ded;

    // Instancia del DUT
    modulo_top dut (
        .entrada(entrada),
        .palabra_rx(palabra_rx),
        .select_pos(select_pos),
        .display_left(display_left),
        .display_right(display_right),
        .led_out(led_out),
        .led_ded(led_ded)
    );

    // Procedimiento de prueba
    initial begin
        $display("Tiempo | Entrada | Recibida  | LEDS | LED_DED | DispL | DispR | Select");
        $display("-------|---------|-----------|------|---------|-------|-------|-------");

        // Caso 1: Palabra sin error (0001 -> debería corregir igual)
        entrada    = 4'b0001;
        palabra_rx = 8'b0001_0011; // codificación válida (ejemplo)
        select_pos = 0; #20;
        $display("%4t  |  %b  |  %b  |  %b  |    %b   |  %b |  %b |   %b",
                 $time, entrada, palabra_rx, led_out, led_ded,
                 display_left, display_right, select_pos);

        // Caso 2: Error simple (flip en un bit de la palabra_rx)
        palabra_rx = 8'b0001_0010; // mismo que antes pero un bit alterado
        select_pos = 0; #20;
        $display("%4t  |  %b  |  %b  |  %b  |    %b   |  %b |  %b |   %b",
                 $time, entrada, palabra_rx, led_out, led_ded,
                 display_left, display_right, select_pos);

        // Caso 3: Mostrar error simple en display derecho
        select_pos = 1; #20;
        $display("%4t  |  %b  |  %b  |  %b  |    %b   |  %b |  %b |   %b",
                 $time, entrada, palabra_rx, led_out, led_ded,
                 display_left, display_right, select_pos);

        // Caso 4: Error doble (no corregible)
        palabra_rx = 8'b1101_0010; // se alteran 2 bits
        select_pos = 0; #20;
        $display("%4t  |  %b  |  %b  |  %b  |    %b   |  %b |  %b |   %b",
                 $time, entrada, palabra_rx, led_out, led_ded,
                 display_left, display_right, select_pos);

        // Fin de simulación
        #20;
        $finish;
    end

    initial begin
        $dumpfile("modulo_top_tb.vcd");
        $dumpvars(0, modulo_top_tb);
    end

endmodule