`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic Halt,
    output logic Jump,
    output logic JumpReg,
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    
    
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic Jump,
    output logic [1:0]RWseal
);

  logic [6:0] R_TYPE, B_TYPE, I_TYPE, S_TYPE, JAL, JALR, LOAD_TYPE; //Adicionar mais vetores

  assign R_TYPE = 7'b0110011;  //add,and, sub, slt, xor, or
  assign B_TYPE = 7'b1100011; //beq, bne, blt, bge
  assign I_TYPE = 7'b0010011; //slti, addi, slli, srli, srai obs: vai precisar fazer calculo de deslocamento quando for usar
  assign S_TYPE = 7'b0100011; // sw, sb, sh
  assign LOAD_TYPE = 7'b0000011; //lw, lb, lh, lbu 
  assign JAL = 7'b1101111; // jal
  assign JALR = 7'b1100111; // jalr
  assign HALT_TYPE = 7'b1111111;
  
  //Nao ha opcode padrao para HALT

  assign ALUSrc = (Opcode == I_TYPE || Opcode == S_TYPE || Opcode == LOAD_TYPE);
  assign MemtoReg = (Opcode == LOAD_TYPE);
  assign RegWrite = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == LOAD_TYPE || Opcode == JAL|| Opcode == JALR);
  assign MemRead = (Opcode == LOAD_TYPE);
  assign MemWrite = (Opcode == S_TYPE);
  assign ALUOp[0] = (Opcode == B_TYPE || Opcode == JALR);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == JALR);
  assign Branch = (Opcode == B_TYPE || Opcode ==JALR);
  assign Jump =(Opcode == JAL||Opcode == JALR);
  assign RWseal[0] = (Opcode == JAL||Opcode == JALR);
  assign RWseal[1] = (0);
endmodule
