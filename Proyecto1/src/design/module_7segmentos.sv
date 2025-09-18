module module_7segmentos (
    input  logic [3:0] data,      // Entrada: valor en hex (0–F)
    output logic [6:0] display    // Salida: segmentos [a..g]
);

    always_comb begin
        case (data)
            4'h0: display = 7'b0000001; // 0
            4'h1: display = 7'b1001111; // 1
            4'h2: display = 7'b0010010; // 2
            4'h3: display = 7'b0000110; // 3
            4'h4: display = 7'b1001100; // 4
            4'h5: display = 7'b0100100; // 5
            4'h6: display = 7'b0100000; // 6
            4'h7: display = 7'b0001111; // 7
            4'h8: display = 7'b0000000; // 8
            4'h9: display = 7'b0000100; // 9
            4'hA: display = 7'b0001000; // A
            4'hB: display = 7'b1100000; // b
            4'hC: display = 7'b0110001; // C
            4'hD: display = 7'b1000010; // d
            4'hE: display = 7'b0110000; // E
            4'hF: display = 7'b0111000; // F
            default: display = 7'b1111111; // apagado
        endcase
    end

endmodule