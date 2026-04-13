// Top Module 

// instantiate file
`include "program_counter.v"
`include "Instruction_Memory.v"
`include "register_files.v"
`include "Sign_Extend.v"
`include "alu.v"
`include "Control_Unit_Top.v"
`include "Data_memory.v"
`include "PC_Adder.v"


module Single_cycle_Top(clk,rst);
  
  input clk,rst;
  wire [31:0] pc_top;
  wire [31:0] RD_Instr;
  wire [31:0] RD1_Top;
  wire [31:0] Imm_ext_Top;
  wire [31:0] ALU_Result, ReadData,pcplus4 ;
  wire    RegWrite;
  wire [2:0] ALUControl_Top;
  
  
  _pc PC(
    .clk(clk), .pc_next(pcplus4),.rst(rst),.pc(pc_top)
  );
  
  instruction_mem IM(
    .A(pc_top),
    .rst(rst),
    .Rd(RD_Instr)
  );
  
  reg_file RF(
   			 .A1(RD_Instr[19:15]), 
              .A2,
              .A3(RD_Instr[11:7]),
    		  .WD3(ReadData),
   			  .WE3(RegWrite),
              .clk(clk),
              .rst(rst),
              .RD1(RD1_Top),           
               RD2
  );
                          
  Sign_Extend SG( 
    			.in(RD_Instr),
         	    .imm_ext(Imm_ext_Top)
  );
  
    alu  alu( 
      .a(RD1_Top),
      .b(Imm_ext_Top),
      .cntrl(ALUControl_Top),
      .out(ALU_Result),
      .Z,
      .N,
      .V,
      .C
    );
     
    Control_Unit_Top CU(  		
      .Op(RD_Instr[6:0]),
      .RegWrite(RegWrite),
      .ImmSrc(),
      .ALUSrc(),
      .MemWrite(),
      .ResultSrc(),
      .Branch(),
      .funct3(RD_Instr[14:12]),
      .funct7(),
      .ALUControl(ALUControl_Top)
    );  
          
  
  Data_memory DM(
    		.A(ALU_Result),
    		.WD3(),
            .clk(),
            .WE(),
            .RD(ReadData)
  );
  
  
  PC_Adder  PCA(
            .a(pc_top),
            .b(32'd4),
            .c(pcplus4)
  );

  
endmodule
