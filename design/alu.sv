`timescale 1ns / 1ps

module alu#(
    parameter DATA_WIDTH = 32,
    parameter OPCODE_LENGTH = 4
    )
    (
    input logic [DATA_WIDTH-1:0]    SrcA,
    input logic [DATA_WIDTH-1:0]    SrcB,
    input logic [OPCODE_LENGTH-1:0] Operation,
    input logic                     isImmediate,
    output logic[DATA_WIDTH-1:0]    ALUResult
    );
    
    logic [DATA_WIDTH-1:0] B;

    always_comb begin
        // If isImmediate is true, use SrcB as immediate value
        B = isImmediate ? {{20{SrcB[11]}}, SrcB[11:0]} : SrcB;

        case(Operation)
            4'b0000:  // AND, ANDI
                ALUResult = SrcA & B;
            4'b0001:  // OR, ORI
                ALUResult = SrcA | B;
            4'b0010:  // XOR, XORI
                ALUResult = SrcA ^ B;
            4'b0011:  // LOAD, STORE, ADD, ADDI
                ALUResult = $signed(SrcA) + $signed(B);
            4'b0100:  // SUB
                ALUResult = $signed(SrcA) - $signed(B);
            4'b0101:  // SRL, SRLI (changed from 0101 to 0105 to avoid conflict with 0101)
                ALUResult = SrcA >> B;
            4'b0110:  // SRA, SRAI
                ALUResult = $signed(SrcA) >>> $signed(B);
            4'b0111:  // SLL, SLLI
                ALUResult = SrcA << B;
            4'b1000:  // BEQ
                ALUResult = (SrcA == B) ? 1 : 0;
            4'b1001:  // BNE
                ALUResult = (SrcA != B) ? 1 : 0;
            4'b1010:  // SLT, SLTI, BLT
                ALUResult = ($signed(SrcA) < $signed(B)) ? 1 : 0;
            4'b1011:  // BGE
                ALUResult = ($signed(SrcA) >= $signed(B)) ? 1 : 0;
            4'b1100:  // JALR
                ALUResult = SrcA;
            4'b1101:  // LUI
                ALUResult = B;
            4'b1110:  // BLTU, SLTU, SLTIU
                ALUResult = ($unsigned(SrcA) < $unsigned(B)) ? 1 : 0;
            4'b1111:  // BGEU
                ALUResult = ($unsigned(SrcA) >= $unsigned(B)) ? 1 : 0;
            default:
                ALUResult = 0;
        endcase
    end
endmodule
