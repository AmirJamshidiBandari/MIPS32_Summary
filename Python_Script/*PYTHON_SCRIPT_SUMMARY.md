# Python Verification System

## Overview

The goal of the Python verification system is to improve the effectiveness and speed of verification, reduce the time needed to generate tests, improve result accuracy, and make the verification process easier to expand as the processor becomes more complicated.

The Python verification system is divided into two main stages:

1. Python reference model
2. Verification automation

---

## Python Reference Model

The reference model represents the step-by-step behavior of the designed MIPS32 processor in software.

It is simpler than the hardware version because instructions are executed one at a time in a fixed order. Therefore, the reference model does not need to simulate parallel pipeline behavior, forwarding, stalls, or other hazards.

The reference model contains software versions of the processor's main components, including:

- Decoder
- Control unit
- Register file
- ALU and execution unit
- Data memory
- Memory-mapped I/O
- HI/LO registers
- Branch logic
- Jump logic
- Program counter
- Register writeback

The software model follows the same hardware instruction processing order:

```text
IF -> ID -> EX -> MEM -> WB
```

All files contain comments and function explanations describing their purpose and operation.

### Reference Model Files

```text
Branch_adder.py
Control_unit.py
Data_memory.py
Decoder.py
Execute.py
HILO_register.py
Instruction_memory.py
Jump_con.py
PC_register.py
Reference_model.py
Register_writeback.py
Register.py
```

---

## Verification Automation

The automation stage manages the complete verification process.

It:

- Generates random constrained MIPS32 instructions
- Writes the encoded instructions into `Instructions.mem`
- Runs the program on the Python reference model
- Compiles and runs the SystemVerilog RTL processor
- Stores the final results from both models
- Compares the Python and RTL architectural states
- Reports any mismatches
- Produces a final PASS or FAIL result
- Opens the generated waveform file in GTKWave for debugging

The final contents of all 32 registers, RAM, IO1, and IO2 are compared between the Python reference model and the RTL processor.

### Automation Files

```text
Automate.py
compare_results.py
Instruction_generator.py
write_instruction.py
Instructions.mem
```

`Instructions.mem` is generated automatically and contains the machine code instructions used by both the Python reference model and the RTL processor.

---


## Verification Flow

![Flow](/Python_Script/Verification_flow.png)

---
## Running the Verification

The automation script runs the complete Python and RTL verification flow.

### Requirements

The verification flow requires:

- Python 3.10 or newer
- WSL
- Icarus Verilog
- GTKWave
- The SystemVerilog RTL files
- The SystemVerilog testbench
- The `files.f` file

### RTL Project Location

Before running the verification, update `RTL_PROJECT_FOLDER` inside `Automate.py` so it points to the local RTL project folder as seen from WSL.

```python
RTL_PROJECT_FOLDER = "/path/to/rtl/project"
```

This folder must contain the SystemVerilog source files, testbench, and `files.f`.

For example:

```python
RTL_PROJECT_FOLDER = "/home/username/MIPS32_Project/rtl"
```

### File Location Requirements

All Python verification files should remain in the same folder.

`write_instruction.py` creates `Instructions.mem` in this folder, and `Instruction_memory.py` reads the same file.

The Python reference model automatically creates:

```text
final_register_results_python.txt
final_memory_results_python.txt
final_io1_results_python.txt
final_io2_results_python.txt
```

The SystemVerilog testbench must create the following files in the same Python verification folder:

```text
final_register_results_rtl.txt
final_memory_results_rtl.txt
final_io1_results_rtl.txt
final_io2_results_rtl.txt
```

`compare_results.py` reads these files and compares the Python and RTL architectural states.

The filenames and capitalization must remain unchanged.

### Run the Verification

From the Python verification folder, run:

```bash
python Automate.py
```

The automation script will:

1. Generate a random constrained instruction program
2. Write the instructions into `Instructions.mem`
3. Run the Python reference model
4. Compile and run the SystemVerilog RTL processor
5. Save the final register, RAM, IO1, and IO2 states
6. Compare the Python and RTL results
7. Report a final PASS or FAIL result
8. Open the generated waveform in GTKWave

### Random Seed

The generated instruction program is controlled by the `SEED` value inside `Automate.py`.

```python
SEED = 5
```

Using the same seed generates the same random instruction sequence. This allows a failed test to be reproduced and investigated.

Change the seed value to generate a different test program.

### Example Result

A successful run produces output similar to:

```text
Registers: PASS
Memory: PASS
IO1: PASS
IO2: PASS

FINAL RESULT: PASS
```
