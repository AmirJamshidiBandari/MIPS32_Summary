"""
    Read the Instructions.mem file which contains all the instructions, and copy all the non empty lines into the instruction register file. 
"""
def load_instruction_memory():
    instruction = []
    with open("Instructions.mem", "r") as file:
        for line in file:
            cleaned_line = line.strip()
            if cleaned_line:
                instruction.append(int(cleaned_line, 16))
                

    return instruction