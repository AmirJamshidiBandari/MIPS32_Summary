# RTL Module Example: Multicycle Multiply/Divide Control

This document explains `Mult_Div_Multicycle_Control.sv`, one example RTL module from the pipelined MIPS32 CPU project.

This module was selected as an example because it connects several important parts of the processor together, including the control unit, multiplier, divider, HI/LO multiplexers, HI/LO register, and stall unit. Because of this, it is a good example of how datapath control, multicycle execution, and pipeline hazard handling interact inside the CPU.

## Purpose of the Module

`Mult_Div_Multicycle_Control.sv` is the control logic for the multicycle multiplier and divider units.

The module does not perform multiplication or division itself. Instead, it controls when the multiplier or divider should be active, detects when a dependent HI/LO instruction must stall, and enables the HI/LO register when the final multiplication or division result is ready.

The module controls five main behaviors:

```text
Starting a multiplication operation
Starting a division operation
Keeping the operation active while it is still running
Stalling the CPU if an instruction depends on an unfinished HI/LO result
Writing the completed multiplier or divider result into the HI/LO register
```

## Main Inputs and Outputs

The module receives cycle counters from the multiplier and divider:

```systemverilog
input logic [6:0] cycle_div,
input logic [5:0] cycle_mult,
```

These counters show whether the multiplier or divider is currently in the middle of a multicycle operation.

The module also receives control information from the pipeline:

```systemverilog
input alu_ctrl_t ALU_Control_EX2,
input writeback_t Writeback_Control_ID,
```

`ALU_Control_EX2` tells the module whether the instruction currently in EX2 is a multiply or divide instruction.

`Writeback_Control_ID` tells the module whether the instruction currently in the decode stage wants to read from HI or LO using an instruction such as `MFHI` or `MFLO`.

The module outputs control signals to the multiplier, divider, stall unit, HI/LO register, and HI/LO selection muxes:

```systemverilog
output logic Multicycle_HILO_Register_Enable_EX2,
output logic stall_mult,
output logic stall_div,
output logic Multiply,
output logic Divide,
output HILO_select_t Multicycle_HILO_Select_EX2
```

## Default Control Values

At the beginning of the combinational block, all output signals are assigned safe default values:

```systemverilog
always_comb begin
    Multiply = 0;
    Divide = 0;
    stall_mult = 0;
    stall_div = 0;
    Multicycle_HILO_Register_Enable_EX2 = 0;
    Multicycle_HILO_Select_EX2 = HILO_NONE;
```

This prevents unintended latch behavior and ensures that each signal only becomes active when the correct condition is met.

## Multiplier and Divider Start Logic

The first part of the module controls when the multiplier and divider should be active:

```systemverilog
if ((ALU_Control_EX2 == ALU_MULT) || (cycle_mult > 0 && cycle_mult < 6'd32)) begin
    Multiply = 1;
end

if ((ALU_Control_EX2 == ALU_DIV) || (cycle_div > 0 && cycle_div < 6'd33)) begin
    Divide = 1;
end
```

The multiplier starts when the EX2 stage receives an `ALU_MULT` control signal. After the operation starts, the multiplier remains active while `cycle_mult` is between `1` and `31`.

The divider works the same way. It starts when the EX2 stage receives an `ALU_DIV` control signal and remains active while `cycle_div` is between `1` and `32`.

This logic is needed because multiplication and division are not completed in one clock cycle. The cycle counters allow the control logic to know that a multicycle operation is still running.

## Stall Detection Logic

The next part of the module detects whether the instruction in the decode stage depends on a HI/LO result that is not ready yet:

```systemverilog
if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) &&
    (cycle_mult < 6'd32) && Multiply) begin
    stall_mult = 1;
end

if (((Writeback_Control_ID == WB_HI) || (Writeback_Control_ID == WB_LO)) &&
    (cycle_div < 6'd33) && Divide) begin
    stall_div = 1;
end
```

This logic checks three conditions:

```text
A multiplication or division operation is currently active
The operation has not reached its final cycle yet
The instruction in the decode stage wants to read from HI or LO
```

If all of these conditions are true, the module asserts either `stall_mult` or `stall_div`.

These stall signals are sent to the stall unit so the CPU can pause the pipeline until the HI/LO result is ready. This prevents an `MFHI` or `MFLO` instruction from reading an old or incorrect HI/LO value.

## Multiplier and Divider Stop Logic

The final part of the module detects when the multicycle operation has completed:

```systemverilog
if (cycle_mult == 6'd32) begin
    Multiply = 0;
    Multicycle_HILO_Register_Enable_EX2 = 1;
    Multicycle_HILO_Select_EX2 = HILO_MULT;
end

if (cycle_div == 6'd33) begin
    Divide = 0;
    Multicycle_HILO_Register_Enable_EX2 = 1;
    Multicycle_HILO_Select_EX2 = HILO_DIV;
end
```

When the multiplier reaches cycle `32`, the module stops the multiplication operation, enables the HI/LO register, and selects the multiplier result as the HI/LO input.

When the divider reaches cycle `33`, the module stops the division operation, enables the HI/LO register, and selects the divider result as the HI/LO input.

The signal `Multicycle_HILO_Register_Enable_EX2` allows the completed result to be written into the HI/LO register. The signal `Multicycle_HILO_Select_EX2` controls the HI/LO muxes so the correct result source is selected.

## Why This Module Matters

This module is important because it connects multicycle execution with pipeline hazard control.

Without this module, the CPU could incorrectly allow an `MFHI` or `MFLO` instruction to read from the HI/LO register before a multiplication or division operation has finished. That would cause incorrect results in the pipeline.

By tracking multiplier and divider progress, generating stall signals, and enabling HI/LO writeback only when the result is ready, this module helps make multicycle arithmetic work correctly inside the pipelined CPU.

In summary, this module shows how the processor coordinates:

```text
Multicycle arithmetic
HI/LO result selection
Pipeline stalling
Control signal generation
Correct execution of dependent instructions
```

This makes `Mult_Div_Multicycle_Control.sv` a strong example of how RTL control logic is used to manage real pipeline behavior.
