import MIPS_Definitions::*;

module Forward_Unit (
    input logic Register1_Write_EX2,
    input logic Register1_Write_ME,
    input logic Register1_Write_WB,
    input logic [4:0] data_in_address_EX2,
    input logic [4:0] data_in_address_ME,
    input logic [4:0] data_in_address_WB,
    input logic [4:0] rt_EX1,
    input logic [4:0] rs_EX1,
    input logic ALUSrc_EX1,
    input logic Memory1_Write_EX1,
    input writeback_t Writeback_Control_EX2,
    input writeback_t Writeback_Control_WB,
    input writeback_t Writeback_Control_ME,
    input alu_ctrl_t ALU_Control_ME,
    input alu_ctrl_t ALU_Control_WB,
    output forward1_t Forward1,
    output forward2_t Forward2
);

    always_comb begin
        Forward1 = FRW1_NONE;
        Forward2 = FRW2_NONE;

    if ((Register1_Write_EX2 == 1) && (data_in_address_EX2 != 0)) begin
        if ((data_in_address_EX2 == rs_EX1)) begin
            if (Writeback_Control_EX2 == WB_LUI)
                Forward1 = FRW1_LUI_EX2;
            else if (Writeback_Control_EX2 == WB_HI)
                Forward1 = FRW1_HI_EX2;
            else if (Writeback_Control_EX2 == WB_LO)
                Forward1 = FRW1_LO_EX2;
            else
                Forward1 = FRW1_ALU_EX2;
        end

        if ((data_in_address_EX2 == rt_EX1) && ((ALUSrc_EX1 == 0) || (Memory1_Write_EX1 == 1)))begin
            if (Writeback_Control_EX2 == WB_LUI)
                Forward2 = FRW2_LUI_EX2;
            else if (Writeback_Control_EX2 == WB_HI)
                Forward2 = FRW2_HI_EX2;
            else if (Writeback_Control_EX2 == WB_LO)
                Forward2 = FRW2_LO_EX2;
            else
                Forward2 = FRW2_ALU_EX2;
        end
    end

    if ((Register1_Write_ME == 1) && (data_in_address_ME != 0)) begin
        if ((data_in_address_ME == rs_EX1) &&  (Forward1 == FRW1_NONE)) begin
            if ((Writeback_Control_ME == WB_HI))
                Forward1 = FRW1_HI_ME;
            else if ((Writeback_Control_ME == WB_LO))
                Forward1 = FRW1_LO_ME;
            else if (Writeback_Control_ME == WB_LUI)
                Forward1 = FRW1_LUI_ME;
            else
                Forward1 = FRW1_ALU_ME;
        end

        if ((data_in_address_ME == rt_EX1) && ((ALUSrc_EX1 == 0) || (Memory1_Write_EX1 == 1)) && (Forward2 == FRW2_NONE))begin
            if ((Writeback_Control_ME == WB_HI))
                Forward2 = FRW2_HI_ME;
            else if ((Writeback_Control_ME == WB_LO))
                Forward2 = FRW2_LO_ME;
            else if (Writeback_Control_ME == WB_LUI)
                Forward2 = FRW2_LUI_ME;
            else
                Forward2 = FRW2_ALU_ME;
        end
    end

    if ((Register1_Write_WB == 1) && (data_in_address_WB != 0)) begin
        if ((Forward1 == FRW1_NONE) && (data_in_address_WB == rs_EX1)) begin
            if ((Writeback_Control_WB == WB_HI))
                Forward1 = FRW1_HI_WB;
            else if ((Writeback_Control_WB == WB_LO))
                Forward1 = FRW1_LO_WB;
            else if (Writeback_Control_WB == WB_LUI)
                Forward1 = FRW1_LUI_WB;
            else if (Writeback_Control_WB == WB_LW)
                Forward1 = FRW1_LOAD_WB;
            else
                Forward1 = FRW1_ALU_WB;
        end

        if ((Forward2 == FRW2_NONE) && (data_in_address_WB == rt_EX1) && ((ALUSrc_EX1 == 0) || (Memory1_Write_EX1 == 1))) begin
            if ((Writeback_Control_WB == WB_HI))
                Forward2 = FRW2_HI_WB;
            else if ((Writeback_Control_WB == WB_LO))
                Forward2 = FRW2_LO_WB;
            else if (Writeback_Control_WB == WB_LUI)
                Forward2 = FRW2_LUI_WB;
            else if (Writeback_Control_WB == WB_LW)
                Forward2 = FRW2_LOAD_WB;
            else
                Forward2 = FRW2_ALU_WB;
        end
    end
    end


endmodule