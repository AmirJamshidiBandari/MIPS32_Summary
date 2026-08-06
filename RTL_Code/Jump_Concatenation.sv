module Jump_Concatenation (
    input logic [31:0] pc_adder_value_EX1,
    input logic Jump_EX1,
    input logic [27:0] target28_EX1,
    output logic [31:0] jump_value_EX1
); 

assign jump_value_EX1 = Jump_EX1 ? {pc_adder_value_EX1[31:28], target28_EX1} : 32'b0;

endmodule