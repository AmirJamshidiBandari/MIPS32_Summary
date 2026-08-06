/*
Branch has a zero flag signal, the true or false is based on equality of the data out operands, zero flag decides if a branch should be taken or not.
The branch target found by adding next program counter address and the target branch.
*/
module Branch_Adder (
    input logic [31:0] pc_adder_value_EX1,
    input logic [31:0] branch_imm32_EX1,
    input logic [31:0] data_out_2_EX_mux_EX1,
    input logic [31:0] data_out_1_EX_mux_EX1,
    output logic Zero_Flag_EX1,
    output logic [31:0] branch_adder_value_EX1
);  
    always_comb begin
        Zero_Flag_EX1 = (data_out_2_EX_mux_EX1 == data_out_1_EX_mux_EX1);
        branch_adder_value_EX1 = pc_adder_value_EX1 + branch_imm32_EX1;
    end
endmodule
