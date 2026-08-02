memory = [0]*32                                                                # Create and set all memories to zero.
io1 = [0]*32
io2 = [0]*32

def reset_mem(reset):                                                          # During reset, set all memorie lists to zero.
    if reset:
        memory[:] = [0] * 32
        io1[:] = [0] * 32
        io2[:] = [0] * 32


"""
    The memory control unit is in charge of picking the correct memory to write into or read from, we have three different memories,
ram, IO1, and IO2. This unit looks at the third hexadecimal value of the ALU result and picks a signal to pick a memory,
"""
def memory_control_unit(execute_result):
    address_select = (execute_result >> 8) & 0xF                                    # Shift the third hexadecimal value to the lowest.

    match address_select:                                                           # Based on the value, pick a signal.
        case 0x0:                                                               
            return "RAM"

        case 0x1:
            return "IO1"

        case 0x2:
            return "IO2"

        case _:
            return None


"""
    Take the ALU result to write into a address in a memory, the second register operand is the value being stored, and control unit signal,
makes sure the operation is a sw(stone into memory) instruction. 
"""
def memory_write(execute_result, reg_operand_2, control_signals):
    memory_write_enabled = control_signals["memory_write"]                                   # Read control unit signal.

    if not memory_write_enabled:                                                            
        return

    execute_address = (execute_result >> 2) & 0x1F                                           # The memories are word based, address must shift
                                                                                             # to change from byte addressing to word addressing
    
    selected_memory = memory_control_unit(execute_result)                                    # Call the function, and receive which memory should write into

    match selected_memory:                                                                   # Write the second regiter operand into selected memory and location
        case "RAM":
            print("---------------RAM WRITE--------------")
            memory[execute_address] = reg_operand_2
            print(f"Memory[{execute_address}] = {memory[execute_address]}")

        case "IO1":
            print("---------------IO1 WRITE--------------")
            io1[execute_address] = reg_operand_2
            print(f"IO1[{execute_address}] = {io1[execute_address]}")

        case "IO2":
            print("---------------IO2 WRITE--------------")
            io2[execute_address] = reg_operand_2
            print(f"IO2[{execute_address}] = {io2[execute_address]}")

        case None:
            print(f"Memory write ignored: unmapped address 0x{execute_result:08X}")


"""
    This function behaves the same as memory write, it reads a memory location using word addressing and control unit signal,
then outputs that value if the operation is lw(load from memory).
"""
def memory_read(execute_result, decoded_instruction_main):
    operation = decoded_instruction_main["name"]

    if operation != "lw":
        return 0, memory, io1, io2

    execute_address = (execute_result >> 2) & 0x1F
    selected_memory = memory_control_unit(execute_result)

    match selected_memory:
        case "RAM":
            print("---------------RAM READ---------------")
            memory_output = memory[execute_address]
            print(f"Memory_output[{execute_address}] = {memory_output}")

        case "IO1":
            print("---------------IO1 READ---------------")
            memory_output = io1[execute_address]
            print(f"IO1_output[{execute_address}] = {memory_output}")

        case "IO2":
            print("---------------IO2 READ---------------")
            memory_output = io2[execute_address]
            print(f"IO2_output[{execute_address}] = {memory_output}")

        case None:
            print(f"Memory read from unmapped address 0x{execute_result:08X}")
            memory_output = 0

    return memory_output, memory, io1, io2