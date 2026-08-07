import MIPS_Definitions::*;
/*
This is the pipeline register between instruction decode stage and first execute stage.
*/
module ID_Pipeline (
    input logic reset,
    input logic clk,
    input logic [31:0] data_out_2_ALUSrc_ID,
    input logic [31:0] data_out_2_ID,
    input logic [31:0] data_out_1_ID,
    input logic [31:0] pc_adder_value_ID,
    input logic [15:0] imm16_ID,
    input logic [31:0] sign_ext_imm32_ID,
    input logic [4:0] rt_ID,
    input logic [4:0] rd_ID,
    input logic [4:0] rs_ID,
    input logic [25:0] target26_ID,
    input alu_ctrl_t ALU_Control_ID,
    input logic Register1_Write_ID,
    input HILO_select_t HILO_Select_ID,
    input writeback_t Writeback_Control_ID,
    input logic Memory1_Write_ID,
    input logic Jump_ID,
    input logic Branch_ID,
    input logic Register1_Destination_ID,
    input logic HILO_Register_Enable_ID,
    input logic Flush_Stall,
    input logic Flush_Branch,
    input logic ALUSrc_ID,
    input logic [31:0] instruction_ID,
    output logic [31:0] data_out_2_ALUSrc_EX1,
    output logic [31:0] data_out_2_EX1,
    output logic [31:0] data_out_1_EX1,
    output logic [31:0] pc_adder_value_EX1,
    output logic [15:0] imm16_EX1,
    output logic [31:0] sign_ext_imm32_EX1,
    output logic [4:0] rt_EX1,
    output logic [4:0] rd_EX1,
    output logic [4:0] rs_EX1,
    output logic [25:0] target26_EX1,
    output alu_ctrl_t ALU_Control_EX1,
    output logic Register1_Write_EX1,
    output HILO_select_t HILO_Select_EX1,
    output writeback_t Writeback_Control_EX1,
    output logic Memory1_Write_EX1,
    output logic Jump_EX1,
    output logic Branch_EX1,
    output logic Register1_Destination_EX1,
    output logic HILO_Register_Enable_EX1,
    output logic ALUSrc_EX1,
    output logic [31:0] instruction_EX1
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_2_ALUSrc_EX1 <= 0;
            ALUSrc_EX1 <= 0;
            data_out_2_EX1 <= 0;
            data_out_1_EX1 <= 0;
            pc_adder_value_EX1 <= 0;
            imm16_EX1 <= 0;
            sign_ext_imm32_EX1 <= 0;
            rt_EX1 <= 0;
            rd_EX1 <= 0;
            rs_EX1 <= 0;
            target26_EX1 <= 0;
            ALU_Control_EX1 <= ALU_NONE;
            Register1_Write_EX1 <= 0;
            HILO_Select_EX1 <= HILO_NONE;
            Writeback_Control_EX1 <= WB_NONE;
            Memory1_Write_EX1 <= 0;
            Jump_EX1 <= 0;
            Branch_EX1 <= 0;
            Register1_Destination_EX1 <= 0;
            HILO_Register_Enable_EX1 <= 0;
            instruction_EX1 <= 0;
        end 
        else if (Flush_Stall || Flush_Branch) begin // Flush this stage if there is a control or stall hazard.
            Register1_Write_EX1 <= 0;
            HILO_Select_EX1 <= HILO_NONE;
            Writeback_Control_EX1 <= WB_NONE;
            Memory1_Write_EX1 <= 0;
            Jump_EX1 <= 0;
            Branch_EX1 <= 0;
            Register1_Destination_EX1 <= 0; 
            HILO_Register_Enable_EX1 <= 0;
            instruction_EX1 <= 0;
            rs_EX1 <= 0;
            rt_EX1 <= 0;
            if ((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) begin
                ALU_Control_EX1 <= ALU_NONE;
            end
            
        end
        else begin
            data_out_2_ALUSrc_EX1 <= data_out_2_ALUSrc_ID;
            ALUSrc_EX1 <= ALUSrc_ID;
            data_out_2_EX1 <= data_out_2_ID;
            data_out_1_EX1 <= data_out_1_ID;
            pc_adder_value_EX1 <= pc_adder_value_ID;
            imm16_EX1 <= imm16_ID;
            sign_ext_imm32_EX1 <= sign_ext_imm32_ID; 
            rt_EX1 <= rt_ID; 
            rd_EX1 <= rd_ID;
            rs_EX1 <= rs_ID;
            target26_EX1 <= target26_ID;
            ALU_Control_EX1 <= ALU_Control_ID;
            Register1_Write_EX1 <= Register1_Write_ID;
            HILO_Select_EX1 <= HILO_Select_ID;
            Writeback_Control_EX1 <= Writeback_Control_ID;
            Memory1_Write_EX1 <= Memory1_Write_ID;
            Jump_EX1 <= Jump_ID;
            Branch_EX1 <= Branch_ID;
            Register1_Destination_EX1 <= Register1_Destination_ID;
            HILO_Register_Enable_EX1 <= HILO_Register_Enable_ID;
            instruction_EX1 <= instruction_ID;
        end
    end
endmodule
