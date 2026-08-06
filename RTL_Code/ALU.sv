import MIPS_Definitions::*;
/*
The ALU performs mathematical and logical operations, it picks the operation based on control unit signal.
*/
module ALU (
    input logic [31:0] ALU_input2_EX2,
    input logic [31:0] ALU_input1_EX2,
    input alu_ctrl_t ALU_Control_EX2,
    output logic [31:0] ALU_result_EX2
);
    always_comb begin
        case (ALU_Control_EX2)
            ALU_ADD: ALU_result_EX2 = ALU_input1_EX2 + ALU_input2_EX2;
            ALU_AND: ALU_result_EX2 = ALU_input1_EX2 & ALU_input2_EX2;
            ALU_NOR: ALU_result_EX2 = ~(ALU_input1_EX2 | ALU_input2_EX2);
            ALU_OR: ALU_result_EX2 = ALU_input1_EX2 | ALU_input2_EX2;
            ALU_SUB: ALU_result_EX2 = ALU_input1_EX2 - ALU_input2_EX2;
            ALU_XOR: ALU_result_EX2 = ALU_input1_EX2 ^ ALU_input2_EX2;
            default: ALU_result_EX2 = 32'b0;
        endcase
    end
endmodule
