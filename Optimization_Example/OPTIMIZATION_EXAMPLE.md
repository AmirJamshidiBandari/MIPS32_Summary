# Optimization Example: Multicycle Multiplier

This document shows one FPGA optimization example from the pipelined MIPS32 CPU project. The example focuses on improving timing by changing the multiplier from a single-cycle combinational unit into a multicycle unit.

## Optimization Goal

The goal of this optimization was to reduce the execute stage critical path and increase the maximum stable FPGA clock frequency.

The original design performed multiplication in a single cycle. This made the multiplier part of a long combinational path and limited the clock speed of the CPU.

## Original Critical Path

Vivado timing analysis showed that the critical path was located in the execute stage.

![Before fix waveform](/Optimization_Example/OPTIMIZATION_CRITICALPATH.png)

The main path was:

```text
ID Pipeline Register → Multiplier Input MUXes → Multiplier → HI/LO MUXes → EX Pipeline Register
```

Before the multiplier optimization, the design reached approximately:

```text
Clock period:      16.670 ns
Frequency:         59.988 MHz
WNS:               0.402 ns
WHS:               0.126 ns
Failing endpoints: 0
```

Although the design met timing at this clock period, the multiplier still dominated the execute stage critical path and limited higher frequency operations.

## Root Cause

The original multiplier was implemented as a single cycle operation. This meant the CPU had to complete the full 32-bit multiplication and route the results through the HI/LO selection path within one clock cycle. HI/LO results selected by HI/LO selection MUXes are the Higher and Lower 32-bit values created by the 64-bit multiplication result.

This created a long logic path because multiplication is more complex than simple ALU operations such as addition, subtraction, or bitwise logic.

The timing report showed that the lowest-slack paths were related to multiplier output paths. The delay was mainly caused by logic delay, meaning the multiplier computation itself was the main timing bottleneck rather than only routing distance.

## Original Single-Cycle Multiplier Behavior

Before optimization, the multiplier generated the full 64-bit result in one combinational step:

```systemverilog
always_comb begin
    mult_result = 64'b0;

    case (ALU_Control_EX)
        ALU_MULT: begin
            mult_result = $signed(data_out_1_EX_mux) * $signed(data_out_2_EX_mux);
        end
    endcase
end

assign mult_HI_EX = (ALU_Control_EX == ALU_MULT) ? mult_result[63:32] : 32'b0;
assign mult_LO_EX = (ALU_Control_EX == ALU_MULT) ? mult_result[31:0]  : 32'b0;
```

This was simple, but it forced the multiplication result to be ready in one cycle.

## Optimization Strategy

The multiplier was changed into a multicycle unit.

Instead of completing the full multiplication in one clock cycle, the optimized multiplier performs the operation across multiple cycles. The design uses internal registers, shifting, addition, and a cycle counter to build the final 64-bit result over time.

The optimized multiplier separates the design into three parts:

```text
Control logic
Execution logic
Output logic
```

The control logic starts the multiplication, keeps the multiplier active while it is running, and signals when the result is ready, these values will be stored in HI/LO register.

The execution logic performs the shifting and addition process over multiple cycles to manually create a multiplication operation.

The output logic sends the upper 32 bits to HI and the lower 32 bits to LO when the multiplication is complete.

## Multicycle Multiplier Behavior

In the optimized version, multiplication only runs while the internal `Multiply` signal is active.

At the start of the operation, the input operands are copied into internal multiplier registers. During each cycle, the multiplier checks the lowest bit of the second operand. If the bit is high, the shifted first operand is added into the 64-bit result.

The operands are then shifted, and the cycle counter advances.

When the counter reaches the final cycle, the multiplier outputs the completed HI and LO values.

```systemverilog
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        mult_result <= 64'b0;
        cycle <= 0;
        mult_operand_1 <= 0;
        mult_operand_2 <= 0;
    end

    else if (Multiply) begin
        if (cycle == 0) begin
            mult_result <= 64'b0;
            mult_operand_1 <= data_out_1_EX_mux;
            mult_operand_2 <= data_out_2_EX_mux;
            cycle <= 1;
        end

        else begin
            if (mult_operand_2[0]) begin
                mult_result <= mult_result + {{32{mult_operand_1[31]}}, mult_operand_1};
            end

            mult_operand_1 <= mult_operand_1 << 1;
            mult_operand_2 <= mult_operand_2 >> 1;
            cycle <= cycle + 1;
        end
    end

    else begin
        cycle <= 0;
    end
end
```

The HI and LO outputs are only sent when the multiplication is complete:

```systemverilog
assign mult_HI_EX = (cycle == 6'd32) ? mult_result[63:32] : 32'b0;
assign mult_LO_EX = (cycle == 6'd32) ? mult_result[31:0]  : 32'b0;
```

## FPGA Timing Result

After implementing the multicycle multiplier, timing improved.

The optimized design reached:

```text
Clock period:      13.350 ns
Frequency:         74.906 MHz
WNS:               0.132 ns
WHS:               0.105 ns
Failing endpoints: 0
```

The clock frequency improved from approximately:

```text
59.988 MHz → 74.906 MHz
```

This is an improvement of about:

```text
14.918 MHz
```

The design still maintained positive setup and hold slack, meaning timing closure was achieved at the higher frequency.

## Tradeoffs

The optimization improved clock frequency, but it introduced tradeoffs.

The main tradeoff is latency. A multiplication instruction now takes up to 32 cycles to complete instead of finishing in one clock cycle.

This means that dependent instructions such as `MFHI` or `MFLO` may need to stall until the HI/LO result is ready.

Another tradeoff is increased control complexity. The multiplier now requires cycle counting, internal registers, start/stop control, HI/LO register enable logic, and stall handling for dependent instructions.

However, this tradeoff was worthwhile because the single-cycle multiplier was limiting the overall CPU frequency.

## Conclusion

The multiplier optimization successfully reduced the execute stage timing pressure by moving multiplication from a single-cycle combinational operation to a multicycle operation.

This improved the stable FPGA frequency from `59.988 MHz` to `74.906 MHz` while maintaining positive timing slack.
