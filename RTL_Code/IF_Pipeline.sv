/*
This is the first pipeline register
*/
module IF_Pipeline (
    input logic clk,
    input logic reset,
    input logic [31:0] instruction_IF,
    input logic [31:0] pc_adder_value,
    input logic Stall_IF,
    input logic Flush_ID,
    output logic [31:0] instruction_ID,
    output logic [31:0] pc_adder_value_ID
);
    always_ff @(posedge clk or posedge reset) begin        
        if (reset) begin
            instruction_ID <= 32'b0;
        end
        else if (Flush_ID) begin // Flush this stage.
            instruction_ID <= 0;
            pc_adder_value_ID <= 0;
        end
        else if (!Stall_IF)begin // Stall this stage if Stall_IF is true.
            instruction_ID <= instruction_IF;
            pc_adder_value_ID <= pc_adder_value;
        end
    end
endmodule
