// Main Decoder
module mian_Decoder(op,zero,RegWrite,ResultSrc,MemWrite,AluSrc,PCSrc,ImmSrc,Aluop);
  
  input zero;
  input [6:0] op;
  output RegWrite,ResultSrc,MemWrite,AluSrc,PCSrc;
  output [1:0] ImmSrc,Aluop;
  
  wire branch;
  
  assign RegWrite = (( op==7'b0000011) | ( op==7'b0110011)) ? 1'b1 : 1'b0 ;
  
  assign MemWrite = (op ==7'b0100011) ? 1'b1 :1'b0;
  
  assign ResultSrc = (op == 7'b0000011) ? 1'b1: 1'b0;
 
  assign AluSrc = (( op==7'b0000011) | ( op==7'b0100011)) ? 1'b1 : 1'b0 ;
  
  assign branch = (opcode =1100011) ? 1'b1 :1'b0;
  
  assign ImmSrc = (op == 7'b0100011) ? 2'b01 :(op == 7'b1100011) ? 2'b10 : 2'b00;
  
  assign Aluop = (op == 7'b0110011) ? 2'b10 :(op == 7'b1100011) ? 2'b01 : 2'b00;
  
  assign PCSrc = zero & branch;
  
  
  
  
endmodule
  
