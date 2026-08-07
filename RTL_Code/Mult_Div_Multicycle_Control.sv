/*
Since multiplier and divider are multicycle, this modules handles when the processor should be stalled, when mult or div should begin operation, when mult or div should end operation and send signals to HILO register and multiplexer.
*/
module Mult_Div_Multicycle_Control (
    input logic [6:0] cycle_div,
    input logic [5:0] cycle_mult,
    input alu_ctrl_t ALU_Control_EX2,
    input writeback_t Writeback_Control_ID,
    output logic Multicycle_HILO_Register_Enable_EX2,
    output logic stall_mult,
    output logic stall_div,
    output logic Multiply,
    output logic Divide,
    output HILO_select_t Multicycle_HILO_Select_EX2

);
    
// Control logic of the multiplier and divider.
always_comb begin
    // Default values.
    Multiply = 0;
    Divide = 0;
    stall_mult = 0;
    stall_div = 0;
    Multicycle_HILO_Register_Enable_EX2 = 0;
    Multicycle_HILO_Select_EX2 = HILO_NONE;
    
    // Begin multicycle operation and keep it going.
    if ((ALU_Control_EX2 == ALU_MULT) || (cycle_mult > 0 && cycle_mult < 6'd32)) begin
        Multiply = 1;
    end
    if ((ALU_Control_EX2 == ALU_DIV) || (cycle_div > 0 && cycle_div < 6'd33)) begin
        Divide = 1;
    end
    
    // Stall the processor if multicycle operation is running and there is a dependent instruction.
    if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) && (cycle_mult < 6'd32) && Multiply) begin
        stall_mult = 1;
    end
    if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) &&  (cycle_div < 6'd33) && Divide) begin
        stall_div = 1;
    end

    // End multicycle operation and send signals to HILO modules.
    if (cycle_mult == 6'd32) begin
        Multiply = 0;
        Multicycle_HILO_Register_Enable_EX2 = 1;
        Multicycle_HILO_Select_EX2 = HILO_MULT;
    end
    if (cycle_div == 6'd33) begin
        Divide = 0;
        Multicycle_HILO_Register_Enable_EX2 = 1;
        Multicycle_HILO_Select_EX2 = HILO_DIV;
    end
end

endmodule
