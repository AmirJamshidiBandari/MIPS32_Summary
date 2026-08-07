/*
The memory control unit picks which memory to write to based on third hexadecimal value of ALU result.
*/
module Memory_Control_Unit (
    input logic [31:0] ALU_result_ME,
    output logic RAM_Write_ME,
    output logic IO1_Write_ME,
    output logic IO2_Write_ME
);
    logic [3:0] address_select;
    assign address_select = (ALU_result_ME[11:8]);
    always_comb begin
        RAM_Write_ME = 0;
        IO1_Write_ME = 0;
        IO2_Write_ME = 0;
        case (address_select)
            4'h0:begin
                RAM_Write_ME = 1;
            end
            4'h1:begin
                IO1_Write_ME = 1;
            end
            4'h2:begin
                IO2_Write_ME = 1;
            end 
        endcase
    end
endmodule
