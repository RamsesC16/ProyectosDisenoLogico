`timescale 1ns/1ns

module module_display_error_tb;

    reg  [2:0] sindrome;
    reg        error_simple;
    reg        error_doble;
    reg        no_error;
    wire [6:0] display;

    // Instancia del DUT
    module_display_error dut (
        .sindrome(sindrome),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .no_error(no_error),
        .display(display)
    );

    initial begin
        $display("Tiempo | Sindrome | ES | ED | NE | Display");
        $display("-------------------------------------------");

        // Caso 1: sin error
        sindrome = 3'b000; error_simple = 0; error_doble = 0; no_error = 1; #10;
        $display("%0t |   %b   | %b  | %b  | %b  | %b", 
                 $time, sindrome, error_simple, error_doble, no_error, display);

        // Caso 2: error simple en bit 3
        sindrome = 3'b011; error_simple = 1; error_doble = 0; no_error = 0; #10;
        $display("%0t |   %b   | %b  | %b  | %b  | %b", 
                 $time, sindrome, error_simple, error_doble, no_error, display);

        // Caso 3: error doble
        sindrome = 3'b101; error_simple = 0; error_doble = 1; no_error = 0; #10;
        $display("%0t |   %b   | %b  | %b  | %b  | %b", 
                 $time, sindrome, error_simple, error_doble, no_error, display);

        // Caso 4: estado raro (ningún flag activo)
        sindrome = 3'b010; error_simple = 0; error_doble = 0; no_error = 0; #10;
        $display("%0t |   %b   | %b  | %b  | %b  | %b", 
                 $time, sindrome, error_simple, error_doble, no_error, display);

        #10;
        $finish;
    end

    initial begin
        $dumpfile("module_display_error_tb.vcd");
        $dumpvars(0, module_display_error_tb);
    end

endmodule