import MIPS_Definitions::*;
module Memory_Input_Sources (
    input logic [31:0] data_out_2_EX1,
    input logic [31:0] ALU_result_ME,
    input logic [31:0] ALU_result_WB,
    input forward2_t Forward2,
    input logic [31:0] load_word_WB,
    input logic [31:0] LO_result_ME,
    input logic [31:0] HI_result_ME,
    input logic [31:0] LO_result_WB,
    input logic [31:0] HI_result_WB,
    input logic [31:0] LUI_imm32_result_ME,
    input logic [31:0] LUI_imm32_result_WB,
    input logic [31:0] LUI_imm32_result_EX2,
    input logic [31:0] ALU_result_EX2,
    output logic [31:0] store_word_EX1
);
    always_comb begin
        store_word_EX1 = data_out_2_EX1;
        case (Forward2)
            FRW2_ALU_ME: store_word_EX1 = ALU_result_ME;
            FRW2_ALU_WB: store_word_EX1 = ALU_result_WB;
            FRW2_LOAD_WB: store_word_EX1 = load_word_WB;
            FRW2_LO_ME: store_word_EX1 = LO_result_ME;
            FRW2_HI_ME: store_word_EX1 = HI_result_ME;
            FRW2_LO_WB: store_word_EX1 = LO_result_WB;
            FRW2_HI_WB: store_word_EX1 = HI_result_WB;
            FRW2_LUI_ME: store_word_EX1 = LUI_imm32_result_ME;
            FRW2_LUI_WB: store_word_EX1 = LUI_imm32_result_WB;
            FRW2_LUI_EX2: store_word_EX1 = LUI_imm32_result_EX2;
            FRW2_ALU_EX2: store_word_EX1 = ALU_result_EX2;
            FRW2_HI_EX2: store_word_EX1 = HI_result_ME;
            FRW2_LO_EX2: store_word_EX1 = LO_result_ME;
        endcase
    end
endmodule   