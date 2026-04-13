// 32-bit ALU 
module alu ( a,b, cntrl,out,Z,N,V,C);
  
  input [31:0] a,b;
  input [2:0] cntrl;
  output [31:0] out;
  output Z,N,V,C;
  
  wire [31:0] a_and_b;
  wire [31:0] a_or_b;
  wire [31:0] not_b;
  
  wire [31:0] 2to1_mux;
  wire [31:0] sum;
  wire [31:0] 4to1_mux;
  wire cout;
  wire [31:0] slt;
  
  assign a_and_b = a & b;
  assign a_or_b = a|b;
  assign not_b = ~b;
  
  //  [2:1] mux design 
  assign 2to1_mux = (cntrl[0] == 1'b0) ? b : not_b;
  
  // Addition / Subtraction (concatenation)
  assign {cout,sum} = a + 2to1mux + cntrl[0];
  
  //  [4:1] mux design 
  assign 4to1_mux = (cntrl[2:0] == 3'b000) ? sum : (cntrl[2:0] == 3'b001) ? sum: (cntrl[2:0] == 3'b010) ? a_and_b : (cntrl[2:0] == 3'b011) ? a_or_b : (cntrl[2:0] == 3'b101) ? slt : 32'h00000000;
  
  assign out = 4to1_mux;
  
  // Zero flag
  assign Z = &(~out);
  
  // Negative flag
  assign N = out[31];
  
  // Carry flag
  assign C = cout & (~cntrl[1]);
  
  // Overflow flag
  assign V = (~cntrl[1]) & ( a[31] ^ sum[31]) & (~(a[31] ^ b[31] ^ cntrl[0]));
  
  // zero extension
  assign slt = {31'b0000000000000000000000000000000,sum[31]};
  
     
endmodule
  
  
