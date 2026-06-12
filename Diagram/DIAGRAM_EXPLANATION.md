# CPU Pipeline Diagram Explanation

This document explains the full CPU pipeline diagram for the custom 32-bit pipelined MIPS32 CPU.

The diagram shows the normal datapath, control signals, pipeline registers, and hazard-handling logic used to support correct pipelined execution.

## Pipeline Overview

The CPU is organized as a 6-stage pipeline:

```text
The main instruction flow moves from left to right:
Instruction Fetch Stage (IF) → Instruction Decode Stage (ID) → Execute 1 Stage (EX1) → Execute Stage 2 (EX2) → Memory Stage (ME) → Writeback Stage (WB)
```

The diagram includes both the normal instruction path and the extra forwarding, stalling, and flushing paths required for hazard handling.

## Color Legend

The signal colors separate normal CPU operation from hazard-related behavior:

```text
Blue lines   = normal datapath signals
Green lines  = normal control signals
Orange lines = hazard-related datapath signals
Brown lines  = hazard-related control signals
```

Some paths contain a `/` symbol with a number beside it. This means several related signals are grouped together into one displayed path to keep the diagram readable.

## Pipeline Register Boundaries

The vertical yellow blocks represent pipeline registers. These registers separate the CPU into stages and store datapath values, control signals, destination register addresses, and hazard-related information as instructions move through the pipeline.

The pipeline registers are:

```text
IF/ID
ID/EX1
EX1/EX2
EX2/ME
ME/WB
```

## IF Stage: Instruction Fetch

The Instruction Fetch stage selects the next program counter (PC) value and fetches the instruction from instruction memory.

Main hardware in the IF stage:

```text
PC Writeback MUX
PC Register
32×32 Instruction Memory
PC Adder
```

The PC writeback MUX selects the next program counter (PC) value. This can come from normal sequential execution, a branch target, or a jump target. The PC register stores the current instruction address. The PC adder calculates the next sequential PC value.

## ID Stage: Instruction Decode

The Instruction Decode stage decodes the fetched instruction, reads register operands, and generates the main control signals.

Main hardware in the ID stage:

```text
Control Unit
Instruction Decoder
32×32 Register File
Zero Extender
Sign Extender
Two large MUXes
```

The instruction decoder separates fields such as opcode, function code, source registers, destination registers, immediate values, and jump targets.

The control unit generates control signals such as:

```text
Branch
Jump
REGISTER1_WRITE
WRITEBACK_CONTROL
REGISTER1_DESTINATION
MEMORY1_WRITE
ALU_CONTROL
ALUSrc
ImmExt
```

The register file outputs the two source operands that will be used by later pipeline stages.

## EX1 Stage: Operand Preparation and Branch/Jump Calculation

The EX1 stage prepares operands for execution and calculates branch and jump related values.

Main hardware in the EX1 stage:

```text
16-bit Left Shifter
2-bit Left Shifter
Branch Adder
Jump Concatenation Logic
Five large operand MUXes
```

This stage handles immediate shifting, branch target calculation, jump address construction, and selection of the correct operands before execution.

The large MUXes allow operands to come from either normal register outputs or forwarded results when data hazards occur.

## EX2 Stage: Main Execution

The EX2 stage performs the main arithmetic and logic operations.

Main hardware in the EX2 stage:

```text
ALU
Divider
Multiplier
HI MUX
LO MUX
```

The ALU handles normal arithmetic, logic, comparison, and address calculation operations.

The multiplier and divider handle multicycle arithmetic operations.

The HI and LO MUXes select the correct values between multiplier and divider for the HI/LO register.

## ME Stage: Memory and HI/LO Storage

The Memory stage handles data memory access and stores HI/LO results.

Main hardware in the ME stage:

```text
HI/LO Register
Memory Control Unit
32×32 Memory-Mapped Memory
```

The memory-mapped memory contains:

```text
RAM
IO 1
IO 2
```

The memory control unit selects whether the memory operation targets normal RAM or one of the memory-mapped I/O regions. This allows the CPU to communicate with FPGA I/O using normal load and store instructions.

HI/LO register stores the result of divider or multiplier, which is used to write into main CPU register.

## WB Stage: Register Writeback

The Writeback stage selects the final value that should be written back into the register file.

Main hardware in the WB stage:

```text
Register Writeback MUX
```

The writeback MUX selects between possible writeback sources such as:

```text
ALU result
Loaded memory word
LUI result
HI result
LO result
ORI result
```

The selected value is sent back to the register file through the writeback datapath.

## Hazard Handling Units

The CPU includes three main hazard-handling units:

```text
Control Hazard Unit
Stall Unit
Forwarding Unit
```

## Control Hazard Unit

The control hazard unit handles branch and jump hazards.

When a branch or jump changes the normal instruction flow, the control hazard unit generates flush signals to remove incorrect instructions from the pipeline.

This prevents wrong-path instructions from continuing through the CPU after a branch or jump decision has been made.

## Stall Unit

The stall unit detects hazards that cannot be solved immediately through forwarding.

Examples include:

```text
Load-use hazards
Multicycle operation delays
Cases where the needed result is not available soon enough
```

The stall unit can hold the PC, stall the IF/ID pipeline register, and flush control signals when required.

## Forwarding Unit

The forwarding unit resolves data hazards by sending results from later pipeline stages back to earlier execution inputs.

This allows dependent instructions to use recently computed values without waiting for those values to be written back to the register file.

The orange datapath lines show forwarding-related data movement, while the brown signals show hazard-related control decisions.




