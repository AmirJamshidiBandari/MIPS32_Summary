import MIPS_Definitions::*;

module Divider (
input logic reset,
input logic clk,
input logic [31:0] data_out_1_EX_mux_EX2,
input logic [31:0] data_out_2_EX_mux_EX2,
input alu_ctrl_t ALU_Control_EX2,
input logic Divide,
output logic [31:0] div_HI_EX2,
output logic [31:0] div_LO_EX2,
output logic [6:0] cycle_div
);


logic [31:0] div_operand_1;
logic [31:0] div_operand_2;
logic [31:0] remainder;
logic [31:0] shifted_remainder;
logic [31:0] shifted_div_operand_1;
logic signed [31:0] result;
logic [31:0] next_remainder;
logic [31:0] next_div_operand_1;

// Shift remainder and dividend left by 1 bit.
assign shifted_remainder = {remainder[30:0], div_operand_1[31]};
assign shifted_div_operand_1 = {div_operand_1[30:0], 1'b0};

always_comb begin

// Subtract remainder and divisor.
result = $signed(shifted_remainder) - $signed(div_operand_2);

// Default values for next cycle.
next_remainder = shifted_remainder;
next_div_operand_1 = shifted_div_operand_1;

// If the result of subtraction is negative, set the dividend bit index zero equal to 0.
if (result < 0) begin
    next_div_operand_1[0] = 1'b0;
end

// If the result of subtraction is non-negative, set the dividend bit index zero equal to 1 and set remainder equal to subtraction result.
else begin
    next_div_operand_1[0] = 1'b1;
    next_remainder = result;
end 
end


always_ff @(posedge clk or posedge reset) begin

// Reset.
if (reset) begin
    cycle_div <= 0;
    div_operand_1 <= 0;
    div_operand_2 <= 0;
    remainder <= 0;
end

else if (Divide) begin

    // Start division.
    // If control unit signal is divison and division cycle is zero, copy multiplexer values into a safe register.
    if (ALU_Control_EX2 == ALU_DIV && cycle_div == 0) begin

        div_operand_1 <= data_out_1_EX_mux_EX2;
        div_operand_2 <= data_out_2_EX_mux_EX2;
        remainder <= 0;
        cycle_div <= 1;
    end

    // Division iterations
    else if (cycle_div < 6'd33) begin

        // For 32 cycles, copy the operation results into safe registers.
        div_operand_1 <= next_div_operand_1;
        remainder <= next_remainder;
        cycle_div <= cycle_div + 1;
    end
end

// Reset if there is no division signal.
else begin
    cycle_div <= 0;
    div_operand_1 <= 0;
    div_operand_2 <= 0;
    remainder <= 0;
end

end

// Output the remainder and quotient results.
assign div_HI_EX2 = (cycle_div == 6'd33) ? remainder : 32'b0;
assign div_LO_EX2 = (cycle_div == 6'd33) ? div_operand_1 : 32'b0;

endmodule
