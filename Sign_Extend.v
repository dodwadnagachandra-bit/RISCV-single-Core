// Sign Extend 
module Sign_Extend(in,imm_ext);
  
  input [31:0] in;
  output [31:0] imm_ext;
  
          assign imm_ext = (in[31]) ? {{20{1'b1}},in[31:20]}:										  {{20{1'b0}},in[31:20]};
            							
  
  
  
  
  
  
endmodule
