`timescale 1ns/1ns

module module_detector_error_tb; 

    // Señales de prueba
    reg  [7:0] datos_rec;      // Entrada: palabra de 8 bits codificada
    wire [2:0] sin;            // Síndrome de error
    wire       error;          // Señal de error detectado
    wire       paridad;        // Paridad global
    wire       error_doble;    // Flag de error doble

    // Instancia del módulo detector_error
    module_detector_error dut (
        .datos_recibidos(datos_rec),
        .sindrome(sin),
        .paridad_global(paridad),
        .bit_error(error),
        .error_doble(error_doble)
    );

    initial begin
        $display("Tiempo | Entrada    | Sindrome | PG | Err | Doble");
        $display("-------|------------|----------|----|-----|------");

        // Caso base: palabra sin error
        datos_rec = 8'b0000_0000; #10;
        $display("%0t | %b |   %b   |  %b |  %b  |  %b", $time, datos_rec, sin, paridad, error, error_doble);

        // Inyectar errores simples en cada bit [0..7]
        for (int i=0; i<8; i++) begin
            datos_rec = 8'b0000_0000;
            datos_rec[i] = ~datos_rec[i]; #10;
            $display("%0t | %b |   %b   |  %b |  %b  |  %b", $time, datos_rec, sin, paridad, error, error_doble);
        end

        // Ejemplo de error doble
        datos_rec = 8'b0000_0000;
        datos_rec[0] = 1; 
        datos_rec[1] = 1; #10;
        $display("%0t | %b |   %b   |  %b |  %b  |  %b", $time, datos_rec, sin, paridad, error, error_doble);

        $finish;
    end

    initial begin
        $dumpfile("module_detector_error_tb.vcd"); 
        $dumpvars(0, module_detector_error_tb); 
    end
endmodule