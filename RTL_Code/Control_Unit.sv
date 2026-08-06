import MIPS_Definitions::*;
/*
Control unit controls the behavior if instructions across the processor, it supports R, I, and J instruction types.
*/
module Control_Unit (
    input opcode_t op_ID,
    input funct_t fn_ID,
    output logic ImmExt_ID,
    output alu_ctrl_t ALU_Control_ID,
    output logic ALUSrc_ID,
    output logic Register1_Write_ID,
    output HILO_select_t HILO_Select_ID,
    output writeback_t Writeback_Control_ID,
    output logic Memory1_Write_ID,
    output logic Jump_ID,
    output logic Branch_ID,
    output logic Register1_Destination_ID,
    output logic HILO_Register_Enable_ID
);

always_comb
begin
    // Default values.
    HILO_Select_ID = HILO_NONE;
    Writeback_Control_ID = WB_NONE;
    ALU_Control_ID = ALU_NONE;  
    ImmExt_ID = 0;
    ALUSrc_ID = 0;
    Register1_Write_ID = 0;
    Register1_Destination_ID = 0;
    Memory1_Write_ID = 0;
    Jump_ID = 0;
    Branch_ID = 0;
    HILO_Register_Enable_ID = 0;

    case (op_ID)

        // R type.
        RTYPE:
        begin
            case (fn_ID)

                ADD: begin
                    ALU_Control_ID = ALU_ADD;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

                AND: begin
                    ALU_Control_ID = ALU_AND;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

                DIV: begin
                    ALU_Control_ID = ALU_DIV;
                    HILO_Select_ID = HILO_DIV;
                    HILO_Register_Enable_ID = 1;
                end

                MFHI: begin
                    ALU_Control_ID = ALU_MFHI;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_HI;
                end

                MFLO: begin
                    ALU_Control_ID = ALU_MFLO;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_LO;
                end

                MULT: begin
                    ALU_Control_ID = ALU_MULT;
                    HILO_Select_ID = HILO_MULT;
                end

                MULTU: begin
                    ALU_Control_ID = ALU_MULTU;
                    HILO_Select_ID = HILO_MULT;
                end

                NOR: begin
                    ALU_Control_ID = ALU_NOR;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

                OR: begin
                    ALU_Control_ID = ALU_OR;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

                SUB: begin
                    ALU_Control_ID = ALU_SUB;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

                XOR: begin
                    ALU_Control_ID = ALU_XOR;
                    Register1_Write_ID = 1;
                    Register1_Destination_ID = 1;
                    Writeback_Control_ID = WB_ALU;
                end

            endcase
        end

        // I type.
        LUI:
        begin
            Register1_Write_ID = 1;
            Writeback_Control_ID = WB_LUI;
        end

        ORI:
        begin
            ImmExt_ID = 0;
            ALUSrc_ID = 1;
            ALU_Control_ID = ALU_OR;
            Register1_Write_ID = 1;
            Writeback_Control_ID = WB_ORI;
        end

        LW:
        begin
            Register1_Write_ID = 1;
            ImmExt_ID = 1;
            ALUSrc_ID = 1;
            ALU_Control_ID = ALU_ADD;
            Writeback_Control_ID = WB_LW;
        end

        SW:
        begin
            ImmExt_ID = 1;
            ALUSrc_ID = 1;
            ALU_Control_ID = ALU_ADD;
            Memory1_Write_ID = 1;
        end

        BEQ:
        begin
            ALU_Control_ID = ALU_SUB;
            Branch_ID = 1;
        end

        ADDI:
        begin
            ImmExt_ID = 1;
            ALUSrc_ID = 1;
            ALU_Control_ID = ALU_ADD;
            Register1_Write_ID = 1;
            Writeback_Control_ID = WB_ADDI;
        end

        // J type.
        J:
        begin
            Jump_ID = 1;
        end

    endcase
end
endmodule   
