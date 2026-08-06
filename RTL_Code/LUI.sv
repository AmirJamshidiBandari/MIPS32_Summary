module LUI_Unit (
    input logic [15:0] imm16_EX1,
    output logic [31:0] LUI_imm32_result_EX1
);
    assign LUI_imm32_result_EX1= (imm16_EX1 << 16);
endmodule