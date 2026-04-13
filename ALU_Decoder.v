// ALU Decoder

module alu_decoder(AluOp,op5,funct3,funct7,AluControl);
	
  input op5,funct7;
  input [2:0] funct3;
  output [2:0] AluControl;

  wire [1:0] Concatenation;
  assign Concatenation = {op5,funct7};
  
  assign AluControl = (AluOp == 2'b00) ? 3'b000 : 
    				  (AluOp == 2'b01) ? 3'b001 :
                      ((AluOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                      ((AluOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 :
                      ((AluOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 :
                      ((AluOp == 2'b10) & (funct3 == 3'b000) & (Concatenation == 2'b11)) ? 3'b001 : 
                      ((AluOp == 2'b10) & (funct3 == 3'b000) & (Concatenation != 2'b11)) ? 3'b000 ;


endmodule
