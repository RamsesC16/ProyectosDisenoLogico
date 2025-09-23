module module_7segmentos (
    input  logic [3:0] data,      // Entrada: valor en hex (0–F)
    output logic [6:0] display    // Salida: segmentos [a..g], activo-bajo
);

    logic [6:0] seg_int; // activo-alto interno

    always_comb begin
        case (data)
            4'h0: seg_int = 7'b1111110; // 0
            4'h1: seg_int = 7'b0110000; // 1
            4'h2: seg_int = 7'b1101101; // 2
            4'h3: seg_int = 7'b1111001; // 3
            4'h4: seg_int = 7'b0110011; // 4
            4'h5: seg_int = 7'b1011011; // 5
            4'h6: seg_int = 7'b1011111; // 6
            4'h7: seg_int = 7'b1110000; // 7
            4'h8: seg_int = 7'b1111111; // 8
            4'h9: seg_int = 7'b1111011; // 9
            4'hA: seg_int = 7'b1110111; // A
            4'hB: seg_int = 7'b0011111; // b
            4'hC: seg_int = 7'b1001110; // C
            4'hD: seg_int = 7'b0111101; // d
            4'hE: seg_int = 7'b1001111; // E
            4'hF: seg_int = 7'b1000111; // F
            default: seg_int = 7'b0000000; // apagado
        endcase
    end

    // Inversión para común ánodo
    assign display = ~seg_int;

endmodule