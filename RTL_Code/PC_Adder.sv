module PC_Adder (
    input logic [31:0] pc,
    output logic [31:0] pc_adder_value
);
assign pc_adder_value = pc + 4; // Create the next program counter address.

endmodule
