/*
This is next program counter multiplexer, it either picks between jump target, branch target, or normal incremented program counter, the output address is used by the program counter register.
*/
module PC_Writeback (
    input logic Jump_EX1,
    input logic Branch_EX1,
    input logic Zero_Flag_EX1,
    input logic [31:0] jump_value_EX1,
    input logic [31:0] branch_adder_value_EX1,
    input logic [31:0] pc_adder_value,
    output logic [31:0] next_pc

);
always_comb 
begin
    next_pc = pc_adder_value;
    if (Jump_EX1)
        next_pc = jump_value_EX1;
    else if (Zero_Flag_EX1 && Branch_EX1)
        next_pc = branch_adder_value_EX1;
    else next_pc = pc_adder_value;
end
endmodule
