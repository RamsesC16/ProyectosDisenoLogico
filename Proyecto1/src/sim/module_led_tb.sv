`timescale 1ns/1ns

module module_led_tb;

    // Definición de las señales de prueba
    reg  [3:0] led_in;   // Entrada de 4 bits (datos corregidos)
    wire [3:0] led_out;       // Salida hacia LEDs

    // Instancia del módulo a probar
    module_led dut (
        .in(led_in),     // conecta al puerto real "in"
        .out(led_out)    // conecta al puerto real "out"
    );

    // Generación de estímulos
    initial begin
        $display("-------|---------|--------");
        $display("Tiempo | Entrada | Salida ");
        $display("-------|---------|--------");

        // Monitoreo en consola
        $monitor("Tiempo = %0t | Entrada = %b | Salida = %b", 
                 $time, led_in, led_out);
    
        // Recorrer todos los casos de 4 bits (0 a F)
        led_in = 4'b0000; #10;
        led_in = 4'b0001; #10;
        led_in = 4'b0010; #10;
        led_in = 4'b0011; #10;
        led_in = 4'b0100; #10;
        led_in = 4'b0101; #10;
        led_in = 4'b0110; #10;
        led_in = 4'b0111; #10;
        led_in = 4'b1000; #10;
        led_in = 4'b1001; #10;
        led_in = 4'b1010; #10;
        led_in = 4'b1011; #10;
        led_in = 4'b1100; #10;
        led_in = 4'b1101; #10;
        led_in = 4'b1110; #10;
        led_in = 4'b1111; #10;

        #10;
        $finish;
    end 

    // Configuración para GTKWave
    initial begin
        $dumpfile("module_led_tb.vcd");
        $dumpvars(0, module_led_tb);
    end

endmodule