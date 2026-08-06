# Optimization Summary

## 32-bit Pipelined MIPS CPU FPGA Optimization

This document summarizes the FPGA optimization work completed for a custom 32-bit pipelined MIPS CPU. It focuses on the optimization goals, timing results, architectural changes, and tradeoffs without exposing the full detailed implementation report.

The optimization work focused on improving FPGA timing closure, reducing critical-path delay, and keeping the processor functional on a Basys 3 FPGA.

---

## Optimization Methodology

The optimization process was based on FPGA timing analysis.

The main steps were:

1. Synthesise and implement the CPU on FPGA.
2. Confirm number of failing endpoints by using the correct clock period.
3. Analyze Vivado timing reports.
4. Identify the critical path using WNS, logic delay, net delay, and schematic.
5. Determine whether the bottleneck came from combinational logic depth, routing distance, fanout, or a specific hardware block.
6. Modify the architecture to reduce the bottleneck.
7. Re-run implementation and compare timing, utilization, and power results.

The main optimization techniques used were:

- Converting high delay arithmetic units into multicycle units
- Splitting a large execute stage into smaller execute pipeline stages
- Reducing long combinational paths
- Reducing routing pressure between dependent hardware blocks
- Decrease Look-Up Table (LUT) utilization and total on-chip power consumption
- Re-verifying the design after timing changes

---

## Final Timing Summary

| Optimization Stage | Frequency Before | Frequency After | Period Before | Period After |
|---|---:|---:|---:|---:|
| Multicycle Multiplier | ~60 MHz | 74.906 MHz | 16.670 ns | 13.350 ns |
| Execute Stage Split | 74.906 MHz | 96.618 MHz | 13.350 ns | 10.350 ns |
| Active Multicycle Divider | ~10 MHz | 94.340 MHz | ~96.3 ns | 10.600 ns |

After optimizations, the final optimized CPU met timing at approximately **94 MHz**.

---

## Optimization 1: Multicycle Multiplier

### Problem

The original multiplier was implemented as a single-cycle unit. This created a long execute-stage critical path:

```text
ID Pipeline Register → Multiplier Input MUXes → Multiplier → HI/LO MUXes → EX Pipeline Register
```

The multiplier was logic-intensive and created too much combinational delay in one clock cycle.

### Optimization

The multiplier was redesigned as a multicycle unit. Instead of completing multiplication in one cycle, the multiplier performs the operation across multiple cycles and stalls dependent instructions until the result is ready.

### Result

| Metric | Before | After |
|---|---:|---:|
| Frequency | ~60 MHz | 74.906 MHz |
| Period | 16.670 ns | 13.350 ns |
| WNS | 0.402 ns | 0.132 ns |

### Tradeoff

The optimization improved timing but increased latency. A multiplication instruction can now take up to 32 cycles, so dependent instructions such as `mfhi` or `mflo` may stall until the result is ready.

---

## Optimization 2: Execute Stage Pipeline Split

### Problem

After optimizing the multiplier, the critical path moved to the broader execute-stage datapath. The issue was no longer one specific arithmetic unit. Instead, the execute stage contained too much hardware in one cycle.

The bottleneck included:

- Forwarding decisions
- Forwarding data paths
- Large operand-selection multiplexers
- ALU input selection
- Memory input forwarding
- Multiplier/divider input forwarding
- Arithmetic execution

The timing report showed that routing delay and combinational logic pressure became a major part of the critical path.

### Optimization

The execute stage was split into two stages by inserting a new pipeline register.

Before:

```text
ID_pipe → Multiplexers → ALU / Multiplier / Divider → EX_pipe
```

After:

```text
ID_pipe → Multiplexers → EX1_pipe → ALU / Multiplier / Divider → EX2_pipe
```

This changed the CPU from a five-stage pipeline to a six-stage pipeline.

### Result

| Metric | Before | After |
|---|---:|---:|
| Frequency | 74.906 MHz | 96.618 MHz |
| Period | 13.350 ns | 10.350 ns |
| WNS | 0.132 ns | 0.010 ns |

This was the largest frequency improvement in the optimization process.

### Tradeoff

The extra pipeline stage improved timing but increased control complexity. Forwarding and stall logic had to be updated to account for the additional execute stage.

---

## Optimization 3: Multicycle Divider

### Problem

The original divider was a single-cycle unit. It caused a severe timing failure because division does not map efficiently to FPGA DSP blocks and instead requires a large amount of LUT-based combinational logic.

The single-cycle divider caused:

- Very large negative slack
- Hundreds of failing endpoints
- Increased LUT usage
- Increased power usage
- A required clock period close to 100 ns if left unoptimized

### Optimization

The divider was redesigned as a multicycle restoring divider. Instead of completing the full division in one cycle, it processes one bit per cycle for 32 cycles.

### Result

| Metric | Before | After |
|---|---:|---:|
| WNS | -85.989 ns | 0.092 ns |
| Frequency | ~10 MHz equivalent if unoptimized | 94.340 MHz |
| LUT Utilization | ~21% | ~10% |
| Total On-Chip Power | 0.153 W | 0.094 W |

### Tradeoff

The divider now has higher latency because division takes 32 cycles. However, this tradeoff is acceptable because division is less frequent than simple ALU operations, and the optimization significantly improved timing closure, resource usage, and power consumption.

---

## FPGA Verification Approach

The optimized CPU was verified on the Basys 3 FPGA using LEDs and switches.

The verification approach included:

- Comparing internal register values against expected values
- Turning LEDs on or off based on pass/fail conditions
- Mapping register bits to LEDs for debugging
- Using switches to select between different debug views
- Creating temporary debug outputs to isolate incorrect pipeline stages

This allowed the design to be checked directly on FPGA hardware after timing optimization.

---

## Final Result

The optimization process improved the CPU from an initial FPGA implementation running near **60 MHz** to a final design running at approximately **94 MHz** with the divider enabled.

The final design achieved:

- Positive timing slack
- Reduced critical-path delay
- Lower LUT usage
- Lower power usage
- Functional multicycle multiply/divide support
- A six-stage pipelined architecture with updated hazard handling

---
