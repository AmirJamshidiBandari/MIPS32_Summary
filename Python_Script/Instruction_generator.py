import random

"""
    This function gives definition to the supported instructions and picks a random operation.
"""
def random_variables():
    supported_instructions = [
    "add",
    "sub",
    "and",
    "or",
    "xor",
    "nor",
    "mult",
    "div",
    #"mflo",
    #"mfhi",
    "addi",
    "ori",
    "lui",
    "lw",
    "sw",
    "beq",
    "j"
    ]

    instruction_info = {
        "add":  {"type": "R", "opcode": 0, "funct": 32},
        "sub":  {"type": "R", "opcode": 0, "funct": 34},
        "and":  {"type": "R", "opcode": 0, "funct": 36},
        "or":   {"type": "R", "opcode": 0, "funct": 37},
        "xor":  {"type": "R", "opcode": 0, "funct": 38},
        "nor":  {"type": "R", "opcode": 0, "funct": 39},
        "mult": {"type": "R", "opcode": 0, "funct": 24},
        "div":  {"type": "R", "opcode": 0, "funct": 26},
        #"mfhi": {"type": "R", "opcode": 0, "funct": 16},
        #"mflo": {"type": "R", "opcode": 0, "funct": 18},

        "beq":  {"type": "I", "opcode": 4},
        "addi": {"type": "I", "opcode": 8},
        "ori":  {"type": "I", "opcode": 13},
        "lui":  {"type": "I", "opcode": 15},
        "lw":   {"type": "I", "opcode": 35},
        "sw":   {"type": "I", "opcode": 43},

        "j":    {"type": "J", "opcode": 2}
    }

    operation = random.choice(supported_instructions)                                               # Pick a random operation
    selected_instruction = instruction_info[operation]
    opcode = selected_instruction["opcode"]
    instruction_type = selected_instruction["type"]
    fn = selected_instruction.get("funct", 0)

    rd = random.randint(3,31)                                                                       # Select random values
    rt = random.randint(3,31)
    rs = random.randint(1,31)
    imm = random.randint(-20,21)

    random_instruction = {
        "name": operation,
        "type": instruction_type,
        "rs": rs,
        "fn": fn,
        "rt": rt,
        "rd": rd,
        "imm": imm,
        "opcode": opcode
    }
    return random_instruction

initialized_registers = [0]
initialized_memory = []
force_store = False
skip_instruction = False
jump_skips = 0
jump_signal = False
jump_message = False
div_mult_in_jump = False
first_addi_value = None
second_addi_value = None
branch_signal = False
branch_skips = 0
branch_message = False
global_skips = 0

"""
    This is the main instruction generator, it creates random, semi-random, and forced instructions.
    After the random_variables function picks a random operation, the operation is received here, and based on the instruction type and operation, random variables are generated.
Next, the assembly language of the instruction is put together by encoding the operations and variables. Then the encoded instruction is outputted to be stored into Instruction.mem file.
Next cycle, another instruction is generated and same steps are done.


    Several operations are set to be forced:
        mflo (Move From Low) and mfhi (Move From High): These operations are forced to be generated after mult or div, but the destination register is random. There were situations with multiple mult or div happening
                                                        back to back, this overwrites the previous mult or div results in HILO register, which defeats the purpose of generating mult or div instructions, to prevent 
                                                        random overwrites, mflo and mfhi are forced to store the HILO register values into the main register file before another mult or div instruction can overwrite them.
        
        addi (add immediate): The first two instructions are forced to be addi, and the results are forced to be non-zero, this is to create a starting ground for instruction generator and make sure future instruction operands are non-zero valid values
                              to create meaningful tests for verification.


    Several operations are set to be semi-random:
        lw (Load From Memory): This instruction can only happen after a sw (store into memory) instruction to prevent reading a empty memory and generating garbage instruction, new instruction is regenerated.
        div and mult: Division and multiplication instructions can't be generated if they are being skipped by beq (branch) or j (jump) instructions, since div and mult are grouped instructions, 
                      meaning mflo and mfhi are force generated after them, if beq or j instructions skip and land between these groups, then div or mult are not generated and a new instruction must be regenerated.
                      This is to prevent creating garbage instructions that do nothing in hardware.
        
        beq (branch): This operations is set to only randomly compare between the first and second register values, this is because we know first two instructions are addi and write into register one and two, knowing this
                      is important for future instruction generation, if branch must happen, then instruction generator must know to not initialize registers based on number of skips, this prevents future instructions in picking
                      empty register operands, and making instruction generation meaningful.

    
    Instructions are also constrained, meaning they must stay within normal behavior, for example beq and j cannot skip the instruction list over the 32 index, this is because the instruction memory holds 32 instructions, and anything over isnt defined in hardware.
    Beq and j also cannot be generated if they are part of the last two instructions since the skips will be meaningless, therefore new instruction is regenerated.
    Another constrained example is instructions can only pick random operands if those operands are initialized, for example if my current example wants to read from register 5, then previous instructions must have written into register 5.
    The memory behaves the same, a lw instruction can only happen when a sw instruction stored a value into a memory location.
    If an instruction is valid and has a register/memory destination, then the location is kept in "initialized_registers" or "initialized_memory", the future instructions will pick random operands from these two lists.

"""
def instruction_generator(random_instruction, cycle, instruction_numbers, skip_instruction_main):

    global initialized_registers
    global initialized_memory
    global force_store
    global force_store_cycle
    global skip_instruction
    global jump_skips
    global jump_signal
    global jump_message
    global div_mult_in_jump
    global first_addi_value
    global second_addi_value
    global branch_signal
    global branch_skips
    global branch_message
    global global_skips


    skip_instruction = skip_instruction_main                                                                                                # Read the random variables from previous function
    operation = random_instruction["name"]
    instruction_type = random_instruction["type"]
    opcode = random_instruction["opcode"]
    rd = random_instruction["rd"]
    fn = random_instruction["fn"]
    rs = random_instruction["rs"]
    rt= random_instruction["rt"]
    imm = random_instruction["imm"]
    sa = (0 & 0b11111)


    if ((cycle == 0) or (cycle == 1)):                                                                                                     # Force the first two addi instructions to be generated
        opcode = 8
        operation = "addi"
        instruction_type = "I"
        match cycle:
            case 0:
                imm = random.choice([value for value in range(-20, 21)if value != 0])
                rs = 0
                rt = 1
                first_addi_value = rt
            case 1:
                imm = random.choice([value for value in range(-20, 21)if value != 0])
                rs = 0
                rt = 2
                second_addi_value = rt


    destination_register = None
    if (force_store == False):                                                                                                             # Make sure a instruction is non-forced
        match instruction_type:                                                                                                            # Based on operation, pick random values for the variables
            case "R":
                
                match operation:
                    case "add" | "sub" | "and" | "or" | "xor" | "nor":
                        rs = random.choice(initialized_registers)
                        rt = random.choice(initialized_registers)
                        destination_register = rd
                        assembly = f"{operation} ${rd}, ${rs}, ${rt}"

                    case "mult":
                        rs = random.choice(initialized_registers)
                        rt = random.choice(initialized_registers)
                        rd = 0
                        assembly = f"{operation} ${rs}, ${rt}"
                        if ((branch_signal or jump_signal) and (global_skips < 3)):                                                       # If remaining beq or j skips is less than 3, to prevent landing in middle of grouped instructions, skip instruction and regenerate a new one.
                            print(f"Instruction Generator: mult in cycle {cycle + 1} cant be produced since jump/branch_skips < 3, skipping instruction.")
                            opcode = 0
                            fn = 0
                            assembly = 0
                            skip_instruction = True
                            rs = 0
                            rt = 0
                            rd = 0
                            imm = 0
                        else:                                                                                                             # If beq or j skips are more than 3 or there isn't a beq/j active.  
                            force_store = True                                                                                            # Force next instructions to be MFLO and MFHI.
                            force_store_cycle = 1
                            if ((jump_signal == True) | (branch_signal == True)):
                                div_mult_in_jump = True

                    case "div":
                        rs = random.choice(initialized_registers)                                                               
                        rt = random.choice([register for register in initialized_registers if register != 0])
                        rd = 0
                        assembly = f"{operation} ${rs}, ${rt}"
                        if ((branch_signal or jump_signal) and (global_skips < 3)):                                                      # If remaining beq or j skips is less than 3, to prevent landing in middle of grouped instructions, skip instruction and regenerate a new one.
                            print(f"Instruction Generator: div in cycle {cycle + 1} cant be produced since (global_skips < 3), skipping instruction.")
                            opcode = 0
                            fn = 0
                            assembly = 0
                            skip_instruction = True
                            rs = 0
                            rt = 0
                            rd = 0
                            imm = 0
                        else:                                                                                                             # If beq or j skips are more than 3 or there isn't a beq/j active. 
                            force_store = True                                                                                            # Force next instructions to be MFLO and MFHI.
                            force_store_cycle = 1
                            if ((jump_signal == True) | (branch_signal == True)):
                                div_mult_in_jump = True
                    
                    case _:
                        raise NotImplementedError(f"Unsupported R-type instruction: {operation}, Cycle: {cycle + 1}")

                instruction = ((opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (sa << 6) | (fn & 0x3F))                           # Encode the instruction.

            case "I":

                match operation:
                    case "beq":
                        rs = random.choice([first_addi_value, second_addi_value])
                        rt = random.choice([first_addi_value, second_addi_value])
                        max_imm = instruction_numbers - cycle - 2
                        if max_imm >=1:                                                                                                   # Make sure beq isn't part of the final instructions.                                                                  

                            imm = random.randint(1, max_imm)
                            assembly = f"{operation} ${rs}, ${rt}, {imm}"
                            if (rt == rs):
                                if (branch_signal == False):    
                                    if (jump_signal == False):                                                                            # Make sure branch wont happen in a ongoing jump instruction.
                                        branch_signal = True
                                        branch_message = True
                                        branch_skips = imm
                                        print(f"Branch taken, number of instructions being skipped: {branch_skips}")
                        else:
                            print(f"Instruction Generator: Beq in cycle {cycle + 1} cant be produced, skipping instruction.")
                            opcode = 0
                            fn = 0
                            assembly = 0
                            skip_instruction = True
                            rs = 0
                            rt = 0
                            rd = 0
                            imm = 0

                    case "addi":
                        if ((cycle != 0) and (cycle != 1)):
                            rs = random.choice(initialized_registers)
                        destination_register = rt
                        assembly = f"{operation} ${rt}, ${rs}, {imm}"

                    case "ori":
                        rs = random.choice(initialized_registers)
                        imm = random.randint(0, 0xFFFF)
                        destination_register = rt
                        assembly = f"{operation} ${rt}, ${rs}, {imm}"

                    case "lui":
                        rs = 0
                        imm = random.randint(0, 0xFFFF)
                        destination_register = rt
                        assembly = f"{operation} ${rt}, {imm}"

                    case "lw":
                        rs = 0
                        if initialized_memory:                                                                                           # Make sure a SW instruction has written into the memory.
                            imm = random.choice(initialized_memory)
                            assembly = f"{operation} ${rt}, {imm}(${rs})"
                            destination_register = rt
                        else:
                            print(f"Instruction Generator: No memory address written yet in cycle {cycle + 1}, skipping lw instruction.")
                            opcode = 0
                            fn = 0
                            assembly = 0
                            rs = 0
                            rt = 0
                            rd = 0
                            imm = 0
                            skip_instruction = True

                    case "sw":                                                                                                            # The SW is memory mapped, meaning it can pick to either write in RAM, IO1, or IO2.
                        rt = random.choice([register for register in initialized_registers if register != 0])
                        imm = random.randrange(0, 128, 4)
                        rs = 0
                        mmio = random.choice([0x000, 0x100, 0x200])

                        imm = (mmio | imm)
                        
                        if ((jump_signal == False) and (branch_signal == False)):                                                         # Prevent initializing if jump or branch is ongoing.
                            if imm not in initialized_memory:
                                initialized_memory.append(imm)

                        assembly = f"{operation} ${rt}, {imm}(${rs})"

                    case _:
                        raise NotImplementedError(f"Unsupported I-type instruction: {operation}, Cycle: {cycle + 1}")
            
                instruction = ((opcode << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF))                                                 # Encode the instruction.

            case "J":
                target = imm & 0x03FFFFFF

                match operation:
                    case "j":
                        min_target = cycle + 2
                        max_target = instruction_numbers

                        if min_target <= max_target:                                                                                      # Make sure jump can happening within correct range.
                            target = random.randint(min_target, max_target)
                            assembly = f"{operation} {target}"
                            rs = 0
                            rt = 0
                            rd = 0
                            if (jump_signal == False):
                                if (branch_signal == False):                                                                              # Make sure jump doesnt happen in a ongoing branch instruction.
                                    jump_skips = target - cycle - 1
                                    jump_signal = True
                                    jump_message = True
                                    print(f"Jump taken, number of instructions being skipped: {jump_skips}")
                        else:
                            print(f"Instruction Generator: j in cycle {cycle + 1} cant be produced, skipping instruction.")
                            opcode = 0
                            fn = 0
                            assembly = 0
                            rs = 0
                            rt = 0
                            rd = 0
                            imm = 0
                            skip_instruction = True

                    case _:
                        raise NotImplementedError(f"Unsupported J-type instruction: {operation}, Cycle: {cycle + 1}")
                
                instruction = ((opcode << 26) | target)

            case _:
                raise ValueError(f"Invalid instruction type: {instruction_type}, Cycle: {cycle + 1}")

    else:                                                                                                                               # If a mult/div happened, the next two instruction are force generated as MFLO and MFHI.
        if (force_store_cycle == 1):
            operation = "mflo"
            instruction_type = "R"
            fn = 0b010010
            opcode = 0
            rd = random.randint(3,31)
            force_store_cycle = 2
            rs = 0
            rt = 0
            destination_register = rd
            assembly = f"{operation} ${rd}"
            instruction = ((opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (sa << 6) | (fn & 0x3F))                             # Encode the instruction.

        elif (force_store_cycle == 2):
            operation = "mfhi"
            instruction_type = "R"
            fn = 0b010000
            opcode = 0
            rd = random.randint(3,31)
            force_store_cycle = 0
            rs = 0
            rt = 0
            destination_register = rd
            assembly = f"{operation} ${rd}"
            force_store = False
            instruction = ((opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (sa << 6) | (fn & 0x3F))                             # Encode the instruction.

        else:
            raise NotImplementedError(f"Error, no random instructions generated, no forced instructions generated at cycle {cycle + 1}.")


    print(f"Generated instruction number {cycle + 1}: {assembly}")
    forced_result_from_skipped_multdiv = (div_mult_in_jump and operation in ("mflo", "mfhi"))

    if jump_signal:
        if not jump_message:
            if operation == "sw":
                print(f"Instruction Generator: Initialized memory not stored due to jump, remaining jump skips = {jump_skips}")
            else:
                print(f"Instruction Generator: Initialized register not stored due to jump, remaining jump skips = {jump_skips}")
        else:
            jump_message = False

        if jump_skips == 0:
            jump_signal = False
            jump_message = False

        global_skips = jump_skips
        if (not skip_instruction):
            jump_skips -= 1

    elif branch_signal:
        if not branch_message:
            if operation == "sw":
                print(f"Instruction Generator: Initialized memory not stored due to branch, remaining branch skips = {branch_skips}")
            else:
                print(f"Instruction Generator: Initialized register not stored due to branch, remaining branch skips = {branch_skips}")
        else:
            branch_message = False

        if branch_skips == 0:
            branch_signal = False
            branch_message = False

        global_skips = branch_skips
        if (not skip_instruction):
            branch_skips -= 1


    elif forced_result_from_skipped_multdiv:
        print(f"Instruction Generator: Initialized {operation} register not stored because its mult/div was skipped.")

    elif (destination_register is not None and destination_register not in initialized_registers):
        initialized_registers.append(destination_register)

    if div_mult_in_jump and operation == "mfhi":
        div_mult_in_jump = False


    print(f"Hex instruction: {instruction:08X}\n")

    return instruction, initialized_registers, skip_instruction, initialized_memory