module Register_1 (
    input logic clk,
    input logic reset,
    input logic Register1_Write_WB,
    input logic [31:0] data_in_WB,
    input logic [4:0] data_in_address_WB,
    input logic [4:0] rs_ID,
    input logic [4:0] rt_ID,
    input logic [31:0] load_word_WB,
    input logic [31:0] ALU_result_WB,
    output logic [31:0] data_out_1_ID,
    output logic [31:0] data_out_2_ID,
    output logic [31:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31


);
    logic [31:0] register1 [31:0];
    integer i;
    
    always_ff @(posedge clk or posedge reset) 
    begin
        if (reset) begin
            for (i = 0; i < 32 ;i = i + 1 ) begin
                register1[i] <= 32'b0;
            end
        end
        else if ((Register1_Write_WB) && (data_in_address_WB != 0)) begin
            register1[data_in_address_WB] <= data_in_WB; 
        end
    end

always_comb begin
    if ((Register1_Write_WB) && (data_in_address_WB != 0) && (data_in_address_WB == rs_ID))
        data_out_1_ID = data_in_WB;
    else
        data_out_1_ID = register1[rs_ID];

    if ((Register1_Write_WB) && (data_in_address_WB != 0) && (data_in_address_WB == rt_ID))
        data_out_2_ID = data_in_WB;
    else
        data_out_2_ID = register1[rt_ID];
end

always_comb begin
    Reg0 = register1[0];
    Reg1 = register1[1];
    Reg2 = register1[2];
    Reg3 = register1[3];
    Reg4 = register1[4];
    Reg5 = register1[5];
    Reg6 = register1[6];
    Reg7 = register1[7];
    Reg8 = register1[8];
    Reg9 = register1[9];
    Reg10 = register1[10];
    Reg11 = register1[11];
    Reg12 = register1[12];
    Reg13 = register1[13];
    Reg14 = register1[14];
    Reg15 = register1[15];
    Reg16 = register1[16];
    Reg17 = register1[17];
    Reg18 = register1[18];
    Reg19 = register1[19];
    Reg20 = register1[20];
    Reg21 = register1[21];
    Reg22 = register1[22];
    Reg23 = register1[23];
    Reg24 = register1[24];
    Reg25 = register1[25];
    Reg26 = register1[26];
    Reg27 = register1[27];
    Reg28 = register1[28];
    Reg29 = register1[29];
    Reg30 = register1[30];
    Reg31 = register1[31];
end
 
endmodule