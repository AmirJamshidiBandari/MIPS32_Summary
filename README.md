# Pipelined MIPS32

This repository summarizes the design, verification, optimization, and architecture of a custom 32-bit pipelined MIPS32 CPU implemented in SystemVerilog and tested on a Xilinx Basys 3 FPGA.

The project focuses on building a complete hazard-aware pipelined processor, including datapath design, control logic, forwarding, stalling, branch/jump flushing, multicycle arithmetic support, memory-mapped I/O, and FPGA timing optimization.

## Project Overview

The CPU is organized as a 6-stage pipeline:

```text
IF → ID → EX1 → EX2 → ME → WB
```

The design began as a functional MIPS32 processor and was extended into a pipelined architecture with hazard handling and FPGA-focused timing improvements.

The final FPGA-optimized design reached:

```text
Final frequency: 94.340 MHz
FPGA board: Xilinx Basys 3
Language: SystemVerilog
Tool: Vivado
```

## FPGA Demo

A 3-minute 24-second video demonstrates the processor architecture, test instruction sequence, waveform verification, FPGA verification, timing report, and critical-path analysis.

**[▶ Watch the full Pipelined MIPS32 demo on YouTube](https://www.youtube.com/watch?v=PP14SCuXyis)**

## Supported Instructions

The processor supports the following MIPS32-style instruction subset.

### R-Type Instructions

```text
ADD
SUB
AND
OR
XOR
NOR
MULT
DIV
MFHI
MFLO
```

### I-Type Instructions

```text
LW
SW
BEQ
LUI
ORI
ADDI
```

### J-Type Instructions

```text
J
```

## RTL Module Example

A documented RTL example is included to show how an individual control module interacts with the larger processor architecture.

The selected module, `Mult_Div_Multicycle_Control.sv`, coordinates the multicycle multiplier and divider by:

```text
Starting and maintaining multicycle operations
Tracking multiplier and divider progress
Detecting dependent MFHI and MFLO instructions
Generating pipeline stall signals
Selecting completed multiplier or divider results
Enabling writes to the HI/LO register
```

This module was selected because it connects the control unit, multiplier, divider, stall unit, HI/LO multiplexers, and HI/LO register.

- [Read the RTL module explanation](RTL_Example/MULT_DIV_MULTICYCLE_CONTROL_EXPLANATION.md)
- [View the SystemVerilog module](RTL_Example/Mult_Div_Multicycle_Control.sv)

## Architecture Diagram


The diagram explains the complete processor structure, including:

```text
Instruction fetch
Instruction decode
Register file access
Operand selection
Branch and jump calculation
ALU execution
Multicycle multiplication and division
HI/LO datapath
Memory-mapped RAM and I/O
Register writeback
Pipeline registers
Forwarding logic
Stall logic
Control hazard flushing
```

- [Read the diagram explanation](Diagram/DIAGRAM_EXPLANATION.md)
- [View the detailed diagram](Diagram/MIPS32_FULL_DIAGRAM.png)

## Verification Summary

The pipeline was verified using instruction-based test programs, SystemVerilog testbenches, and waveform inspection.

The verification focused on correct execution across:

```text
Register writeback
Memory load/store behavior
Forwarding paths
Load-use hazards
Store-data hazards
Branch and jump flushing
HI/LO operations
Multicycle arithmetic behavior
Combined pipeline hazard cases
```

- [Read the verification summary](Verification/VERIFICATION_SUMMARY.md)
- [Read the verification example](Python_Script/*PYTHON_SCRIPT.md)

## Python Script Summary

The processor is also designed in Python to:

```text
Automate the process of generating instructions 
Automate the process of testing instructions 
Automate the process of verifying results 
Create meaningful tests 
Speed up overall verification
Find issues and mismatches faster and more accurate
```

- [Read the python summary](Verification/VERIFICATION_SUMMARY.md)

## FPGA Optimization Summary

The design was optimized using Vivado timing analysis. Critical paths were identified from timing reports, then improved through architectural changes such as multicycle arithmetic and execute-stage repartitioning.

The main optimization work focused on:

```text
Multiplier timing
Execute-stage critical path reduction
Divider timing and resource usage
FPGA frequency improvement
Timing closure on Basys 3
```

- [Read the optimization summary](Optimization/OPTIMIZATION_SUMMARY.md)
- [Read the optimization example](Optimization_Example/OPTIMIZATION_EXAMPLE.md)

## Hazard Handling

The CPU includes three main hazard-handling units:

```text
Forwarding Unit
Stall Unit
Control Hazard Unit
```

The forwarding unit sends results from later pipeline stages back to earlier execution inputs when possible.

The stall unit handles cases where forwarding is not enough, such as load-use hazards or multicycle operation delays.

The control hazard unit handles branch and jump flushing so incorrect instructions do not continue through the pipeline after the PC changes.

## Memory-Mapped I/O

The processor uses memory-mapped I/O, allowing FPGA I/O regions to be accessed through normal load and store instructions.

The memory system includes:

```text
RAM
IO 1
IO 2
```

A memory control unit selects whether each memory operation targets normal RAM or one of the mapped I/O regions.
