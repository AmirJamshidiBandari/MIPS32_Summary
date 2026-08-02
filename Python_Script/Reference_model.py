from PC_register import pc_register, pc_adder, pc_writeback
from Instruction_memory import load_instruction_memory
from Decoder import decoder_call
from Execute import execute
from Data_memory import memory_write, memory_read, reset_mem
from Control_unit import control_unit
from Register_writeback import reg_writeback
from Branch_adder import branch_adder
from Jump_con import jump_con
from HILO_register import hilo_register, reset_hilo
from Register import register, register_write, display_register_value, reset_reg

"""
    This is the top function that connects all parts of the processor together, it is step by step, starting from instruction fetch stage and ending with writeback stage,
the instruction generator sends a list of instructions to run_cpu, this function will continue to work based on number of instructions in the list.
"""
def run_cpu(instruction_memory):
    pc = 0
    nextpc = 0
    cycle = 0
    reset = 1
    reset_hilo(reset), reset_mem(reset), reset_reg(reset)
    
    while (0  <= pc < len(instruction_memory) * 4) and (cycle < 100):
        reset = 0
        pc_address = pc_register(nextpc)                                                                                                        # IF (Instruction Fetch Stage)
        nextpc_adder = pc_adder(pc_address)
        instruction_index = pc_address >> 2
        current_instruction = instruction_memory[instruction_index]

        decoded_instruction_main = decoder_call(current_instruction)                                                                            # ID (Instruction Decoder Stage)
        control_signals = control_unit(decoded_instruction_main)
        reg_operand_1_main, reg_operand_2_main = register(decoded_instruction_main)

        result_main = execute(reg_operand_1_main, reg_operand_2_main, decoded_instruction_main)                                                 # EX (Execute Stage)
        HI_result, LO_result = hilo_register(result_main, control_signals)
        branch_result, zero_flag = branch_adder(reg_operand_1_main, reg_operand_2_main, nextpc_adder, result_main, control_signals)
        jump_result = jump_con(nextpc_adder, result_main, control_signals)

        memory_write(result_main, reg_operand_2_main, control_signals)                                                                          # ME (Memory Stage)
        (memory_result, memory_file, io1_file, io2_file) = memory_read(result_main, decoded_instruction_main)

        register_writeback = reg_writeback(memory_result, result_main, decoded_instruction_main, HI_result, LO_result)                          # WB (Writeback Stage)
        register_file_main = register_write(register_writeback, decoded_instruction_main, control_signals)
        nextpc = pc_writeback(nextpc_adder, branch_result, zero_flag, control_signals, jump_result)
        pc = nextpc
        cycle = cycle + 1 
        
    print("\n------------------------FINAL REGISTERS------------------------")

    for index, value in enumerate(register_file_main):
        if value != 0:
            print(f"Register[{index}] = {display_register_value(value)}")

 
    print()                                                                                                                                    
    return {                                                                                                                                    # Return register and memories to the caller
        "registers": register_file_main.copy(),
        "memory": memory_file.copy(),
        "io1": io1_file.copy(),
        "io2": io2_file.copy(),
        "hi": HI_result,
        "lo": LO_result,
        "pc": pc,
        "cycles": cycle
    }