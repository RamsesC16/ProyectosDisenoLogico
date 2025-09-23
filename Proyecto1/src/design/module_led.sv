module module_led (
    input  logic [3:0] in,   // Datos corregidos (i3..i0)
    output logic [3:0] out   // LEDs integrados (activos-bajo)
);

    // Inversión
    assign out = ~in;

endmodule