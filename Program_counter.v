// Program Counter

module _pc( pc_next,rst,clk,pc);
  
  input [31:0] pc_next;
  input rst,clk;
  
  output [31:0] pc;
  
  always @(posedge clk)
    begin
      
      if(rst ==1'b0)
        pc <= 32'd0;
        
  	   else	
        pc <= pc_next;
    end
  
endmodule
