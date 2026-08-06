module ALU_Sources(
    input logic [31:0] data_out_2_ID,
    input logic [31:0] sign_ext_imm32_ID,
    input logic [31:0] zero_ext_imm32_ID,
    input logic ImmExt_ID,
    input logic ALUSrc_ID,
    output logic [31:0] data_out_2_ALUSrc_ID
);

logic [31:0] imm_selected;

assign imm_selected = ImmExt_ID ? sign_ext_imm32_ID : zero_ext_imm32_ID;
assign data_out_2_ALUSrc_ID = ALUSrc_ID ? imm_selected : data_out_2_ID;

endmodule