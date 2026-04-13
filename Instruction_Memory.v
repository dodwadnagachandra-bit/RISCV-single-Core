// Instruction Memory
module instruction_mem( A,rst,Rd);
  
  input[31:0] A;
  input rst;
  
  output [31:0] Rd;
  
  // create memory total reg 1024 with size of 32.
  reg [31:0] Mem [1023:0]
  
  assign Rd = (rst == 1'b0) ? 32'd0 : Mem[A(31:2)];
  
endmodule
