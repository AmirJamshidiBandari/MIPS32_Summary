"""
    Take a signal from control unit, and prepare a jump value for program counter to jump from current instruction to the target instruction.
"""
def jump_con(nextpc_adder, result_main, control_signals):
    jump = control_signals["jump"]                                                          # Take signal from control unit
    jump_value = (nextpc_adder & 0xF0000000) | result_main                                  # Prepare jump value
    if jump:
        print(f"Jump address taken: {jump_value}")
    return jump_value