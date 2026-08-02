
"""
    This function takes two register operands, compares those values, and if those values match it will set Zero_Flag signal high,
which will tell the program counter to branch to another instruction.
"""
def branch_adder(reg_operand_1_main, reg_operand_2_main, nextpc_address, signed_imm18, control_signals):

    branch = control_signals["branch"]                                          # Read Control Unit signal.

    if (reg_operand_1_main == reg_operand_2_main):                              # Compare operands.
        Zero_flag = True
    else:
        Zero_flag = False

    branch_adder_value = nextpc_address + signed_imm18                          # Create the branch target.

    if (branch & Zero_flag):                                                    # If operands match and Branch signal is HIGH, branch to instruction.
        print(f"Branch taken address = {branch_adder_value}")
        print ("")


    return branch_adder_value, Zero_flag
