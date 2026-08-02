"""
    The instruction decoder takes a instruction from instruction memory, it decodes the instruction into parts, and these parts are used to set signals in control unit,
pick register operands, pick register destination, and pick the operation.

rs = First source register.
rt = Second source register OR destination register.
rd = Destination register.
opcode = Operation code.
shamt = Shift amount.
funct = Function
imm = immediate
target = target

"""
def decoder_r_type(instruction):

    opcode = (instruction >> 26) & 0b111111                                  # Decode instruction 
    if opcode == 0:
        rs = (instruction >> 21) & 0b11111
        rt = (instruction >> 16) & 0b11111
        rd = (instruction >> 11) & 0b11111
        shamt = (instruction >> 6) & 0b11111
        funct = instruction & 0b111111

        print("Type = R-type")
        print(f"Instruction = {instruction:08X}")
        print(f"opcode = {opcode}")
        print(f"rs = {rs}")
        print(f"rt = {rt}")
        print(f"rd = {rd}")
        print(f"shamt = {shamt}")
        print(f"funct = {funct}")

        funct_codes = {                                        
            0x20: "add",
            0x22: "sub",
            0x24: "and",
            0x25: "or",
            0x26: "xor",
            0x27: "nor",
            0b011010 : "div",
            0b010010 : "mflo",
            0b010000 : "mfhi",
            0b011000 : "mult",
            0b011001 : "multu"
        }

        instruction_name = funct_codes.get(funct, "unknown")                  # Pick the instruction operation based on function code.    

    
        match instruction_name:
            case "add":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "sub":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "and":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "or":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "xor":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "nor":
                print(f"{instruction_name} ${rd}, ${rs}, ${rt}")

            case "div":
                print(f"{instruction_name} ${rs}, ${rt}")

            case "mflo":
                print(f"{instruction_name} ${rd}")

            case "mfhi":
                print(f"{instruction_name} ${rd}")

            case "mult":
                print(f"{instruction_name} ${rs}, ${rt}")

            case _:
                print(f"Error R type decoder.")

        print()

    else:
        print("Not R type instruction")

    decoded_r_type = {                                                         # Return the decoded values.
        "opcode": opcode,
        "name": instruction_name,
        "rs": rs,
        "rt": rt,
        "rd": rd    
        
    }

    return decoded_r_type

def decoder_i_type(instruction):

    opcode = (instruction >> 26) & 0b111111                                                       # Decode instruction 
    imm = instruction & 0b1111111111111111
    rt = (instruction >> 16) & 0b11111
    rs = (instruction >> 21) & 0b11111

    print("Type = I-type")
    print(f"instruction = {instruction:08X}")
    print(f"opcode = {opcode}")
    print(f"rs = {rs}")
    print(f"rt = {rt}")
    print(f"imm = {imm}")

    opcode_definitions = {
    0b100011 : "lw",
    0b101011 : "sw",
    0b000100 : "beq",
    0b001111 : "lui",
    0b001101 : "ori",
    0b001000 : "addi"
    }

    if imm & 0b1000000000000000:                                                                  # Set both signed and unsigned immediates
        signed_imm = imm - 65536
    else:
        signed_imm = imm

    instruction_name = opcode_definitions.get(opcode, "unknown")                                  # Pick the instruction operation based on opcode.

    match instruction_name:
        case "lw":
            print(f"{instruction_name} ${rt}, {signed_imm}(${rs})")

        case "sw":
            print(f"{instruction_name} ${rt}, {signed_imm}(${rs})")   

        case "beq":
            print(f"{instruction_name} ${rs}, ${rt}, {signed_imm}")

        case "lui":
            print(f"{instruction_name} ${rt}, {imm}")

        case "ori":
            print(f"{instruction_name} ${rt}, ${rs}, {imm}")

        case "addi":
            print(f"{instruction_name} ${rt}, ${rs}, {signed_imm}")
            
        case _:
            print(f"Error I type decoder.")

    decoded_i_type = {                                                                             # Return the decoded values.
        "opcode": opcode,
        "name" : instruction_name,
        "signed_imm" : signed_imm,
        "imm" : imm,
        "rt" : rt,
        "rs" : rs,
        "rd" : 0

    }

    print()

    return decoded_i_type

def decoder_j_type(instruction):

    opcode = (instruction >> 26) & 0b111111                                                             # Decode instruction.
    target = instruction & 0b11111111111111111111111111

    print("Type = J-type")
    print(f"Instruction = {instruction:08X}")
    print(f"opcode = {opcode}")
    print(f"target = {target}")

    opcode_definitions = {
        0b000010 : "j"
    }

    instruction_name = opcode_definitions.get(opcode, "unknown")                                        # Pick instruction operation based on opcode.

    print(f"{instruction_name} {target}")

    print()

    decoded_j_type = {                                                                                  # Return decoded values.
        "opcode" : opcode,
        "name" : instruction_name,
        "target" : target,
        "rt" : 0,
        "rs" : 0,
        "rd" : 0

    }

    return decoded_j_type

"""
    There are three instruction types, R-type, I-type, and J-type, each instruction type has its own decocder, here the correct deocder is picked based on opcode(operation code).
"""
def decoder_call(instruction):
    print("---------------DECODER----------------")
    opcode = (instruction >> 26) & 0b111111                                                     # Decode the operation code.
    if (opcode == 0):                                                                           # Call the correct decoder based on instruction type.
        decoded_instruction = decoder_r_type(instruction)
    elif (opcode == 2):
        decoded_instruction = decoder_j_type(instruction)
    else:
        decoded_instruction = decoder_i_type(instruction)

    return decoded_instruction                                                        