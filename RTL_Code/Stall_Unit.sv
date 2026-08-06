import MIPS_Definitions::*;
module Stall_Unit (
    input logic [4:0] rt_EX1,
    input logic [4:0] rt_EX2,
    input logic [4:0] rd_ID,
    input writeback_t Writeback_Control_ID,
    input writeback_t Writeback_Control_EX1,
    input writeback_t Writeback_Control_EX2,
    input logic [4:0] rt_ID,
    input logic [4:0] rs_ID,
    input logic stall_mult,
    input logic stall_div,
    input alu_ctrl_t ALU_Control_EX1,
    output logic Flush_Stall,
    output logic Stall_IF,
    output logic Stall_PC
);

    always_comb begin
        Flush_Stall = 0;
        Stall_IF = 0;
        Stall_PC = 0;

        if (((Writeback_Control_EX1 == WB_LW)) && (((rt_EX1 == rt_ID)) || (rt_EX1 == rs_ID)) && (rt_EX1 !=0)) begin
            Flush_Stall = 1;
            Stall_IF = 1;
            Stall_PC = 1;
        end

        if (((Writeback_Control_EX2 == WB_LW)) && (((rt_EX2 == rt_ID)) || (rt_EX2 == rs_ID)) && (rt_EX2 !=0)) begin
            Flush_Stall = 1;
            Stall_IF = 1;
            Stall_PC = 1;
        end

        if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) && (ALU_Control_EX1 == ALU_MULT) && (rd_ID !=0)) begin
            Flush_Stall = 1;
            Stall_IF = 1;
            Stall_PC = 1;
        end

        if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) && (ALU_Control_EX1 == ALU_DIV) && (rd_ID !=0)) begin
            Flush_Stall = 1;
            Stall_IF = 1;
            Stall_PC = 1;
        end

        if (stall_mult || stall_div) begin
            Flush_Stall = 1;
            Stall_IF = 1;
            Stall_PC = 1;
        end
    end
endmodule