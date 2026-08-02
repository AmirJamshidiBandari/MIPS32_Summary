"""
This file runs the full Python and RTL verification process.

It:
1. Generates 32 random MIPS instructions.
2. Runs them on the Python reference model.
3. Saves the Python register and memory results.
4. Compiles and runs the SystemVerilog CPU.
5. Compares the Python and RTL results.
6. Opens GTKWave.
"""

import os
import random
import subprocess
import sys

from Reference_model import run_cpu
from Instruction_memory import load_instruction_memory
from Instruction_generator import random_variables, instruction_generator
from write_instruction import write_instruction


# Use the folder containing this file as the Python working folder.
PYTHON_FOLDER = os.path.dirname(os.path.abspath(__file__))
os.chdir(PYTHON_FOLDER)

# The WSL folder containing the SystemVerilog project.
RTL_PROJECT_FOLDER = "../rtl"

INSTRUCTION_NUMBERS = 32
SEED = 5
MAX_FAILED_ATTEMPTS = 1000

RTL_RESULT_FILES = [
    "final_register_results_rtl.txt",
    "final_memory_results_rtl.txt",
    "final_io1_results_rtl.txt",
    "final_io2_results_rtl.txt"
]


"""
Generate a complete 32-instruction program.

A rejected instruction is not written into Instructions.mem.
The same cycle is tried again until a valid instruction is made.
"""
def generate_program():
    random.seed(SEED)

    cycle = 0
    failed_attempts = 0

    # Opening with "w" clears the old instruction file.
    with open("Instructions.mem", "w", encoding="utf-8"):
        pass

    while cycle < INSTRUCTION_NUMBERS:
        random_instruction = random_variables()

        generated_instruction, initialized_registers, skip_instruction, initialized_memory = (
            instruction_generator(
                random_instruction,
                cycle,
                INSTRUCTION_NUMBERS,
                False
            )
        )

        if skip_instruction:
            print(
                f"Automate: In cycle {cycle + 1}, generated instruction "
                "not written into instruction memory.\n"
            )

            failed_attempts += 1

            if failed_attempts >= MAX_FAILED_ATTEMPTS:
                raise RuntimeError(
                    f"Could not generate a valid instruction for cycle "
                    f"{cycle + 1} after {MAX_FAILED_ATTEMPTS} attempts."
                )

            # Retry the same cycle.
            continue

        write_instruction(generated_instruction)

        cycle += 1
        failed_attempts = 0

    print(f"\nInitialized registers: {initialized_registers}\n")
    print(f"\nInitialized memory: {initialized_memory}\n")


"""
Save the final Python register, RAM, IO1, and IO2 values into files.
"""
def write_python_results(final_data):
    with open("final_register_results_python.txt", "w", encoding="utf-8") as file:
        for index, value in enumerate(final_data["registers"]):
            file.write(f"Register[{index}] = {value}\n")

    with open("final_memory_results_python.txt", "w", encoding="utf-8") as file:
        for index, value in enumerate(final_data["memory"]):
            file.write(f"Memory[{index}] = {value}\n")

    with open("final_io1_results_python.txt", "w", encoding="utf-8") as file:
        for index, value in enumerate(final_data["io1"]):
            file.write(f"IO1[{index}] = {value}\n")

    with open("final_io2_results_python.txt", "w", encoding="utf-8") as file:
        for index, value in enumerate(final_data["io2"]):
            file.write(f"IO2[{index}] = {value}\n")


"""
Delete old RTL result files before starting a new simulation.

This prevents an old result from being compared if the new simulation fails.
"""
def remove_old_rtl_results():
    for filename in RTL_RESULT_FILES:
        if os.path.exists(filename):
            os.remove(filename)


"""
Compile and run the SystemVerilog CPU through WSL.
"""
def run_rtl_simulation():
    remove_old_rtl_results()

    rtl_command = (
        f'cd "{RTL_PROJECT_FOLDER}" && '
        "mkdir -p build && "
        "iverilog -g2012 -f files.f -o build/sim.out && "
        "vvp build/sim.out"
    )

    print("\n================ RUNNING RTL SIMULATION ================\n")

    simulation = subprocess.run(
        ["wsl", "bash", "-lc", rtl_command]
    )

    if simulation.returncode != 0:
        raise RuntimeError("The RTL compilation or simulation failed.")

    # Make sure the testbench created every required result file.
    for filename in RTL_RESULT_FILES:
        if not os.path.exists(filename):
            raise FileNotFoundError(
                f"The RTL simulation did not create {filename}"
            )


"""
Run compare_results.py and stop if Python and RTL do not match.
"""
def compare_results():
    print("\n================ COMPARING RESULTS ================\n")

    comparison = subprocess.run(
        [sys.executable, "compare_results.py"]
    )

    if comparison.returncode != 0:
        raise RuntimeError("The Python and RTL results do not match.")


"""
Open wave.vcd in GTKWave.

Popen is used so GTKWave stays open after this Python file finishes.
"""
def open_gtkwave():
    gtkwave_command = (
        f'cd "{RTL_PROJECT_FOLDER}" && '
        "gtkwave wave.vcd"
    )

    print("\n================ OPENING GTKWAVE ================\n")

    subprocess.Popen(
        ["wsl", "bash", "-lc", gtkwave_command]
    )


"""
Run the complete verification flow.
"""
def main():
    generate_program()

    instruction_memory = load_instruction_memory()
    final_data = run_cpu(instruction_memory)

    write_python_results(final_data)
    run_rtl_simulation()
    compare_results()
    open_gtkwave()


if __name__ == "__main__":
    try:
        main()

    except (FileNotFoundError, RuntimeError) as error:
        print(f"\nAUTOMATION STOPPED: {error}")
        sys.exit(1)
