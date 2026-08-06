import MIPS_Definitions::*;
/*
This is the pipeline register between first execute stage and memory stage.
*/
module EX2_Pipeline (
    input logic reset,
    input logic clk,
    input logic [31:0] ALU_result_EX2,
    input logic [31:0] store_word_EX2,
    input logic [31:0] HI_send_EX2,
    input logic [31:0] LO_send_EX2,
    input logic [31:0] LUI_imm32_result_EX2,
    input logic [4:0] data_in_address_EX2,
    input logic Register1_Write_EX2,
    input writeback_t Writeback_Control_EX2,
    input logic Memory1_Write_EX2,
    input logic [31:0] instruction_EX2,
    input logic HILO_Register_Enable_EX2,
    input alu_ctrl_t ALU_Control_EX2,
    input logic Multicycle_HILO_Register_Enable_EX2,
    input logic [4:0] rt_EX2,
    output logic [31:0] ALU_result_ME,  
    output logic [31:0] store_word_ME,
    output logic [31:0] HI_send_ME,
    output logic [31:0] LO_send_ME,
    output logic [31:0] LUI_imm32_result_ME,
    output logic [4:0] data_in_address_ME,
    output logic Register1_Write_ME,
    output writeback_t Writeback_Control_ME,
    output logic Memory1_Write_ME,
    output logic [31:0] instruction_ME,
    output logic HILO_Register_Enable_ME,
    output alu_ctrl_t ALU_Control_ME,
    output logic Multicycle_HILO_Register_Enable_ME,
    output logic [4:0] rt_ME

); 

   always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        ALU_result_ME <= 0;
        store_word_ME <= 0;
        HI_send_ME <= 0;
        LO_send_ME <= 0;
        LUI_imm32_result_ME <= 0;
        data_in_address_ME <= 0;
        Register1_Write_ME <= 0;
        Writeback_Control_ME <= WB_NONE;
        Memory1_Write_ME <= 0;
        instruction_ME <= 0;
        HILO_Register_Enable_ME <= 0;
        ALU_Control_ME <= ALU_NONE;
        Multicycle_HILO_Register_Enable_ME <= 0;
        rt_ME <= 0;
    end
    else begin 
        ALU_result_ME <= ALU_result_EX2; 
        store_word_ME <= store_word_EX2;
        HI_send_ME <= HI_send_EX2;
        LO_send_ME <= LO_send_EX2;
        LUI_imm32_result_ME <= LUI_imm32_result_EX2;
        data_in_address_ME <= data_in_address_EX2;
        Register1_Write_ME <= Register1_Write_EX2;
        Writeback_Control_ME <= Writeback_Control_EX2;
        Memory1_Write_ME <= Memory1_Write_EX2;
        instruction_ME <= instruction_EX2;
        HILO_Register_Enable_ME <= HILO_Register_Enable_EX2;
        ALU_Control_ME <= ALU_Control_EX2;
        Multicycle_HILO_Register_Enable_ME <= Multicycle_HILO_Register_Enable_EX2;
        rt_ME <= rt_EX2;
    end 
   end 
endmodule
