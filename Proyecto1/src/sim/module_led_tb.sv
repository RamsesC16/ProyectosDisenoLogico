`timescale 1ns/1ns

module module_led_tb;

    // Definición de las señales de prueba
    reg  [3:0] datos_in;   // Entrada de 4 bits (datos corregidos)
    wire [3:0] leds;       // Salida hacia LEDs

    // Instancia del módulo a probar
    module_led dut (
        .datos_out(datos_in),
        .leds(leds)
    );

    // Generación de estímulos
    initial begin
        $display("-------|---------|--------");
        $display("Tiempo | Entrada | Salida ");
        $display("-------|---------|--------");

        // Monitoreo en consola
        $monitor("Tiempo = %0t | Entrada = %b | Salida = %b", 
                 $time, datos_in, leds);
    
        // Recorrer todos los casos de 4 bits (0 a F)
        datos_in = 4'b0000; #10;
        datos_in = 4'b0001; #10;
        datos_in = 4'b0010; #10;
        datos_in = 4'b0011; #10;
        datos_in = 4'b0100; #10;
        datos_in = 4'b0101; #10;
        datos_in = 4'b0110; #10;
        datos_in = 4'b0111; #10;
        datos_in = 4'b1000; #10;
        datos_in = 4'b1001; #10;
        datos_in = 4'b1010; #10;
        datos_in = 4'b1011; #10;
        datos_in = 4'b1100; #10;
        datos_in = 4'b1101; #10;
        datos_in = 4'b1110; #10;
        datos_in = 4'b1111; #10;

        #10;
        $finish;
    end 

    // Configuración para GTKWave
    initial begin
        $dumpfile("module_leds_tb.vcd");
        $dumpvars(0, module_leds_tb);
    end

endmodule