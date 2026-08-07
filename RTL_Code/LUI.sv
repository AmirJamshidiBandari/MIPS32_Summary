module LUI_Unit (
    input logic [15:0] imm16_EX1,
    output logic [31:0] LUI_imm32_result_EX1
);
    assign LUI_imm32_result_EX1= (imm16_EX1 << 16); // The load upper immediate creates the upper 16 bits of a 32-bit value, the LUI and ORI instructions are mainly used to create large address and values.
endmodule
