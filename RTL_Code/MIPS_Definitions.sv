package MIPS_Definitions;

// Instruction opcodes.
typedef enum logic [5:0] {
    RTYPE = 6'b000000,
    LW    = 6'b100011,
    SW    = 6'b101011,
    BEQ   = 6'b000100,
    LUI   = 6'b001111,
    ORI   = 6'b001101,
    ADDI  = 6'b001000,
    J     = 6'b000010
} opcode_t;

// R-type function codes.
typedef enum logic [5:0] {
    ADD   = 6'b100000,
    AND   = 6'b100100,
    DIV   = 6'b011010,
    MFLO  = 6'b010010,
    MFHI  = 6'b010000,
    MULT  = 6'b011000,
    MULTU = 6'b011001,
    NOR   = 6'b100111,
    OR    = 6'b100101,
    SUB   = 6'b100010,
    XOR   = 6'b100110
} funct_t;

// ALU operations.
typedef enum logic [4:0] {
    ALU_NONE,
    ALU_ADD,
    ALU_AND,
    ALU_DIV,
    ALU_MFLO,
    ALU_MFHI,
    ALU_MULT,
    ALU_MULTU,
    ALU_NOR,
    ALU_OR,
    ALU_SUB,
    ALU_XOR
} alu_ctrl_t;

// Register writeback paths.
typedef enum logic [3:0] {
    WB_NONE,
    WB_ALU,
    WB_HI,
    WB_LO,
    WB_LUI,
    WB_ORI,
    WB_LW,
    WB_ADDI
} writeback_t;

// Program counter writeback paths.
typedef enum logic [1:0] {
    PC_NEXT,
    PC_JUMP,
    PC_BRANCH
} writeback_pc_t;

// HILO register selection paths.
typedef enum logic [1:0] {
    HILO_NONE,
    HILO_DIV,
    HILO_MULT
} HILO_select_t;

// First operand forwarding paths.
typedef enum logic [3:0] {
    FRW1_NONE    = 4'b0000,
    FRW1_ALU_ME  = 4'b0001,
    FRW1_ALU_WB  = 4'b0010,
    FRW1_LOAD_WB = 4'b0011,
    FRW1_LO_ME   = 4'b0100,
    FRW1_HI_ME   = 4'b0101,
    FRW1_LO_WB   = 4'b0110,
    FRW1_HI_WB   = 4'b0111,
    FRW1_LUI_ME   = 4'b1000,
    FRW1_LUI_WB   = 4'b1001,
    FRW1_ALU_EX2   = 4'b1010,
    FRW1_LO_EX2   = 4'b1011,
    FRW1_HI_EX2   = 4'b1100,
    FRW1_LUI_EX2   = 4'b1101
} forward1_t;

// Second operand forwarding paths.
typedef enum logic [3:0] {
    FRW2_NONE    = 4'b0000,
    FRW2_ALU_ME  = 4'b0001,
    FRW2_ALU_WB  = 4'b0010,
    FRW2_LOAD_WB = 4'b0011,
    FRW2_LO_ME   = 4'b0100,
    FRW2_HI_ME   = 4'b0101,
    FRW2_LO_WB   = 4'b0110,
    FRW2_HI_WB   = 4'b0111,
    FRW2_LUI_ME   = 4'b1000,
    FRW2_LUI_WB   = 4'b1001,
    FRW2_ALU_EX2   = 4'b1010,
    FRW2_LO_EX2   = 4'b1011,
    FRW2_HI_EX2   = 4'b1100,
    FRW2_LUI_EX2   = 4'b1101
} forward2_t;

endpackage
