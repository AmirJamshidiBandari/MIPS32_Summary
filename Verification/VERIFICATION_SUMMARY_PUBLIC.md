# Verification Summary

## 32-bit MIPS CPU Verification

This document summarizes the verification work completed for a custom 32-bit MIPS CPU. It describes the verification approach, the main design areas tested, the types of issues found, and the final result without exposing the full waveform by waveform verification reports.

The full verification was completed in two stages:

1. **Single-cycle CPU verification**
2. **Pipelined CPU verification**

---

## Verification Methodology

The CPU was verified using a combination of instruction test programs, SystemVerilog testbenches, waveform inspection, and self-checking tests.

The verification process focused on:

- Confirming correct instruction execution
- Checking register and memory updates
- Validating control signal behavior
- Debugging incorrect or undefined signal behavior
- Re-testing each fixed module
- Verifying the complete CPU after individual modules were tested

For the pipelined CPU, self-checking testbench logic was added to speed up debugging by comparing actual outputs against expected values.

---

## Single-Cycle CPU Verification

The single-cycle verification focused on proving that the base CPU datapath worked correctly before pipelining. The design was tested using multiple instruction formats, including **R-type**, **I-type**, and **J-type** instructions.

### Verified Areas

| Area | Verified Components |
|---|---|
| PC Flow | PC increment, branch target selection, jump target selection, next PC selection |
| Arithmetic Units | ALU, multiplier, divider |
| Register and Memory | HI/LO register, register file, data memory |
| Control Logic | Instruction decoder, main control unit |
| Writeback Path | Register writeback source and destination selection |

### Main Single-Cycle Debugging Results

During single-cycle verification, several issues were found and fixed:

| Issue Type | Summary |
|---|---|
| Missing top-level connections | Some hardware modules or control signals were not fully connected in the CPU top module. |
| Incorrect destination selection | A missing control signal caused the wrong destination register to be selected during writeback. |
| Register file reset issue | A reset connection needed to be added so registers initialized predictably. |
| Register `$0` overwrite | The register file originally allowed register `$0` to be overwritten, which violates the MIPS rule that `$0` must always stay zero. |

After these fixes, the single-cycle CPU passed the module level and system level verification checks.

---

## Pipelined CPU Verification

After the single-cycle CPU was verified, the design was expanded into a pipelined CPU. The pipelined verification focused on correctness across pipeline stages, especially when instructions depend on earlier instructions.

### Verified Hazard Areas

| Area | Purpose |
|---|---|
| Forwarding | Bypass results from later pipeline stages to earlier stages when needed. |
| Stalling | Insert bubbles for load-use hazards when forwarding alone is not enough. |
| Control Hazards | Flush incorrect instructions after branch or jump redirection. |
| Combined Hazard Tests | Verify forwarding, stalling, and control flow together in mixed instruction sequences. |

### Main Pipeline Debugging Results

The pipelined verification found and fixed several pipeline issues:

| Issue Type | Summary |
|---|---|
| Forwarding destination mismatch | Forwarding originally did not fully support both R-type and I-type destination registers. |
| Unnecessary forwarding | Forwarding could trigger, when an immediate operand should have been used instead. |
| Store into memory forwarding | Store instructions needed special edge case handling, because the address path and store-data path have different forwarding needs. |
| Duplicate stalls | A PC update timing issue caused duplicate instruction fetches, which created repeated stall behavior. |
| Read-after-write timing | A decode stage register file could read operand registers and store into them at the same cycle, reading old register values.  |

Each issue was debugged, corrected, and reverified using waveform checks and self-checking testbench output.

---

## Final Verification Result

The verification process confirmed that the CPU correctly supports the tested instruction behavior in both single-cycle and pipelined forms.

The final pipelined CPU verification confirmed correct behavior for:

- Arithmetic dependencies
- Register writeback dependencies
- Store-data dependencies
- Load-use hazards
- Branch flushing
- Jump flushing
- Mixed chained dependencies

After debugging and re-verification, the CPU was ready for FPGA implementation and later optimization work.

---
