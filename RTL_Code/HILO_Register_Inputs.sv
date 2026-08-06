module HILO_Register_Inputs(
    input logic [31:0] div_LO_EX2,
    input logic [31:0] div_HI_EX2,
    input logic [31:0] mult_LO_EX2,
    input logic [31:0] mult_HI_EX2,
    input HILO_select_t Multicycle_HILO_Select_EX2,
    output logic [31:0] HI_send_EX2,
    output logic [31:0] LO_send_EX2
);

always_comb begin
    HI_send_EX2 = 32'b0;
    LO_send_EX2 = 32'b0;
    case (Multicycle_HILO_Select_EX2)
        HILO_DIV: begin
            LO_send_EX2 = div_LO_EX2;
            HI_send_EX2 = div_HI_EX2;
        end
        HILO_MULT: begin
            LO_send_EX2 = mult_LO_EX2;
            HI_send_EX2 = mult_HI_EX2;
        end
    endcase
end

endmodule