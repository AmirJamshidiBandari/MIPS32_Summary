/*
This is the top module, it connects all the RTL modules together, it also connected the FPGA clock, switches, and LEDs to the RTL modules.
*/
module MIPS (
    // These inputs come from FPGA.
    input logic clk,
    input logic reset,
    input logic [15:0] switch,
    output logic [15:0] led
);

// IF
logic [31:0] pc;
logic [31:0] next_pc;
logic [31:0] pc_adder_value_IF;
logic [31:0] pc_adder_value;
logic [31:0] instruction_IF;
logic Stall_IF;
logic Stall_PC;
logic Flush_ID;
// ID
logic [31:0] instruction_ID;
logic [31:0] pc_adder_value_ID;
logic Flush_Stall;
logic Flush_Branch;
logic [5:0] op_ID;
logic [4:0] rs_ID, rt_ID, rd_ID, sa_ID;
logic [5:0] fn_ID;
logic [15:0] imm16_ID;
logic [25:0] target26_ID;
logic [31:0] data_out_2_ALUSrc_ID;
logic [31:0] data_out_1_ID, data_out_2_ID;
logic [31:0] sign_ext_imm32_ID, zero_ext_imm32_ID;
logic [31:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31;
logic ImmExt_ID;
logic ALUSrc_ID;
logic Register1_Write_ID;
logic Memory1_Write_ID;
logic Register1_Destination_ID;
logic Jump_ID;
logic Branch_ID;
logic HILO_Register_Enable_ID;
HILO_select_t HILO_Select_ID;
writeback_t Writeback_Control_ID;
alu_ctrl_t ALU_Control_ID;

// EX1
forward1_t Forward1;
forward2_t Forward2;
logic [31:0] ALU_input1_EX1;
logic [31:0] ALU_input2_EX1;
logic [31:0] data_out_2_EX_mux_EX1;
logic [31:0] data_out_1_EX_mux_EX1;
logic [31:0] data_out_1_EX1;
logic [31:0] data_out_2_EX1;
logic [31:0] sign_ext_imm32_EX1;
logic [31:0] pc_adder_value_EX1;
logic [31:0] data_out_2_ALUSrc_EX1;
logic [31:0] branch_imm32_EX1;
logic [27:0] target28_EX1;
logic [31:0] LUI_imm32_result_EX1;
logic [4:0] rt_EX1;
logic [4:0] rd_EX1;
logic [4:0] rs_EX1;
logic [25:0] target26_EX1;
logic [15:0] imm16_EX1;
logic ALUSrc_EX1;
logic Register1_Destination_EX1;
HILO_select_t HILO_Select_EX1;
logic [31:0] store_word_EX1;
logic [4:0] data_in_address_EX1;
logic [31:0] branch_adder_value_EX1;
logic [31:0] jump_value_EX1;
logic Jump_EX1;
logic Branch_EX1;
logic Zero_Flag_EX1;
alu_ctrl_t ALU_Control_EX1;
writeback_t Writeback_Control_EX1;
logic [31:0] instruction_EX1;

// EX2
logic [31:0] data_out_2_EX_mux_EX2;
logic [31:0] data_out_1_EX_mux_EX2;
HILO_select_t Multicycle_HILO_Select_EX2;
HILO_select_t HILO_Select_EX2;
logic [31:0] instruction_EX2;
logic [31:0] ALU_result_EX2;
logic [31:0] store_word_EX2;
logic [31:0] LUI_imm32_result_EX2;
logic [4:0] data_in_address_EX2;
logic [31:0] HI_send_EX2;
logic [31:0] LO_send_EX2;
logic HILO_Register_Enable_EX2;
logic Multicycle_HILO_Register_Enable_EX2;
logic Register1_Write_EX2;
logic Memory1_Write_EX2;
writeback_t Writeback_Control_EX2;
alu_ctrl_t ALU_Control_EX2;
logic [31:0] div_HI_EX2;
logic [31:0] div_LO_EX2;
logic [31:0] mult_HI_EX2;
logic [31:0] mult_LO_EX2;
logic [31:0] ALU_input1_EX2;
logic [31:0] ALU_input2_EX2;
logic [4:0] rt_EX2;
logic Multiply;
logic Divide;
logic [5:0] cycle_mult;
logic stall_mult;
logic stall_div;
logic [6:0] cycle_div;

// MEM
logic [31:0] ALU_result_ME;
logic [31:0] branch_adder_value_ME;
logic [31:0] jump_value_ME;
logic [31:0] load_word_ME;
logic [31:0] instruction_ME;
logic [31:0] data_out_2_ME;
logic [31:0] HI_result_ME;
logic [31:0] LO_result_ME;
logic [31:0] LUI_imm32_result_ME;
logic [4:0] data_in_address_ME;
logic [31:0] store_word_ME;
logic Register1_Destination_ME;
logic Register1_Write_ME;
logic Memory1_Write_ME;
logic Jump_ME;
logic Branch_ME;
writeback_t Writeback_Control_ME;
logic RAM_Write_ME;
logic IO1_Write_ME;
logic IO2_Write_ME;
logic [31:0] HI_send_ME;
logic [31:0] LO_send_ME;
logic HILO_Register_Enable_ME;
alu_ctrl_t ALU_Control_ME;
logic Multicycle_HILO_Register_Enable_ME;
logic [4:0] rt_ME;

// WB
logic [31:0] ALU_result_WB;
logic [31:0] load_word_WB;
logic [31:0] instruction_WB;
logic [31:0] data_in_WB;
logic [4:0] data_in_address_WB;
logic Register1_Destination_WB;
logic [4:0] rt_WB;
logic [4:0] rd_WB;
logic [31:0] HI_result_WB;
logic [31:0] LO_result_WB;
logic [31:0] LUI_imm32_result_WB;
writeback_t Writeback_Control_WB;
logic Register1_Write_WB;
alu_ctrl_t ALU_Control_WB;

// =====================
// IF STAGE
// =====================
    
IF_Pipeline if_pipe(
    .clk(clk),
    .reset(reset),
    .instruction_IF(instruction_IF),
    .pc_adder_value(pc_adder_value),
    .instruction_ID(instruction_ID),
    .pc_adder_value_ID(pc_adder_value_ID),
    .Stall_IF(Stall_IF),
    .Flush_ID(Flush_ID)
);
PC_Register reg_pc(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc),
    .Stall_PC(Stall_PC)
);

PC_Adder pc_adder(
    .pc(pc),
    .pc_adder_value(pc_adder_value)
);

Instruction_Memory mem_instruction(
    .pc(pc),
    .instruction_IF(instruction_IF)
);

PC_Writeback pc_wb(
    .Jump_EX1(Jump_EX1),
    .Branch_EX1(Branch_EX1),
    .Zero_Flag_EX1(Zero_Flag_EX1),
    .jump_value_EX1(jump_value_EX1),
    .branch_adder_value_EX1(branch_adder_value_EX1),
    .pc_adder_value(pc_adder_value),
    .next_pc(next_pc)
);

// =====================
// IF -> ID
// =====================
    
ID_Pipeline id_pipe(
    .clk(clk),
    .reset(reset),

    .data_out_1_ID(data_out_1_ID),
    .data_out_2_ID(data_out_2_ID),
    .sign_ext_imm32_ID(sign_ext_imm32_ID),
    .pc_adder_value_ID(pc_adder_value_ID),
    .Jump_ID(Jump_ID),
    .Branch_ID(Branch_ID),
    .instruction_ID(instruction_ID),
    .Register1_Write_ID(Register1_Write_ID),
    .Memory1_Write_ID(Memory1_Write_ID),
    .Register1_Destination_ID(Register1_Destination_ID),
    .HILO_Register_Enable_ID(HILO_Register_Enable_ID),
    .ALU_Control_ID(ALU_Control_ID),
    .Writeback_Control_ID(Writeback_Control_ID),
    .HILO_Select_ID(HILO_Select_ID),
    .rt_ID(rt_ID),
    .rd_ID(rd_ID),
    .rs_ID(rs_ID),
    .imm16_ID(imm16_ID),
    .target26_ID(target26_ID),
    .data_out_2_ALUSrc_ID(data_out_2_ALUSrc_ID),
    .Flush_Stall(Flush_Stall),
    .ALUSrc_ID(ALUSrc_ID),
    .Flush_Branch(Flush_Branch),
    .ALUSrc_EX1(ALUSrc_EX1),
    .data_out_1_EX1(data_out_1_EX1),
    .data_out_2_EX1(data_out_2_EX1),
    .sign_ext_imm32_EX1(sign_ext_imm32_EX1),
    .pc_adder_value_EX1(pc_adder_value_EX1),
    .Jump_EX1(Jump_EX1),
    .Branch_EX1(Branch_EX1),
    .instruction_EX1(instruction_EX1),
    .Register1_Write_EX1(Register1_Write_EX1),
    .Memory1_Write_EX1(Memory1_Write_EX1),
    .Register1_Destination_EX1(Register1_Destination_EX1),
    .HILO_Register_Enable_EX1(HILO_Register_Enable_EX1),
    .ALU_Control_EX1(ALU_Control_EX1),
    .Writeback_Control_EX1(Writeback_Control_EX1),
    .HILO_Select_EX1(HILO_Select_EX1),
    .rt_EX1(rt_EX1),
    .rd_EX1(rd_EX1),
    .rs_EX1(rs_EX1),
    .target26_EX1(target26_EX1),
    .imm16_EX1(imm16_EX1),
    .data_out_2_ALUSrc_EX1(data_out_2_ALUSrc_EX1)
    
);
    
Instruction_Decoder decoder(
    .instruction_ID(instruction_ID),
    .op_ID(op_ID),
    .rs_ID(rs_ID),
    .rt_ID(rt_ID),
    .rd_ID(rd_ID),
    .sa_ID(sa_ID),
    .fn_ID(fn_ID),
    .imm16_ID(imm16_ID),
    .target26_ID(target26_ID)
);

Control_Unit control(
    .op_ID(op_ID),
    .fn_ID(fn_ID),
    .ImmExt_ID(ImmExt_ID),
    .ALU_Control_ID(ALU_Control_ID),
    .ALUSrc_ID(ALUSrc_ID),
    .Register1_Write_ID(Register1_Write_ID),
    .HILO_Select_ID(HILO_Select_ID),
    .Writeback_Control_ID(Writeback_Control_ID),
    .Memory1_Write_ID(Memory1_Write_ID),
    .Jump_ID(Jump_ID),
    .Branch_ID(Branch_ID),
    .Register1_Destination_ID(Register1_Destination_ID),
    .HILO_Register_Enable_ID(HILO_Register_Enable_ID)
);

Register_1 reg1_file(
    .clk(clk),
    .reset(reset),
    .Register1_Write_WB(Register1_Write_WB),
    .rs_ID(rs_ID),
    .rt_ID(rt_ID),
    .data_in_WB(data_in_WB),
    .data_in_address_WB(data_in_address_WB),
    .data_out_1_ID(data_out_1_ID),
    .data_out_2_ID(data_out_2_ID),
    .load_word_WB(load_word_WB),
    .ALU_result_WB(ALU_result_WB),
    .Reg0(Reg0),
    .Reg1(Reg1),
    .Reg2(Reg2),
    .Reg3(Reg3),
    .Reg4(Reg4),
    .Reg5(Reg5),
    .Reg6(Reg6),
    .Reg7(Reg7),
    .Reg8(Reg8),
    .Reg9(Reg9),
    .Reg10(Reg10),
    .Reg11(Reg11),
    .Reg12(Reg12),
    .Reg13(Reg13),
    .Reg14(Reg14),
    .Reg15(Reg15),
    .Reg16(Reg16),
    .Reg17(Reg17),
    .Reg18(Reg18),
    .Reg19(Reg19),
    .Reg20(Reg20),
    .Reg21(Reg21),
    .Reg22(Reg22),
    .Reg23(Reg23),
    .Reg24(Reg24),
    .Reg25(Reg25),
    .Reg26(Reg26),
    .Reg27(Reg27),
    .Reg28(Reg28),
    .Reg29(Reg29),
    .Reg30(Reg30),
    .Reg31(Reg31)
);

FPGA_Check fpga_checker(
    .Reg0(Reg0),
    .Reg1(Reg1),
    .Reg2(Reg2),
    .Reg3(Reg3),
    .Reg4(Reg4),
    .Reg5(Reg5),
    .Reg6(Reg6),
    .Reg7(Reg7),
    .Reg8(Reg8),
    .Reg9(Reg9),
    .Reg10(Reg10),
    .Reg11(Reg11),
    .Reg12(Reg12),
    .Reg13(Reg13),
    .Reg14(Reg14),
    .Reg15(Reg15),
    .Reg16(Reg16),
    .Reg17(Reg17),
    .Reg18(Reg18),
    .Reg19(Reg19),  
    .Reg20(Reg20),
    .Reg21(Reg21),
    .Reg22(Reg22),
    .Reg23(Reg23),
    .Reg24(Reg24),
    .Reg25(Reg25),
    .Reg26(Reg26),
    .Reg27(Reg27),
    .Reg28(Reg28),
    .Reg29(Reg29),
    .Reg30(Reg30),
    .Reg31(Reg31),
    .switch(switch),
    .led(led)
);

Sign_Extender ext_sign(
    .imm16_ID(imm16_ID),
    .sign_ext_imm32_ID(sign_ext_imm32_ID)
);

Zero_Extender ext_zero(
    .imm16_ID(imm16_ID),
    .zero_ext_imm32_ID(zero_ext_imm32_ID)
);

ALU_Sources alu_srcs(
    .data_out_2_ID(data_out_2_ID),
    .sign_ext_imm32_ID(sign_ext_imm32_ID),
    .zero_ext_imm32_ID(zero_ext_imm32_ID),
    .ImmExt_ID(ImmExt_ID),
    .ALUSrc_ID(ALUSrc_ID),
    .data_out_2_ALUSrc_ID(data_out_2_ALUSrc_ID)
);

// =====================
// ID -> EX1
// =====================
    
EX1_Pipeline ex1_pipe(

    .reset(reset),
    .clk(clk),

    .Writeback_Control_EX1(Writeback_Control_EX1),
    .Register1_Write_EX1(Register1_Write_EX1),
    .Memory1_Write_EX1(Memory1_Write_EX1),
    .HILO_Register_Enable_EX1(HILO_Register_Enable_EX1),
    .HILO_Select_EX1(HILO_Select_EX1),
    .ALU_Control_EX1(ALU_Control_EX1),
    .instruction_EX1(instruction_EX1),
    .ALU_input1_EX1(ALU_input1_EX1),
    .ALU_input2_EX1(ALU_input2_EX1),
    .store_word_EX1(store_word_EX1),
    .LUI_imm32_result_EX1(LUI_imm32_result_EX1),
    .data_out_2_EX_mux_EX1(data_out_2_EX_mux_EX1),
    .data_out_1_EX_mux_EX1(data_out_1_EX_mux_EX1),
    .data_in_address_EX1(data_in_address_EX1),
    .rt_EX1(rt_EX1),
    .Writeback_Control_EX2(Writeback_Control_EX2),
    .Register1_Write_EX2(Register1_Write_EX2),
    .Memory1_Write_EX2(Memory1_Write_EX2),
    .HILO_Register_Enable_EX2(HILO_Register_Enable_EX2),
    .HILO_Select_EX2(HILO_Select_EX2),
    .ALU_Control_EX2(ALU_Control_EX2),
    .instruction_EX2(instruction_EX2),
    .ALU_input1_EX2(ALU_input1_EX2),
    .ALU_input2_EX2(ALU_input2_EX2),
    .store_word_EX2(store_word_EX2),
    .LUI_imm32_result_EX2(LUI_imm32_result_EX2),
    .data_out_2_EX_mux_EX2(data_out_2_EX_mux_EX2),
    .data_out_1_EX_mux_EX2(data_out_1_EX_mux_EX2),
    .data_in_address_EX2(data_in_address_EX2),
    .rt_EX2(rt_EX2)

);
    
Stall_Unit stall(
    .rt_ID(rt_ID),
    .rs_ID(rs_ID),
    .rd_ID(rd_ID),
    .Writeback_Control_ID(Writeback_Control_ID),
    .Writeback_Control_EX1(Writeback_Control_EX1),
    .Writeback_Control_EX2(Writeback_Control_EX2),
    .ALU_Control_EX1(ALU_Control_EX1),
    .rt_EX1(rt_EX1),
    .rt_EX2(rt_EX2),
    .Flush_Stall(Flush_Stall),
    .Stall_IF(Stall_IF),
    .Stall_PC(Stall_PC),
    .stall_mult(stall_mult),
    .stall_div(stall_div)
);

ALU_Inputs alu_inputs (
    .Forward1(Forward1),
    .Forward2(Forward2),
    .data_out_2_ALUSrc_EX1(data_out_2_ALUSrc_EX1),
    .data_out_1_EX1(data_out_1_EX1),
    .ALU_result_ME(ALU_result_ME),
    .ALU_result_WB(ALU_result_WB),
    .Memory1_Write_EX1(Memory1_Write_EX1),
    .load_word_WB(load_word_WB),
    .LO_result_ME(LO_result_ME),
    .HI_result_ME(HI_result_ME),
    .LO_result_WB(LO_result_WB),
    .HI_result_WB(HI_result_WB),
    .LUI_imm32_result_ME(LUI_imm32_result_ME),
    .LUI_imm32_result_WB(LUI_imm32_result_WB),
    .ALU_input2_EX1(ALU_input2_EX1),
    .ALU_input1_EX1(ALU_input1_EX1),
    .LUI_imm32_result_EX2(LUI_imm32_result_EX2),
    .ALU_result_EX2(ALU_result_EX2)
);

Memory_Input_Sources mem_in_srcs(
    .data_out_2_EX1(data_out_2_EX1),
    .ALU_result_ME(ALU_result_ME),
    .Forward2(Forward2),
    .store_word_EX1(store_word_EX1),
    .ALU_result_WB(ALU_result_WB),
    .load_word_WB(load_word_WB),
    .LO_result_ME(LO_result_ME),
    .HI_result_ME(HI_result_ME),
    .LO_result_WB(LO_result_WB),
    .HI_result_WB(HI_result_WB),
    .LUI_imm32_result_ME(LUI_imm32_result_ME),
    .LUI_imm32_result_WB(LUI_imm32_result_WB),
    .LUI_imm32_result_EX2(LUI_imm32_result_EX2),
    .ALU_result_EX2(ALU_result_EX2)
);
    
Left_Shifter_2bit shifter(
    .sign_ext_imm32_EX1(sign_ext_imm32_EX1),
    .target26_EX1(target26_EX1),
    .branch_imm32_EX1(branch_imm32_EX1),
    .target28_EX1(target28_EX1)
);

Branch_Adder branch_add(
    .pc_adder_value_EX1(pc_adder_value_EX1),
    .branch_imm32_EX1(branch_imm32_EX1),
    .Zero_Flag_EX1(Zero_Flag_EX1),
    .branch_adder_value_EX1(branch_adder_value_EX1),
    .data_out_1_EX_mux_EX1(data_out_1_EX_mux_EX1),
    .data_out_2_EX_mux_EX1(data_out_2_EX_mux_EX1)
);

Jump_Concatenation jump_concat(
    .pc_adder_value_EX1(pc_adder_value_EX1),
    .Jump_EX1(Jump_EX1),
    .target28_EX1(target28_EX1),
    .jump_value_EX1(jump_value_EX1)
);

MultiplierDivider_Inputs multi_inputs(
    .data_out_2_EX1(data_out_2_EX1),
    .data_out_1_EX1(data_out_1_EX1),
    .load_word_WB(load_word_WB),
    .ALU_result_WB(ALU_result_WB),
    .ALU_result_ME(ALU_result_ME),
    .Forward1(Forward1),
    .Forward2(Forward2),
    .data_out_2_EX_mux_EX1(data_out_2_EX_mux_EX1),
    .data_out_1_EX_mux_EX1(data_out_1_EX_mux_EX1),
    .LUI_imm32_result_ME(LUI_imm32_result_ME),
    .LUI_imm32_result_WB(LUI_imm32_result_WB),
    .LO_result_ME(LO_result_ME),
    .HI_result_ME(HI_result_ME),
    .LO_result_WB(LO_result_WB),
    .HI_result_WB(HI_result_WB),
    .LUI_imm32_result_EX2(LUI_imm32_result_EX2),
    .ALU_result_EX2(ALU_result_EX2)
);
    
LUI_Unit lui(
    .imm16_EX1(imm16_EX1[15:0]),
    .LUI_imm32_result_EX1(LUI_imm32_result_EX1)
);
    
Register_Destination reg_dest (
    .Register1_Destination_EX1(Register1_Destination_EX1),
    .rd_EX1(rd_EX1),
    .rt_EX1(rt_EX1),
    .data_in_address_EX1(data_in_address_EX1)
);
    
// =====================
// EX1 -> EX2
// =====================
    
EX2_Pipeline ex2_pipe(
    .reset(reset),
    .clk(clk),

    .ALU_result_EX2(ALU_result_EX2),
    .store_word_EX2(store_word_EX2),
    .HI_send_EX2(HI_send_EX2),
    .LO_send_EX2(LO_send_EX2),
    .LUI_imm32_result_EX2(LUI_imm32_result_EX2),
    .data_in_address_EX2(data_in_address_EX2),
    .Register1_Write_EX2(Register1_Write_EX2),
    .Writeback_Control_EX2(Writeback_Control_EX2),
    .Memory1_Write_EX2(Memory1_Write_EX2),
    .instruction_EX2(instruction_EX2),
    .HILO_Register_Enable_EX2(HILO_Register_Enable_EX2),
    .ALU_Control_EX2(ALU_Control_EX2),
    .Multicycle_HILO_Register_Enable_EX2(Multicycle_HILO_Register_Enable_EX2),
    .rt_EX2(rt_EX2),
    .ALU_Control_ME(ALU_Control_ME),
    .ALU_result_ME(ALU_result_ME),
    .store_word_ME(store_word_ME),
    .HI_send_ME(HI_send_ME),
    .LO_send_ME(LO_send_ME),
    .LUI_imm32_result_ME(LUI_imm32_result_ME),
    .data_in_address_ME(data_in_address_ME),
    .instruction_ME(instruction_ME),
    .Register1_Write_ME(Register1_Write_ME),
    .Writeback_Control_ME(Writeback_Control_ME),
    .Memory1_Write_ME(Memory1_Write_ME),
    .HILO_Register_Enable_ME(HILO_Register_Enable_ME),
    .Multicycle_HILO_Register_Enable_ME(Multicycle_HILO_Register_Enable_ME),
    .rt_ME(rt_ME)

);
    
ALU alu(
    .ALU_input2_EX2(ALU_input2_EX2),
    .ALU_input1_EX2(ALU_input1_EX2),
    .ALU_Control_EX2(ALU_Control_EX2),
    .ALU_result_EX2(ALU_result_EX2)
);


Mult_Div_Multicycle_Control multicycle_control(
  .cycle_div(cycle_div),
  .cycle_mult(cycle_mult),
  .ALU_Control_EX2(ALU_Control_EX2),
  .Writeback_Control_ID(Writeback_Control_ID),
  .Multicycle_HILO_Register_Enable_EX2(Multicycle_HILO_Register_Enable_EX2),
  .stall_mult(stall_mult),
  .stall_div(stall_div),
  .Multiply(Multiply),
  .Divide(Divide),
  .Multicycle_HILO_Select_EX2(Multicycle_HILO_Select_EX2)

);
Multiplier multiplier(
    .clk(clk),
    .reset(reset),
    .data_out_1_EX_mux_EX2(data_out_1_EX_mux_EX2),
    .data_out_2_EX_mux_EX2(data_out_2_EX_mux_EX2),
    .Multiply(Multiply),
    .cycle_mult(cycle_mult),
    .ALU_Control_EX2(ALU_Control_EX2),
    .mult_HI_EX2(mult_HI_EX2),
    .mult_LO_EX2(mult_LO_EX2)

);

Divider divider(
    .reset(reset),
    .clk(clk),
   .data_out_1_EX_mux_EX2(data_out_1_EX_mux_EX2),
   .data_out_2_EX_mux_EX2(data_out_2_EX_mux_EX2),
   .ALU_Control_EX2(ALU_Control_EX2),
   .div_HI_EX2(div_HI_EX2),
   .div_LO_EX2(div_LO_EX2),
   .Divide(Divide),
   .cycle_div(cycle_div)
);


HILO_Register_Inputs reg_hilo_inputs(
    .Multicycle_HILO_Select_EX2(Multicycle_HILO_Select_EX2),
    .mult_HI_EX2(mult_HI_EX2),
    .mult_LO_EX2(mult_LO_EX2),
    .div_HI_EX2(div_HI_EX2),
    .div_LO_EX2(div_LO_EX2),
    .HI_send_EX2(HI_send_EX2),
    .LO_send_EX2(LO_send_EX2)
);

Forward_Unit forwarding_unit (
    .Register1_Write_ME(Register1_Write_ME),
    .Register1_Write_WB(Register1_Write_WB),
    .data_in_address_ME(data_in_address_ME),
    .data_in_address_WB(data_in_address_WB),
    .rt_EX1(rt_EX1),
    .rs_EX1(rs_EX1),
    .Forward1(Forward1),
    .ALUSrc_EX1(ALUSrc_EX1),
    .Forward2(Forward2),
    .Memory1_Write_EX1(Memory1_Write_EX1),
    .Writeback_Control_WB(Writeback_Control_WB),
    .Writeback_Control_ME(Writeback_Control_ME),
    .ALU_Control_ME(ALU_Control_ME),
    .ALU_Control_WB(ALU_Control_WB),
    .data_in_address_EX2(data_in_address_EX2),
    .Register1_Write_EX2(Register1_Write_EX2),
    .Writeback_Control_EX2(Writeback_Control_EX2)
);

Control_Hazard_Unit ctrl_hzrd_unt(
    .Branch_EX1(Branch_EX1),
    .Zero_Flag_EX1(Zero_Flag_EX1),
    .Flush_Branch(Flush_Branch),
    .Flush_ID(Flush_ID),
    .Jump_EX1(Jump_EX1)
);

// =====================
// EX2 -> MEM
// =====================

ME_Pipeline me_pipe(
    .reset(reset),
    .clk(clk),

    .Register1_Write_ME(Register1_Write_ME),
    .Writeback_Control_ME(Writeback_Control_ME),
    .ALU_result_ME(ALU_result_ME),
    .load_word_ME(load_word_ME),
    .HI_result_ME(HI_result_ME),
    .LO_result_ME(LO_result_ME),
    .LUI_imm32_result_ME(LUI_imm32_result_ME),
    .data_in_address_ME(data_in_address_ME),
    .instruction_ME(instruction_ME),
    .ALU_Control_ME(ALU_Control_ME),
    .ALU_Control_WB(ALU_Control_WB),
    .instruction_WB(instruction_WB),
    .Register1_Write_WB(Register1_Write_WB),
    .Writeback_Control_WB(Writeback_Control_WB),
    .ALU_result_WB(ALU_result_WB),
    .load_word_WB(load_word_WB),
    .HI_result_WB(HI_result_WB),
    .LO_result_WB(LO_result_WB),
    .LUI_imm32_result_WB(LUI_imm32_result_WB),
    .data_in_address_WB(data_in_address_WB)
);
    
HILO_Register reg_hilo(
    .clk(clk),
    .reset(reset),
    .HILO_Register_Enable_ME(HILO_Register_Enable_ME),
    .HI_result_ME(HI_result_ME),
    .LO_result_ME(LO_result_ME),
    .HI_send_ME(HI_send_ME),
    .LO_send_ME(LO_send_ME),
    .Multicycle_HILO_Register_Enable_ME(Multicycle_HILO_Register_Enable_ME)
);
    
Data_Memory_1 mem_data(
    .clk(clk),
    .reset(reset),
    .Memory1_Write_ME(Memory1_Write_ME),
    .store_word_ME(store_word_ME),
    .ALU_result_ME(ALU_result_ME),
    .load_word_ME(load_word_ME),
    .RAM_Write_ME(RAM_Write_ME),
    .IO1_Write_ME(IO1_Write_ME),
    .IO2_Write_ME(IO2_Write_ME)
);

Memory_Control_Unit mem_ctrl_unt(
    .ALU_result_ME(ALU_result_ME),
    .RAM_Write_ME(RAM_Write_ME),
    .IO1_Write_ME(IO1_Write_ME),
    .IO2_Write_ME(IO2_Write_ME)
);

    
// =====================
//  WB STAGE
// =====================
Register_Writeback_1 writeback_reg1(
    .ALU_result_WB(ALU_result_WB),
    .HI_result_WB(HI_result_WB),
    .LO_result_WB(LO_result_WB),
    .LUI_imm32_result_WB(LUI_imm32_result_WB),
    .Writeback_Control_WB(Writeback_Control_WB),
    .load_word_WB(load_word_WB),
    .data_in_WB(data_in_WB)
);

endmodule
