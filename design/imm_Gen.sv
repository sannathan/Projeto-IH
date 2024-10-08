`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);

  always_comb
    case (inst_code[6:0])

      7'b0010011: /* */
        case (inst_code[14:12])
          3'b101: // SRAI , SRLI
            Imm_out = {27'b0, inst_code[24:20]}; // Por ser instrucao de shift o campo imediato representa a quantidade de bits a ser deslocada e, portanto, não é um valor que precisa de extensão de sinal
          3'b001: // SLLI
            Imm_out = {27'b0, inst_code[24:20]}; // Pegamos os bits inst_code[24:20] e preenchemos com zeros à esquerda
          default: // ANDI, ORI, XORI, ADDI, SLTI 
            Imm_out = {{20{inst_code[31]}}, inst_code[31:20]}; // No caso dessas instruções é necessário a extensão de sinal correta a partir do bit 31 para garantir que os valores negativos sejam interpretados corretamente
        endcase

      7'b0000011:  /*I-type load part*/
        Imm_out = {{20{inst_code[31]}}, inst_code[31:20]};

      7'b0100011:  /*S-type*/
        Imm_out = {{20{inst_code[31]}}, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
        Imm_out = {{19{inst_code[31]}}, inst_code[31], inst_code[7], inst_code[30:25], inst_code[11:8], 1'b0};

      7'b1101111: /*JAL*/
        Imm_out = {{11{inst_code[31]}}, inst_code[31], inst_code[19:12], inst_code[20], inst_code[30:21], 1'b0};

      7'b1100111: /*JALR*/
        Imm_out = {{20{inst_code[31]}}, inst_code[31:20]};

      default: Imm_out = 32'b0;

    endcase

endmodule
