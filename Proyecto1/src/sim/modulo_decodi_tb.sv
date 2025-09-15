`timescale 1ns / 1ns

module module_decodi_tb; 

    // Señales de prueba
    reg  [7:0] recibido;   // Entrada: Palabra de 8 bits corregida
    wire [3:0] salida;     // Salida: Datos originales de 4 bits

    // Instanciar el módulo decodificador de 8 bits
    module_decodi dut (
        .datos_cod(recibido),
        .datos_out(salida)
    );

    // Procedimiento de prueba
    initial begin
        $display("-------|----------|-------");
        $display("Tiempo |  Entrada | Salida");
        $display("-------|----------|-------");

        // Caso 1: palabra toda en ceros (con paridad global)
        recibido = 8'b0000_0000; #10;
        $display("%t  |  %b  |   %b", $time, recibido, salida);

        // Caso 2: ejemplo con algunos bits en 1
        recibido = 8'b0000_1111; #10;
        $display("%t  |  %b  |   %b", $time, recibido, salida);

        // Caso 3: otro ejemplo arbitrario
        recibido = 8'b1011_0010; #10;
        $display("%t  |  %b  |   %b", $time, recibido, salida);

        // Fin de simulación
        $finish;
    end
    
    initial begin
        $dumpfile("module_decodi_tb.vcd"); 
        $dumpvars(0, module_decodi_tb); 
    end

endmodule