/*
Since instructions run in parallel, any branch or jump taken in EX1 stage will make the instructions in ID and IF stage garbage, because the next target instruction is at different address and the in-order flow begins at different address,
therefore the garbage instructions must be flushed.
*/
module Control_Hazard_Unit (
    input logic Branch_EX1,
    input logic Zero_Flag_EX1,
    input logic Jump_EX1,
    output logic Flush_Branch,
    output logic Flush_ID
);

    always_comb begin
        Flush_Branch = 0;
        Flush_ID = 0;
        if ((Branch_EX1 && Zero_Flag_EX1) || Jump_EX1) begin // Flush garbage instructions.
            Flush_Branch = 1;
            Flush_ID = 1;
        end
    end
endmodule
