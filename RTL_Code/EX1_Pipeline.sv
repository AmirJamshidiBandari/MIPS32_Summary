import MIPS_Definitions::*;
/*
This is the pipeline register between decoder stage and second execute stage.
*/
module EX1_Pipeline (
    input logic clk,
    input logic reset,
    input writeback_t Writeback_Control_EX1,
    input logic Register1_Write_EX1,
    input logic Memory1_Write_EX1,
    input logic HILO_Register_Enable_EX1,
    input HILO_select_t HILO_Select_EX1,
    input alu_ctrl_t ALU_Control_EX1,
    input logic [31:0] instruction_EX1,
    input logic [31:0] ALU_input1_EX1,
    input logic [31:0] ALU_input2_EX1,
    input logic [31:0] store_word_EX1,
    input logic [31:0] LUI_imm32_result_EX1,
    input logic [31:0] data_out_2_EX_mux_EX1,
    input logic [31:0] data_out_1_EX_mux_EX1,
    input logic [4:0] data_in_address_EX1,
    input logic [4:0] rt_EX1,
    output writeback_t Writeback_Control_EX2,
    output logic Register1_Write_EX2,
    output logic Memory1_Write_EX2,
    output logic HILO_Register_Enable_EX2,
    output HILO_select_t HILO_Select_EX2,
    output alu_ctrl_t ALU_Control_EX2,
    output logic [31:0] instruction_EX2,
    output logic [31:0] ALU_input1_EX2,
    output logic [31:0] ALU_input2_EX2,
    output logic [31:0] store_word_EX2,
    output logic [31:0] LUI_imm32_result_EX2,
    output logic [31:0] data_out_2_EX_mux_EX2,
    output logic [31:0] data_out_1_EX_mux_EX2,
    output logic [4:0] data_in_address_EX2,
    output logic [4:0] rt_EX2


);
    always_ff @(posedge reset or posedge clk) begin
        if (reset) begin
            Writeback_Control_EX2 <= WB_NONE;
            Register1_Write_EX2 <= 0;
            Memory1_Write_EX2 <= 0;
            HILO_Register_Enable_EX2 <= 0;
            HILO_Select_EX2 <= HILO_NONE;
            ALU_Control_EX2 <= ALU_NONE;
            instruction_EX2 <= 0;
            ALU_input1_EX2 <= 0;
            ALU_input2_EX2 <= 0;
            store_word_EX2 <= 0;
            LUI_imm32_result_EX2 <= 0;
            data_out_2_EX_mux_EX2 <= 0;
            data_out_1_EX_mux_EX2 <= 0;
            data_in_address_EX2 <= 0;
            rt_EX2 <= 0;
        end

        else begin 
            Writeback_Control_EX2 <= Writeback_Control_EX1;
            Register1_Write_EX2 <= Register1_Write_EX1;
            Memory1_Write_EX2 <= Memory1_Write_EX1;
            HILO_Register_Enable_EX2 <= HILO_Register_Enable_EX1;
            HILO_Select_EX2 <= HILO_Select_EX1;
            ALU_Control_EX2 <= ALU_Control_EX1;
            instruction_EX2 <= instruction_EX1;
            ALU_input1_EX2 <= ALU_input1_EX1;
            ALU_input2_EX2 <= ALU_input2_EX1;
            store_word_EX2 <= store_word_EX1;
            LUI_imm32_result_EX2 <= LUI_imm32_result_EX1;
            data_out_2_EX_mux_EX2 <= data_out_2_EX_mux_EX1;
            data_out_1_EX_mux_EX2 <= data_out_1_EX_mux_EX1;
            data_in_address_EX2 <= data_in_address_EX1;
            rt_EX2 <= rt_EX1;
        end
    end
endmodule
