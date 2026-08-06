import MIPS_Definitions::*;
module MultiplierDivider_Inputs(
    input logic [31:0] data_out_2_EX1,
    input logic [31:0] data_out_1_EX1,
    input logic [31:0] load_word_WB,
    input logic [31:0] ALU_result_WB,
    input logic [31:0] ALU_result_ME,
    input logic [31:0] LO_result_ME,
    input logic [31:0] HI_result_ME,
    input logic [31:0] LO_result_WB,
    input logic [31:0] HI_result_WB,
    input logic [31:0] LUI_imm32_result_ME,
    input logic [31:0] LUI_imm32_result_WB,
    input forward1_t Forward1,
    input forward2_t Forward2,
    input logic [31:0] LUI_imm32_result_EX2,
    input logic [31:0] ALU_result_EX2,
    output logic [31:0] data_out_2_EX_mux_EX1,
    output logic [31:0] data_out_1_EX_mux_EX1

);
always_comb begin
    data_out_1_EX_mux_EX1 = data_out_1_EX1;
    data_out_2_EX_mux_EX1 = data_out_2_EX1;

    case (Forward1)
        FRW1_ALU_ME: data_out_1_EX_mux_EX1 = ALU_result_ME;
        FRW1_ALU_WB: data_out_1_EX_mux_EX1 = ALU_result_WB;
        FRW1_LOAD_WB: data_out_1_EX_mux_EX1 = load_word_WB;
        FRW1_LO_ME: data_out_1_EX_mux_EX1 = LO_result_ME;
        FRW1_HI_ME: data_out_1_EX_mux_EX1 = HI_result_ME;
        FRW1_LO_WB: data_out_1_EX_mux_EX1 = LO_result_WB;
        FRW1_HI_WB: data_out_1_EX_mux_EX1 = HI_result_WB;
        FRW1_LUI_ME: data_out_1_EX_mux_EX1 = LUI_imm32_result_ME;
        FRW1_LUI_WB: data_out_1_EX_mux_EX1 = LUI_imm32_result_WB;
        FRW1_LUI_EX2: data_out_1_EX_mux_EX1 = LUI_imm32_result_EX2;
        FRW1_ALU_EX2: data_out_1_EX_mux_EX1 = ALU_result_EX2;
        FRW1_HI_EX2: data_out_1_EX_mux_EX1 = HI_result_ME;
        FRW1_LO_EX2: data_out_1_EX_mux_EX1 = LO_result_ME;
    endcase

    case (Forward2)
        FRW2_ALU_ME: data_out_2_EX_mux_EX1 = ALU_result_ME;
        FRW2_ALU_WB: data_out_2_EX_mux_EX1 = ALU_result_WB;
        FRW2_LOAD_WB: data_out_2_EX_mux_EX1 = load_word_WB;
        FRW2_LO_ME: data_out_2_EX_mux_EX1 = LO_result_ME;
        FRW2_HI_ME: data_out_2_EX_mux_EX1 = HI_result_ME;
        FRW2_LO_WB: data_out_2_EX_mux_EX1 = LO_result_WB;
        FRW2_HI_WB: data_out_2_EX_mux_EX1 = HI_result_WB;
        FRW2_LUI_ME: data_out_2_EX_mux_EX1 = LUI_imm32_result_ME;
        FRW2_LUI_WB: data_out_2_EX_mux_EX1 = LUI_imm32_result_WB;
        FRW2_LUI_EX2: data_out_2_EX_mux_EX1 = LUI_imm32_result_EX2;
        FRW2_ALU_EX2: data_out_2_EX_mux_EX1 = ALU_result_EX2;
        FRW2_HI_EX2: data_out_2_EX_mux_EX1 = HI_result_ME;
        FRW2_LO_EX2: data_out_2_EX_mux_EX1 = LO_result_ME;
    endcase
end
endmodule