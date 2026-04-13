// Code your design here
module Data_memory(A,WD3,clk,WE,RD);
  input [31:0] A,WD;
  input clk,rst,WE;
  
  output [31:0]RD;
  
  reg [31:0] Data_mem [1023:0];
  
  assign RD = (WE==1'b0) ? Data_mem [A] : 32'd0;
  
  always @(posedge clk)
    begin
      
      if(WE)
        Data_mem[A] <= WD;
      
    end
  
endmodule
