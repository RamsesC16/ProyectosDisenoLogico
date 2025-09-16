`timescale 1ns/1ns

module modulo_top_tb;

    reg  [3:0] entrada;
    reg  [7:0] palabra_rx;
    reg        select_pos;
    wire [6:0] display_left;
    wire [6:0] display_right;
    wire [3:0] led_out;

    // Instanciamos el top
    modulo_top dut (
        .entrada(entrada),
        .palabra_rx(palabra_rx),
        .select_pos(select_pos),
        .display_left(display_left),
        .display_right(display_right),
        .led_out(led_out)
    );

    initial begin
        $display("Tiempo | Entrada | Palabra RX | select_pos | LEDs | Disp_L | Disp_R");
        $display("-------|---------|------------|------------|------|--------|--------");

        // Caso 1: palabra sin error
        entrada    = 4'b1010;
        palabra_rx = 8'b01010101; // ejemplo válido
        select_pos = 0;
        #10;
        $display("%t | %b | %b | %b | %b | %b | %b",
                 $time, entrada, palabra_rx, select_pos, led_out, display_left, display_right);

        // Caso 2: error simple en bit 2
        palabra_rx = 8'b01010111; // alterado un bit
        select_pos = 1;
        #10;
        $display("%t | %b | %b | %b | %b | %b | %b",
                 $time, entrada, palabra_rx, select_pos, led_out, display_left, display_right);

        // Caso 3: error doble
        palabra_rx = 8'b01011111; // alterados dos bits
        select_pos = 1;
        #10;
        $display("%t | %b | %b | %b | %b | %b | %b",
                 $time, entrada, palabra_rx, select_pos, led_out, display_left, display_right);

        $finish;
    end

    initial begin
        $dumpfile("modulo_top_tb.vcd");
        $dumpvars(0, modulo_top_tb);
    end

endmodule