`include "Single_cycle_Top.v"

module Single_cycle_Top_Tb();

  reg clk = 1'b1;
  reg rst;

  Single_cycle_Top DUT(
    .clk(clk),
    .rst(rst)
  );

  always #50 clk = ~clk;

  integer i;
  initial begin
    // Load instructions
    DUT.IM.Mem[0] = 32'h00500093; // addi x1, x0, 5
    DUT.IM.Mem[1] = 32'h00A00113; // addi x2, x0, 10
    DUT.IM.Mem[2] = 32'h002081B3; // add  x3, x1, x2
    DUT.IM.Mem[3] = 32'h00118213; // addi x4, x3, 1
    DUT.IM.Mem[4] = 32'h00000013; // nop

    // Initialize all registers to 0 (x0 must be 0 in RISC-V)
    for (i = 0; i < 32; i = i + 1)
      DUT.RF.Registers[i] = 32'd0;

    rst = 0;
    #150;
    rst = 1;

    $display("-------------------------------------------------------------------");
    $display("  Time | PC       | Instruction | dest_reg | ALU_Result | RegWrite");
    $display("-------------------------------------------------------------------");

    repeat(6) begin
      @(posedge clk); #1;
      $display("  %4t | %h | %h  |    x%0d    | %0d (%h) | %b",
        $time,
        DUT.pc_top,
        DUT.RD_Instr,
        DUT.RD_Instr[11:7],
        DUT.ALU_Result,
        DUT.ALU_Result,
        DUT.RegWrite
      );
    end

    $display("-------------------------------------------------------------------");
    $display("Final register values:");
    $display("  x1 = %0d  (expect 5)",  DUT.RF.Registers[1]);
    $display("  x2 = %0d  (expect 10)", DUT.RF.Registers[2]);
    $display("  x3 = %0d  (expect 15)", DUT.RF.Registers[3]);
    $display("  x4 = %0d  (expect 16)", DUT.RF.Registers[4]);
    $finish;
  end

endmodule
