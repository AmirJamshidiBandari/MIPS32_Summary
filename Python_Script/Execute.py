"""
    The two functions below take a unsigned value and turn it into a signed value, this is needed since the multiplier and divider in the MIPS work with signed values. 
"""
def to_signed64(value):
    value &= 0xFFFFFFFFFFFFFFFF

    if value & 0x8000000000000000:
        return value - 0x10000000000000000

    return value

def to_signed32(value):
    value &= 0xFFFFFFFF

    if value & 0x80000000:
        return value - 0x100000000

    return value


"""
    The execute (ALU) function takes two register operands, reads the operation set from instruction decoder, and does operation on those operands.
"""
def execute(operand_1, operand_2, decoded_instruction_main):
    print("---------------EXECUTER---------------")
    operation = decoded_instruction_main["name"]                                        # Read the operation.
    match (operation):                                                                  # Execute based on operation and register operands.
        case "add":
            result = operand_1 + operand_2

        case "sub":
            result = operand_1 - operand_2

        case "and":
            result = operand_1 & operand_2

        case "or":
            result = operand_1 | operand_2

        case "xor":
            result = operand_1 ^ operand_2

        case "nor":
            result = ~(operand_1 | operand_2) & 0xFFFFFFFF

        case "div":
            dividend = to_signed32(operand_1)                                            # Turn unsigned operands into signed operands.
            divisor = to_signed32(operand_2)

            if divisor == 0:
                raise ZeroDivisionError("MIPS division by zero")

            quotient = abs(dividend) // abs(divisor)

            if (dividend < 0) != (divisor < 0):                                          # If one operand is negative, make the quotient negative.
                quotient = -quotient

            remainder = dividend - quotient * divisor

            result = (((remainder & 0xFFFFFFFF) << 32) | (quotient & 0xFFFFFFFF))

        case "mult":
            signed_operand_1 = to_signed32(operand_1)                                   # Turn unsigned operands into signed operands.
            signed_operand_2 = to_signed32(operand_2)

            result = signed_operand_1 * signed_operand_2
            result &= 0xFFFFFFFFFFFFFFFF

        case "addi":
            imm_signed = decoded_instruction_main["signed_imm"]
            result = operand_1 + imm_signed

        case "ori":
            imm = decoded_instruction_main["imm"]
            result = operand_1 | imm

        case "lui":
            imm = decoded_instruction_main["imm"]
            result = imm << 16

        case "sw":
            imm_signed = decoded_instruction_main["signed_imm"]
            result = operand_1 + imm_signed

        case "lw":
            imm_signed = decoded_instruction_main["signed_imm"]
            result = operand_1 + imm_signed

        case "beq":
            imm_signed = decoded_instruction_main["signed_imm"]
            imm_signed = imm_signed << 2
            result = imm_signed

        case "j":
            target26 = decoded_instruction_main["target"]
            target28 = target26 << 2
            result = target28

        case "mflo":
            result = 0

        case "mfhi":
            result = 0

        case _:
            raise NotImplementedError("Error in execute operation, no operation picked.")

    if operation in ("mult", "div"): 
        result_64 = result & 0xFFFFFFFFFFFFFFFF
        print(f"Executer Result = 0x{result_64:016X} (signed: {to_signed64(result_64)}, unsigned: {result_64})\n")

    else:
        result_32 = result & 0xFFFFFFFF
        print(f"Executer Result = 0x{result_32:08X} (signed: {to_signed32(result_32)}, unsigned: {result_32})\n")

    return result