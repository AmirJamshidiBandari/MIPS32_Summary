module FPGA_Check(
    input logic [15:0] switch,
    input logic [31:0] Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7, Reg8, Reg9, Reg10, Reg11, Reg12, Reg13, Reg14, Reg15, Reg16, Reg17, Reg18, Reg19, Reg20, Reg21, Reg22, Reg23, Reg24, Reg25, Reg26, Reg27, Reg28, Reg29, Reg30, Reg31,
    output logic [15:0] led
);

assign led[0] = (Reg18 == 32'h1DF4D840) && switch[0];   // FINAL RESULT
assign led[1] = (Reg1  == 32'd5) && switch[1];          // addi
assign led[2] = (Reg2  == 32'd7) && switch[2];          // addi
assign led[3] = (Reg4  == 32'h12345678) && switch[3];   // lui/ori
assign led[4] = (Reg5  == 32'd12) && switch[4];         // ALU
assign led[5] = (Reg6  == 32'd21) && switch[5];         // forwarding
assign led[6] = (Reg7  == 32'd28) && switch[6];         // forwarding chain
assign led[7] = (Reg8  == 32'd28) && switch[7];         // branch not taken
assign led[8] = (Reg9  == 32'd40) && switch[8];         // control hazard
assign led[9] = (Reg10 == 32'd40) && switch[9];         // load-use
assign led[10] = (Reg11 == 32'd5) && switch[10];         // LO (quotient)
assign led[11] = (Reg12 == 32'd5) && switch[11];         // HI (remainder)
assign led[12] = (Reg14 == 32'd12) && switch[12];        // memory + ALU
assign led[13] = (Reg15 == 32'd21) && switch[13];        // dependency chain
assign led[14] = (Reg16 == 32'h1DF4D840) && switch[14];  // mult LO
assign led[15] = (Reg17 == 32'h014B66DC) && switch[15];  // mult HI

endmodule