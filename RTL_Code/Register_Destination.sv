/*
Register destination can either come from a rt value or rd value, this depends on instruction type. 
Therefore, a multiplexer and control unit signal is used to pick correct register address.
*/
module Register_Destination (
    input logic Register1_Destination_EX1,
    input logic [4:0] rd_EX1,
    input logic [4:0] rt_EX1,
    output logic [4:0] data_in_address_EX1
);
    always_comb begin
    if (Register1_Destination_EX1)
        data_in_address_EX1 = rd_EX1;
    else
        data_in_address_EX1 = rt_EX1;
    end
endmodule
