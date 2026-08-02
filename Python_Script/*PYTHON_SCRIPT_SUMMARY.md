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

The software model follows the same instruction-processing order:

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

- Generates constrained-random MIPS32 instructions
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

`Instructions.mem` is generated automatically and contains the machine-code instructions used by both the Python reference model and the RTL processor.

---

## Verification Flow

```text
Instruction Generator
        |
        v
 Instructions.mem
     /       \
    v         v
Python Model  RTL Simulation
     \       /
      v     v
   Result Comparison
          |
          v
     PASS / FAIL
          |
          v
       GTKWave
```

---

## Running the Verification

Run the automation script:

```bash
python Automate.py
```

The script generates a new instruction program, runs both processor models, compares their final states, and opens GTKWave.

A successful run produces output similar to:

```text
Registers: PASS
Memory: PASS
IO1: PASS
IO2: PASS

FINAL RESULT: PASS
```
