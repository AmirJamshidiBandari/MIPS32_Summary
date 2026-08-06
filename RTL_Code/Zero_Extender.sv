module Zero_Extender (
    input logic [15:0] imm16_ID,
    output logic [31:0] zero_ext_imm32_ID
);
    assign zero_ext_imm32_ID = {16'b0, imm16_ID};
endmodule