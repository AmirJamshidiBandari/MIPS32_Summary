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

## Key Highlights

```text
6-stage pipelined CPU architecture
Pipeline verification with hazard-focused testing
Forwarding, stalling, and control hazard handling
Multicycle multiplier and divider support
HI/LO register datapath
Memory-mapped RAM and I/O
FPGA timing optimization from critical-path analysis
Public architecture, verification, and optimization documentation
```

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

## Repository Structure

```text
Diagram/
  DIAGRAM_EXPLANATION.md
  MIPS32_FULL_DIAGRAM.png

Optimization/
  OPTIMIZATION_SUMMARY_PUBLIC.md

Verification/
  VERIFICATION_SUMMARY_PUBLIC.md

README.md
```

## Architecture Diagram

The full CPU pipeline diagram is stored in the `Diagram/` folder.

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

For a detailed explanation of the diagram, see:

```text
Diagram/DIAGRAM_EXPLANATION.md
```

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

For the public verification summary, see:

```text
Verification/VERIFICATION_SUMMARY_PUBLIC.md
```

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

For the public optimization summary, see:

```text
Optimization/OPTIMIZATION_SUMMARY_PUBLIC.md
```

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

