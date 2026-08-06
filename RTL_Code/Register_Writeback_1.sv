import MIPS_Definitions::*;
module Register_Writeback_1 (
    input logic [31:0] ALU_result_WB,
    input logic [31:0] HI_result_WB,
    input logic [31:0] LO_result_WB,
    input logic [31:0] LUI_imm32_result_WB,
    input writeback_t Writeback_Control_WB,
    input logic [31:0] load_word_WB,
    output logic [31:0] data_in_WB
);

    always_comb begin
        data_in_WB = 0;
        case (Writeback_Control_WB)
            WB_ALU: data_in_WB = ALU_result_WB;

            WB_HI: data_in_WB = HI_result_WB;

            WB_LO: data_in_WB = LO_result_WB;

            WB_LUI: data_in_WB = LUI_imm32_result_WB;
    
            WB_ORI: data_in_WB = ALU_result_WB;

            WB_LW: data_in_WB = load_word_WB;

            WB_ADDI: data_in_WB = ALU_result_WB;
        endcase
    end
endmodule