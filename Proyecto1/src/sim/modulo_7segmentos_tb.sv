`timescale 1ns/1ns

module module_7segmentos_tb;

    reg  [3:0] data;
    wire [6:0] display;

    // Instancia del DUT
    module_7segmentos dut (
        .data(data),
        .display(display)
    );

    initial begin
        $display("Tiempo | Data | Display");
        $display("------------------------");

        for (int i = 0; i < 16; i++) begin
            data = i[3:0];
            #10;
            $display("%0t |  %h  | %b", $time, data, display);
        end

        #10;
        $finish;
    end

    initial begin
        $dumpfile("module_7segmentos_tb.vcd");
        $dumpvars(0, module_7segmentos_tb);
    end

endmodule