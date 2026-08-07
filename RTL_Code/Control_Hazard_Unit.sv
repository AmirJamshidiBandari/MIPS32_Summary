/*
A taken branch or jump resolved in EX1 makes the younger instructions currently in IF and ID wrong-path instructions.
These instructions are flushed before they can modify architectural state.
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
        if ((Branch_EX1 && Zero_Flag_EX1) || Jump_EX1) begin // Flush wrong-path instructions.
            Flush_Branch = 1;
            Flush_ID = 1;
        end
    end
endmodule
