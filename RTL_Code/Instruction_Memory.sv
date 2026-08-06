module Instruction_Memory (
    input logic [31:0] pc,
    output logic [31:0] instruction_IF
);
integer i;
logic [31:0] memory [31:0];
initial begin
    $readmemh("/mnt/c/Users/YourPC/python/Instructions.mem", memory);
    $display("----------------INSTRUCTION MEMORY----------------\n");
    for (i = 0; i < 32; i = i + 1) begin
        $display("Instruction %0d = %08H", i, memory[i]);
    end
    $display("");
end


assign instruction_IF = memory[pc[31:2]];

endmodule
