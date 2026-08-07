/*
Since program counter address increments by 4, each branch and jump instruction must have their immediate and target value shifted by 2 bits to match the program counter behavior.
*/
module Left_Shifter_2bit (
    input logic [31:0] sign_ext_imm32_EX1,
    input logic [25:0] target26_EX1,
    output logic [31:0] branch_imm32_EX1,
    output logic [27:0] target28_EX1
);
    assign branch_imm32_EX1 = (sign_ext_imm32_EX1 << 2);
    assign target28_EX1 = (target26_EX1 << 2);
endmodule
