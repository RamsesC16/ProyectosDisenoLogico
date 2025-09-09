`timescale 1ns/1ns

module modulo_codi_tb;

    reg  [3:0] datos_in;     // Entrada de 4 bits
    wire [7:0] datos_cod;    // Salida codificada de 8 bits

    // Instanciamos el módulo del codificador de 8 bits
    modulo_codi dut (
        .datos_in(datos_in),
        .datos_cod(datos_cod)
    );

    initial begin
        // Cabecera para imprimir resultados
        $display("Tiempo | Entrada | Codificado (8 bits)");
        $display("-------|---------|--------------------");

        // Prueba con diferentes valores de entrada
        datos_in = 4'b0000; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0001; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0010; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0011; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0100; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0101; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0110; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b0111; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1000; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1001; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1010; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1011; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1100; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1101; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1110; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        datos_in = 4'b1111; #10;
        $display("%t  |   %b   |   %b", $time, datos_in, datos_cod);

        #10;
        $finish; // Finaliza la simulación
    end

    initial begin
        $dumpfile("modulo_codi_tb.vcd"); 
        $dumpvars(0, modulo_codi_tb); 
    end

endmodule