`timescale 1ns/1ns

module module_corrector_error_tb;

    // Señales de prueba
    reg  [7:0] datos_rx;        // Palabra recibida (con posible error)
    reg  [2:0] sindrome;        // Síndrome calculado
    reg        paridad_global;  // Bit de paridad global
    wire [7:0] datos_corr;      // Palabra corregida

    // Instancia del módulo corrector
    module_corrector_error dut (
        .sindrome(sindrome),
        .datos_recibidos(datos_rx),
        .paridad_global(paridad_global),
        .datos_corregidos(datos_corr)
    );

    // Procedimiento de prueba
    initial begin
        $display("Tiempo | Recibido   | Sindrome | Paridad | Corregido ");
        $display("-------|------------|----------|---------|-----------");

        // === Caso 1: Sin error ===
        datos_rx = 8'b10000111; // palabra válida (ejemplo codificación de 0001)
        sindrome = 3'b000;
        paridad_global = 0;
        #10;
        $display("%t | %b |   %b   |    %b    | %b", 
                  $time, datos_rx, sindrome, paridad_global, datos_corr);

        // === Caso 2: Error simple en un bit de dato ===
        datos_rx = 8'b10000110; // mismo ejemplo con error en el bit 0
        sindrome = 3'b001;      // detector diría "error en bit 0"
        paridad_global = 1;
        #10;
        $display("%t | %b |   %b   |    %b    | %b", 
                  $time, datos_rx, sindrome, paridad_global, datos_corr);

        // === Caso 3: Error en el bit de paridad global ===
        datos_rx = 8'b00000111; // p0 alterado
        sindrome = 3'b000;
        paridad_global = 1;
        #10;
        $display("%t | %b |   %b   |    %b    | %b", 
                  $time, datos_rx, sindrome, paridad_global, datos_corr);

        // === Caso 4: Error doble (no corregible) ===
        datos_rx = 8'b11000110; // dos errores inyectados
        sindrome = 3'b011;
        paridad_global = 0;
        #10;
        $display("%t | %b |   %b   |    %b    | %b", 
                  $time, datos_rx, sindrome, paridad_global, datos_corr);

        // Fin de simulación
        #10 $finish;
    end

    // Para generar waveform
    initial begin
        $dumpfile("module_corrector_error_tb.vcd");
        $dumpvars(0, module_corrector_error_tb);
    end

endmodule