`timescale 1ns / 1ps

module module_prueba_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [5:0] count_o;

    // Instantiate the Unit Under Test 
    module_prueba #(10) counter (
        .clk(clk),
        .rst(rst),
        .count_o(count_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        rst = 1;
        #30;
        rst = 0;
        #30;
        rst = 1;
        # 300000;
        $finish;
    end

    always begin
        clk = ~clk;
        #10;
    end 


    initial begin
        $dumpfile("module_prueba_tb.vcd");  // For waveform viewing
        $dumpvars(0, module_prueba_tb);
    end

endmodule
