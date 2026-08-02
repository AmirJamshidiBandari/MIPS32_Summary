"""
    Every cycle, the instruction generator creates a instruction, then it's stored into the Instructions.mem file. 
"""
def write_instruction(generated_instruction):
    with open ("Instructions.mem", "a") as file:
        file.write(f"{generated_instruction:08X}\n")