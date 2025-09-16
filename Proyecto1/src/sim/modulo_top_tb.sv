`timescale 1ns/1ns

module modulo_top_tb;

    // Entradas
    reg  [3:0] entrada;       // palabra original
    reg  [7:0] palabra_rx;    // palabra recibida/alterada

    // Salidas
    wire [6:0] display_word;  
    wire [3:0] led_out;       
    wire [6:0] display_error; 

    // Instancia del DUT
    modulo_top dut (
        .entrada(entrada),
        .palabra_rx(palabra_rx),
        .display_word(display_word),
        .led_out(led_out),
        .display_error(display_error)
    );

    // Variables internas para comparación
    reg [7:0] codificado_ref;

    initial begin
        $display("Tiempo | Entrada | RX        | LED_OUT | Disp_Word | Disp_Error");
        $display("-------------------------------------------------------------");

        // Caso base: palabra original 1010
        entrada = 4'b1010;

        // Primero, obtenemos la palabra codificada de referencia
        // (simulamos lo que haría el codificador para "entrada")
        // Para simplificar, puedes tomarlo manual del codificador, 
        // pero aquí asumimos que codificador del DUT ya lo calcula
        #5;
        codificado_ref = dut.codificado;

        // -----------------------
        // Caso 1: Sin error
        // -----------------------
        palabra_rx = codificado_ref; #10;
        $display("%0t | %b | %b | %b | %b | %b", 
                 $time, entrada, palabra_rx, led_out, display_word, display_error);

        // -----------------------
        // Casos 2–9: Error simple en cada bit
        // -----------------------
        for (int i = 0; i < 8; i++) begin
            palabra_rx = codificado_ref;
            palabra_rx[i] = ~palabra_rx[i]; // invertir un bit
            #10;
            $display("%0t | %b | %b | %b | %b | %b", 
                     $time, entrada, palabra_rx, led_out, display_word, display_error);
        end

        // -----------------------
        // Caso 10: Error doble
        // -----------------------
        palabra_rx = codificado_ref;
        palabra_rx[0] = ~palabra_rx[0];
        palabra_rx[3] = ~palabra_rx[3];
        #10;
        $display("%0t | %b | %b | %b | %b | %b", 
                 $time, entrada, palabra_rx, led_out, display_word, display_error);

        #10;
        $finish;
    end

    // Para GTKWave
    initial begin
        $dumpfile("modulo_top_tb.vcd");
        $dumpvars(0, modulo_top_tb);
    end

endmodule