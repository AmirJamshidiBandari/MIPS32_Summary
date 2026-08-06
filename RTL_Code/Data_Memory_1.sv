module Data_Memory_1 (
    input logic clk,
    input logic reset,
    input logic Memory1_Write_ME,
    input logic [31:0] store_word_ME,
    input logic [31:0] ALU_result_ME,
    input logic RAM_Write_ME,
    input logic IO1_Write_ME,
    input logic IO2_Write_ME,
    output logic [31:0] load_word_ME
);
    logic [31:0] ram_1 [31:0];
    logic [31:0] io_1 [31:0];
    logic [31:0] io_2 [31:0];
    logic [4:0] output_select;
    logic [3:0] signal_select;
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                ram_1[i] <= 32'b0;
                io_1[i]  <= 32'b0;
                io_2[i]  <= 32'b0;
            end
        end
        if ((Memory1_Write_ME == 1) && (RAM_Write_ME == 1))
            ram_1[ALU_result_ME[6:2]] <= store_word_ME;

        if ((Memory1_Write_ME == 1) && (IO1_Write_ME == 1))
            io_1[ALU_result_ME[6:2]] <= store_word_ME;

        if ((Memory1_Write_ME == 1) && (IO2_Write_ME == 1))
            io_2[ALU_result_ME[6:2]] <= store_word_ME;

    end
    assign output_select = (ALU_result_ME[6:2]);
    assign signal_select = (ALU_result_ME[11:8]);

    always_comb begin
        case (signal_select)
            4'h0: load_word_ME = ram_1[output_select];
            4'h1: load_word_ME = io_1[output_select];
            4'h2: load_word_ME = io_2[output_select];
            default: load_word_ME = 32'b0;
        endcase
    end   

endmodule