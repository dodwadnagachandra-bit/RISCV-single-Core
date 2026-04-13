// Top Module
`include "Program_counter.v"
`include "Instruction_Memory.v"
`include "register_files.v"
`include "Sign_Extend.v"
`include "alu.v"
`include "Control_Unit_Top.v"
`include "Data_memory.v"
`include "PC_Adder.v"

module Single_cycle_Top( clk, rst );

  input clk, rst;

  // --- Wires ---
  wire [31:0] pc_top;
  wire [31:0] RD_Instr;
  wire [31:0] RD1_Top, RD2_Top;
  wire [31:0] Imm_ext_Top;
  wire [2:0]  ALUControl_Top;
  wire [31:0] ALU_Result;
  wire [31:0] ReadData;
  wire [31:0] pcplus4;
  wire [31:0] PCTarget;       // branch target = PC + Imm
  wire [31:0] pc_next;        // input to PC: either pcplus4 or PCTarget

  // Control signals
  wire        RegWrite;
  wire        ALUSrc;
  wire        MemWrite;
  wire        ResultSrc;
  wire        PCSrc;
  wire        Branch;
  wire [1:0]  ImmSrc;

  // ALU flags
  wire Z, N, V, C;

  // Mux outputs
  wire [31:0] ALU_b;       // ALUSrc mux: RD2 or Imm
  wire [31:0] WriteBack;   // ResultSrc mux: ALU_Result or ReadData

  // -------------------------------------------------------
  // Program Counter
  // -------------------------------------------------------
  _pc PC(
    .clk    (clk),
    .rst    (rst),
    .pc_next(pc_next),
    .pc     (pc_top)
  );

  // -------------------------------------------------------
  // Instruction Memory
  // -------------------------------------------------------
  instruction_mem IM(
    .A  (pc_top),
    .rst(rst),
    .Rd (RD_Instr)
  );

  // -------------------------------------------------------
  // Register File
  // -------------------------------------------------------
  reg_file RF(
    .A1 (RD_Instr[19:15]),
    .A2 (RD_Instr[24:20]),
    .A3 (RD_Instr[11:7]),
    .WD3(WriteBack),          // BUG FIX: was hardwired to ReadData — now uses ResultSrc mux
    .WE3(RegWrite),
    .clk(clk),
    .rst(rst),
    .RD1(RD1_Top),
    .RD2(RD2_Top)
  );

  // -------------------------------------------------------
  // Sign Extend
  // -------------------------------------------------------
  Sign_Extend SG(
    .in     (RD_Instr),
    .imm_ext(Imm_ext_Top)
  );

  // -------------------------------------------------------
  // ALUSrc MUX: choose between register value (RD2) or immediate
  // -------------------------------------------------------
  assign ALU_b = (ALUSrc) ? Imm_ext_Top : RD2_Top;

  // -------------------------------------------------------
  // ALU
  // -------------------------------------------------------
  alu ALU(
    .a    (RD1_Top),
    .b    (ALU_b),
    .cntrl(ALUControl_Top),
    .out  (ALU_Result),
    .Z    (Z),
    .N    (N),
    .V    (V),
    .C    (C)
  );

  // -------------------------------------------------------
  // Control Unit
  // -------------------------------------------------------
  Control_Unit_Top CU(
    .Op        (RD_Instr[6:0]),
    .zero      (Z),
    .RegWrite  (RegWrite),
    .ImmSrc    (ImmSrc),
    .ALUSrc    (ALUSrc),
    .MemWrite  (MemWrite),
    .ResultSrc (ResultSrc),
    .Branch    (Branch),
    .PCSrc     (PCSrc),
    .funct3    (RD_Instr[14:12]),
    .funct7    (RD_Instr[30]),     // only bit 30 matters for sub vs add
    .ALUControl(ALUControl_Top)
  );

  // -------------------------------------------------------
  // Data Memory
  // -------------------------------------------------------
  Data_memory DM(
    .A  (ALU_Result),
    .WD (RD2_Top),
    .clk(clk),
    .WE (MemWrite),
    .RD (ReadData)
  );

  // -------------------------------------------------------
  // PC + 4
  // -------------------------------------------------------
  PC_Adder PCA(
    .a(pc_top),
    .b(32'd4),
    .c(pcplus4)
  );

  // -------------------------------------------------------
  // Branch target: PC + sign-extended immediate
  // -------------------------------------------------------
  PC_Adder BranchAdder(
    .a(pc_top),
    .b(Imm_ext_Top),
    .c(PCTarget)
  );

  // -------------------------------------------------------
  // PC Next MUX: PC+4 normally, PCTarget on branch taken
  // -------------------------------------------------------
  assign pc_next = (PCSrc) ? PCTarget : pcplus4;

  // -------------------------------------------------------
  // Write-back MUX: ALU result or memory read data
  // -------------------------------------------------------
  assign WriteBack = (ResultSrc) ? ReadData : ALU_Result;

endmodule
