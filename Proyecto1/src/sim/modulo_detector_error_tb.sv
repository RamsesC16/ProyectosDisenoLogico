`timescale 1ns/1ns

module modulo_detector_error_tb; 

    // Señales de prueba
    reg [7:0] datos_rec;   // Entrada de 8 bits [i3,i2,i1,c2,i0,c1,c0,p0]
    wire [2:0] sin;        // Salida de 3 bits [p2,p1,p0]. Síndrome de error
    wire error;            // Señal de error detectado

    // Instancia del módulo detector_error
    modulo_detector_error dut (
        .datos_recibidos(datos_rec),
        .sindrome(sin),
        .bit_error(error)
    );

    initial begin
        $display("---------|----------|----------|-------");
        $display(" Tiempo  | Entrada  | Sindrome | Error");
        $display("---------|----------|----------|-------");

        // Caso 1: palabra sin error (ejemplo todo en ceros)
        datos_rec = 8'b0000_0000; #10;
        $display("%t |  %b  |   %b   |   %b", $time, datos_rec, sin, error);

        // Caso 2: error en un bit de información
        datos_rec = 8'b0000_0100; #10;
        $display("%t |  %b  |   %b   |   %b", $time, datos_rec, sin, error);

        // Caso 3: error en un bit de paridad
        datos_rec = 8'b1000_0000; #10;
        $display("%t |  %b  |   %b   |   %b", $time, datos_rec, sin, error);

        // Caso 4: doble error (ejemplo inventado)
        datos_rec = 8'b1010_0100; #10;
        $display("%t |  %b  |   %b   |   %b", $time, datos_rec, sin, error);

        // Fin de simulación
        $finish;
    end

    initial begin
        $dumpfile("modulo_detector_error_tb.vcd"); 
        $dumpvars(0, modulo_detector_error_tb); 
    end
endmodule