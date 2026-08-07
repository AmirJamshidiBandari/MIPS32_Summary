module Sign_Extender (
    input logic [15:0] imm16_ID,
    output logic [31:0] sign_ext_imm32_ID
);
    assign sign_ext_imm32_ID = {{16{imm16_ID[15]}}, imm16_ID}; // Extend the immediate based on the final bit.
endmodule
