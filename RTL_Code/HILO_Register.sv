import MIPS_Definitions::*;
/*
This register stored the results of multiplication and division before it is stored into the main register.
*/
module HILO_Register (
    input logic clk,
    input logic reset,
    input logic HILO_Register_Enable_ME,
    input logic Multicycle_HILO_Register_Enable_ME,
    input logic [31:0] HI_send_ME,
    input logic [31:0] LO_send_ME,
    output logic [31:0] HI_result_ME,
    output logic [31:0] LO_result_ME
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            HI_result_ME <= 32'b0;
            LO_result_ME <= 32'b0;
        end
        else if (HILO_Register_Enable_ME || Multicycle_HILO_Register_Enable_ME) begin
            HI_result_ME <= HI_send_ME;
            LO_result_ME <= LO_send_ME;
        end 
    end
endmodule
