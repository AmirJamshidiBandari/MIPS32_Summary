/*
This is two ALU input multiplexers, in a non forwarding situation it picks register operands, but if there is forwarding then a forwarded data is picked as ALU oeprand, the forwarded data comes from second execute stage, memory stage, and writeback stage.
The second ALU input has a edge case with memory write, because when Memory1_Write_EX1 signal is true, the second register operand acts as a destination memory, not a value to perform operations on. 
*/
module ALU_Inputs (
    input forward1_t Forward1,
    input forward2_t Forward2,
    input logic [31:0] data_out_2_ALUSrc_EX1,
    input logic [31:0] data_out_1_EX1,
    input logic [31:0] ALU_result_EX2,
    input logic [31:0] ALU_result_ME,
    input logic [31:0] ALU_result_WB,
    input logic Memory1_Write_EX1,
    input logic [31:0] load_word_WB,
    input logic [31:0] LO_result_ME,
    input logic [31:0] HI_result_ME,
    input logic [31:0] LO_result_WB,
    input logic [31:0] HI_result_WB,
    input logic [31:0] LUI_imm32_result_EX2,
    input logic [31:0] LUI_imm32_result_ME,
    input logic [31:0] LUI_imm32_result_WB,
    output logic [31:0] ALU_input2_EX1,
    output logic [31:0] ALU_input1_EX1
);
    
    always_comb begin
        ALU_input1_EX1 = data_out_1_EX1;
        ALU_input2_EX1 = data_out_2_ALUSrc_EX1;

        case (Forward1)
            FRW1_ALU_ME: ALU_input1_EX1 = ALU_result_ME;
            FRW1_ALU_WB: ALU_input1_EX1 = ALU_result_WB;
            FRW1_LOAD_WB: ALU_input1_EX1 = load_word_WB;
            FRW1_LO_ME: ALU_input1_EX1 = LO_result_ME;
            FRW1_HI_ME: ALU_input1_EX1 = HI_result_ME;
            FRW1_LO_WB: ALU_input1_EX1 = LO_result_WB;
            FRW1_HI_WB: ALU_input1_EX1 = HI_result_WB;
            FRW1_LUI_ME: ALU_input1_EX1 = LUI_imm32_result_ME;
            FRW1_LUI_WB: ALU_input1_EX1 = LUI_imm32_result_WB;
            FRW1_LUI_EX2: ALU_input1_EX1 = LUI_imm32_result_EX2;
            FRW1_ALU_EX2: ALU_input1_EX1 = ALU_result_EX2;
            FRW1_HI_EX2: ALU_input1_EX1 = HI_result_ME;
            FRW1_LO_EX2: ALU_input1_EX1 = LO_result_ME;
        endcase

    if (Memory1_Write_EX1 == 0)
        case (Forward2)
            FRW2_ALU_ME: ALU_input2_EX1 = ALU_result_ME;
            FRW2_ALU_WB: ALU_input2_EX1 = ALU_result_WB;
            FRW2_LOAD_WB: ALU_input2_EX1 = load_word_WB;
            FRW2_LO_ME: ALU_input2_EX1 = LO_result_ME;
            FRW2_HI_ME: ALU_input2_EX1 = HI_result_ME;
            FRW2_LO_WB: ALU_input2_EX1 = LO_result_WB;
            FRW2_HI_WB: ALU_input2_EX1 = HI_result_WB;
            FRW2_LUI_ME: ALU_input2_EX1 = LUI_imm32_result_ME;
            FRW2_LUI_WB: ALU_input2_EX1 = LUI_imm32_result_WB;
            FRW2_LUI_EX2: ALU_input2_EX1 = LUI_imm32_result_EX2;
            FRW2_ALU_EX2: ALU_input2_EX1 = ALU_result_EX2;
            FRW2_HI_EX2: ALU_input2_EX1 = HI_result_ME;
            FRW2_LO_EX2: ALU_input2_EX1 = LO_result_ME;
        endcase
    else ALU_input2_EX1 = data_out_2_ALUSrc_EX1;

end
endmodule
