import MIPS_Definitions::*;
/*
This is the pipeline register between memory stage and writeback stage.
*/
module ME_Pipeline (
    input logic reset,
    input logic clk,
    input logic Register1_Write_ME,
    input writeback_t Writeback_Control_ME,
    input logic [31:0] ALU_result_ME,
    input logic [31:0] load_word_ME,
    input logic [31:0] HI_result_ME,
    input logic [31:0] LO_result_ME,
    input logic [31:0] LUI_imm32_result_ME,
    input logic [4:0] data_in_address_ME,
    input logic [31:0] instruction_ME,
    input alu_ctrl_t ALU_Control_ME,
    output logic Register1_Write_WB,
    output writeback_t Writeback_Control_WB,
    output logic [31:0] ALU_result_WB,
    output logic [31:0] load_word_WB,
    output logic [31:0] HI_result_WB,
    output logic [31:0] LO_result_WB,
    output logic [31:0] LUI_imm32_result_WB,
    output logic [4:0] data_in_address_WB,
    output logic [31:0] instruction_WB,
    output alu_ctrl_t ALU_Control_WB
);
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            Register1_Write_WB <= 0;
            Writeback_Control_WB <= WB_NONE;
            ALU_result_WB <= 0;
            load_word_WB <= 0;
            HI_result_WB <= 0;
            LO_result_WB <= 0;
            LUI_imm32_result_WB <= 0;
            data_in_address_WB <= 0;
            instruction_WB <= 0;
            ALU_Control_WB <= ALU_NONE;
        end 
        else begin 
            Register1_Write_WB <= Register1_Write_ME;
            Writeback_Control_WB <= Writeback_Control_ME;
            ALU_result_WB <= ALU_result_ME;
            load_word_WB <= load_word_ME;
            HI_result_WB <= HI_result_ME;
            LO_result_WB <= LO_result_ME;
            LUI_imm32_result_WB <= LUI_imm32_result_ME;
            data_in_address_WB <= data_in_address_ME;
            instruction_WB <= instruction_ME;
            ALU_Control_WB <= ALU_Control_ME;
        end
    end
endmodule
