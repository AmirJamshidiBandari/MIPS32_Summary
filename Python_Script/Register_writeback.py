"""
    This is the register file multiplexer, it picks between multiple inputs such as ALU, memory, HILO register, and it outputs one value to be stored into the register, this is based on instruction.
"""
def reg_writeback(memory_result, result_executer, decoded_instruction_main, HI_result, LO_result):
    
    picker = decoded_instruction_main["name"]                               # Read the current instruction operation.
    match picker:
        case "lw":
            writeback_result = memory_result
            writeback_result = writeback_result & 0xFFFFFFFF

        case "mflo":
            writeback_result = LO_result
            writeback_result = writeback_result & 0xFFFFFFFF

        case "mfhi":
            writeback_result = HI_result
            writeback_result = writeback_result & 0xFFFFFFFF

        case _:
            writeback_result = result_executer
            writeback_result = writeback_result & 0xFFFFFFFF


    return writeback_result
