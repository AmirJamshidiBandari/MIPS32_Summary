module PC_Register (
    input logic reset,
    input logic clk,
    input logic [31:0] next_pc,
    input logic Stall_PC,
    output logic [31:0] pc
);

always_ff @(posedge clk or posedge reset) 
begin
    if (reset)
    pc <= 0;
    else if (!Stall_PC) // If Stalling processor is false, store the next program counter value into the program counter register.
    pc <= next_pc;
end


endmodule
