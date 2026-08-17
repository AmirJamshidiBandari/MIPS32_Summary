"""
    This is a simplified control unit compared to the SystemVerilog version, this file takes the operation set by instruciton decoder,
and based on that instruction it will set a signal HIGH to ensure correct operations in our MIPS32 python script.
"""
def control_unit(decoded_instruction_main):
    operation = decoded_instruction_main["name"]                                # Take operation from control unit.

    memory_write = 0                                                            # Set default values.
    register_write = 0
    register_writeback = 0
    branch = 0
    jump = 0
    HILO_write = 0


    match operation:                                                            # Based on operation, set a signal HIGH.
        case "add":
            register_write = 1

        case "sub":
            register_write = 1

        case "and":
            register_write = 1

        case "or":
            register_write = 1

        case "xor":
            register_write = 1

        case "nor":
            register_write = 1

        case "div":
            HILO_write = 1

        case "mult":
            HILO_write = 1

        case "mflo":
            register_write = 1

        case "mfhi":
            register_write = 1


        case "addi":
            register_write = 1

        case "ori":
           register_write = 1

        case "lui":
            register_write = 1

        case "lw":
            register_write = 1

        case "sw":
            memory_write = 1

        case "beq":
            branch = 1

        case "j":
            jump = 1

        case _:
            memory_write = 0
            register_write = 0
            branch = 0
            jump = 0
            HILO_write = 0
            print("Error, no control unit signal picked.")

    signals = {                                                                          # Return all the signals to the caller.
        "memory_write" : memory_write,
        "register_write" : register_write,
        "branch" : branch,
        "jump" : jump,
        "HILO_write": HILO_write
    }
    return signals
