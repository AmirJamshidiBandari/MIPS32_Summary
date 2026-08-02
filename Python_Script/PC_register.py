pc = 0

"""
    Every cycle, The pc (program counter) register stores the nextpc which points at next instruction address.
"""
def pc_register(nextpc):
    global pc
    pc = nextpc
    pc = pc & 0xFFFFFFFF
    print("0-0-0------------PC--------------0-0-0")
    print(f"PC = {pc}")

    return pc

nextpc = 0

"""
    Prepare the nextpc value with incrementing nextpc by 4 since it uses byte addressing.
"""
def pc_adder(pc):
    global nextpc
    nextpc = pc + 4
    nextpc = nextpc & 0xFFFFFFFF
    return nextpc

"""
    This is the program counter multiplexer, it picks between a branch target, jump target, or a nextpc target depending on the instruction.
"""
def pc_writeback(nextpc_address, branch_result, zero_flag, control_signals, jump_result):
    branch = control_signals["branch"]
    jump = control_signals["jump"]
    if (zero_flag & branch):
        nextpc = branch_result
        nextpc = nextpc & 0xFFFFFFFF
    elif jump:
        nextpc = jump_result
        nextpc = nextpc & 0xFFFFFFFF
    else:
        nextpc = nextpc_address
        nextpc = nextpc & 0xFFFFFFFF

    return nextpc
