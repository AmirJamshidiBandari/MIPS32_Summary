import MIPS_Definitions::*;
module Multiplier (
    input logic clk,
    input logic reset,
    input logic [31:0] data_out_1_EX_mux_EX2,
    input logic [31:0] data_out_2_EX_mux_EX2,
    input logic Multiply,
    input alu_ctrl_t ALU_Control_EX2,
    output logic [31:0] mult_HI_EX2,
    output logic [31:0] mult_LO_EX2,
    output logic [5:0] cycle_mult
);



logic signed [63:0] mult_result; 
logic [63:0] mult_resultu;
logic [63:0] mult_operand_1; 
logic [63:0] mult_operand_2;


// Execution logic of the multiplier.
always_ff @(posedge clk or posedge reset) begin
    // Default values during reset.
    if (reset) begin
        mult_result <= 64'b0;
        cycle_mult <= 0;
        mult_operand_1 <= 0;
        mult_operand_2 <= 0;
    end

    // When control logic sends signal, begin multiplication.
    else if (Multiply) begin
        // Handle back to back MULT without MFHI/MFLO in between.
        if (ALU_Control_EX2 == ALU_MULT)begin
            mult_result <= 64'b0;
            mult_operand_1 <= data_out_1_EX_mux_EX2;
            mult_operand_2 <= data_out_2_EX_mux_EX2;
            cycle_mult <= 1;
        end
        // At cycle 0, pipeline inputs are copied to safe multiplier registers, and the 32 cycles begin. 
        else if (cycle_mult == 0) begin
            mult_result <= 64'b0;
            mult_operand_1 <= data_out_1_EX_mux_EX2;
            mult_operand_2 <= data_out_2_EX_mux_EX2;
            cycle_mult <= 1;
        end

        // The multiplication process, which includes shifting both operand bits and adding the operand with its previous cycle result
        //     only if second operand has the lowest bit equal to 1 (HIGH).
        else begin
            if (mult_operand_2[0]) begin
                mult_result <= mult_result + {{32{mult_operand_1[31]}}, mult_operand_1};
            end
            mult_operand_1 <= mult_operand_1 << 1;
            mult_operand_2 <= mult_operand_2 >> 1;
            cycle_mult <= cycle_mult + 1;
        end
    end
    
    // When control logic doesn't send any multiplication signal, set cycle to its default value.
    else begin
        mult_result <= 64'b0;
        cycle_mult <= 0;
        mult_operand_1 <= 0;
        mult_operand_2 <= 0;
    end
end

// Output logic of multiplier.
assign mult_HI_EX2 = (cycle_mult == 6'd32) ? mult_result[63:32] : 32'b0;
assign mult_LO_EX2 = (cycle_mult == 6'd32) ? mult_result[31:0] : 32'b0;

endmodule
