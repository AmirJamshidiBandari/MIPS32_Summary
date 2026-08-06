module MIPS_Tb;

logic clk;
logic reset;
integer i;
integer register_results_file;
integer memory_results_file;
integer io1_results_file;
integer io2_results_file;


MIPS CPU (
    .clk(clk),
    .reset(reset)
);

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, MIPS_Tb);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end 

initial  begin
    reset = 1;
    #10;
    reset = 0;  
end

initial begin
    // wait long enough for program to complete
    #3000;

    $display("----------------REGISTER VALUES----------------\n");
    for (i = 0; i < 32; i = i + 1) begin
        $display("Register[%0d] = %0d", i, CPU.reg1_file.register1[i]);      
    end
    $display("-----------------MEMORY VALUES-----------------\n");
    for (i = 0; i < 32; i = i + 1) begin
        $display("Memory[%0d] = %0d", i, CPU.mem_data.ram_1[i]);      
    end
    $display("------------------IO1 VALUES-------------------\n");
    for (i = 0; i < 32; i = i + 1) begin
        $display("IO1[%0d] = %0d", i, CPU.mem_data.io_1[i]);      
    end
    $display("------------------IO2 VALUES-------------------\n");
    for (i = 0; i < 32; i = i + 1) begin
        $display("IO2[%0d] = %0d", i, CPU.mem_data.io_2[i]);      
    end
    $display("");


    // Registers
    register_results_file = $fopen("/mnt/c/Users/YourPC/python/final_register_results_rtl.txt","w");
    if (register_results_file == 0) begin
        $display("ERROR: Could not open final_results_rtl.txt");
        $finish;
    end
    for (i = 0; i < 32; i = i + 1) begin
        $fdisplay(register_results_file, "Register[%0d] = %0d",i,CPU.reg1_file.register1[i]);
    end
    $fclose(register_results_file);

    // Memory
    memory_results_file = $fopen("/mnt/c/Users/YourPC/python/final_memory_results_rtl.txt","w");
    if (memory_results_file == 0) begin
        $display("ERROR: Could not open final_memory_results_rtl.txt");
        $finish;
    end
    for (i = 0; i < 32; i = i + 1) begin
        $fdisplay(memory_results_file,"Memory[%0d] = %0d",i,CPU.mem_data.ram_1[i]);
    end
    $fclose(memory_results_file);

    // IO1
    io1_results_file = $fopen("/mnt/c/Users/YourPC/python/final_io1_results_rtl.txt","w");
    if (io1_results_file == 0) begin
        $display("ERROR: Could not open final_io1_results_rtl.txt");
        $finish;
    end
    for (i = 0; i < 32; i = i + 1) begin
        $fdisplay(io1_results_file,"IO1[%0d] = %0d",i,CPU.mem_data.io_1[i]);
    end
    $fclose(io1_results_file);

    // IO2
    io2_results_file = $fopen("/mnt/c/Users/YourPC/python/final_io2_results_rtl.txt","w");
    if (io2_results_file == 0) begin
        $display("ERROR: Could not open final_io2_results_rtl.txt");
        $finish;
    end
    for (i = 0; i < 32; i = i + 1) begin
        $fdisplay(io2_results_file,"IO2[%0d] = %0d",i,CPU.mem_data.io_2[i]);
    end
    $fclose(io2_results_file);

    $display("RTL results saved.");

    $finish;

end

endmodule
