register_file = [0] * 32

"""
    Set the registers to zero during reset.
"""
def reset_reg(reset):
    if reset:
        register_file = 0


"""
    Display the signed and unsigned values of a register.
"""
def display_register_value(value):
    value &= 0xFFFFFFFF

    if value & 0x80000000:
        signed_value = value - 0x100000000
        return f"0x{value:08X} (signed: {signed_value}, unsigned: {value})"

    return f"0x{value:08X} ({value})"


"""
    Pick the two register operands based on the rt and rs address.
"""
def register(decoded_instruction_main):
    rt = decoded_instruction_main["rt"]                                                             # Read the operand address from decoder.
    rs = decoded_instruction_main["rs"]

    reg_operand_1 = register_file[rs]                                                               # Select operand based on the address.
    reg_operand_2 = register_file[rt]

    print("-------------REGISTER READ------------")
    print(f"Operand 1 = {display_register_value(reg_operand_1)}")
    print(f"Operand 2 = {display_register_value(reg_operand_2)}")
    print()

    return reg_operand_1, reg_operand_2

"""
    Get the register writeback result and control unit signal, if signal is HIGH, store the value into the register destination.
"""
def register_write(writeback_result, decoded_instruction_main, control_signals):
    rd = decoded_instruction_main["rd"]                                                                     # Read the decoder values.
    rt = decoded_instruction_main["rt"]
    opcode = decoded_instruction_main["opcode"]
    register_write_signal = control_signals["register_write"]

    if opcode == 0:                                                                                         # This is a register destination picker, it's based on instruction type.
        destination_register = rd
    else:
        destination_register = rt

    if register_write_signal:                                                                               # Read the signal from control unit.
        if destination_register != 0:
            writeback_result &= 0xFFFFFFFF
            register_file[destination_register] = writeback_result                                          # Store the value into picked register destination.

            print("------------REGISTER WRITE------------")
            print(f"Register[{destination_register}] = {display_register_value(writeback_result)}")
            print()

        else:
            print("Write to Register[0] ignored.")

    return register_file