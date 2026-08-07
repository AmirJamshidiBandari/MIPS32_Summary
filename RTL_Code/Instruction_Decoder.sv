module Instruction_Decoder (
    input logic [31:0] instruction_ID,
    output logic [5:0] op_ID,
    output logic [4:0] rs_ID,
    output logic [4:0] rt_ID,
    output logic [4:0] rd_ID,
    output logic [4:0] sa_ID,
    output logic [5:0] fn_ID,
    output logic [15:0] imm16_ID,
    output logic [25:0] target26_ID
);

    assign op_ID = instruction_ID[31:26]; // Decoded value for control unit.
    assign rs_ID = instruction_ID[25:21]; // Decoded value for register.
    assign rt_ID = instruction_ID[20:16]; // Decoded value for register.
    assign rd_ID = instruction_ID[15:11]; // Decoded value for register.
    assign sa_ID = instruction_ID[10:6]; // For current design, no use case.
    assign fn_ID = instruction_ID[5:0]; // Decoded value for control unit.
    assign imm16_ID = instruction_ID[15:0]; // Decoded value for immediate forming.
    assign target26_ID = instruction_ID[25:0]; // Decoded value for jump instruction.

endmodule
