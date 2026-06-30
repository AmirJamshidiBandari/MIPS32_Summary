# Verification Example: Writeback to Decode Forwarding Fix

This document shows one verification example from the pipelined MIPS32 CPU project. The test focuses on a chained dependency case where the processor must correctly handle both forwarding and stalling behavior.

The issue exposed a read-after-write timing mismatch between the writeback stage and the decode stage. The fix was to add writeback to decode forwarding inside the register file read logic.

## Test Objective

The objective of this test was to verify that the stall unit and forwarding unit work correctly together during a mixed instruction sequence with chained dependencies.

This test checks a case where a later instruction depends on both:

```text
A previous arithmetic result
A value loaded from memory
```

The processor must correctly forward or stall so the dependent instruction receives the newest operand values.

## Signals Observed

The main waveform signals observed were:

```text
instruction_EX
ALU_input1
ALU_input2
ALU_result_EX
load_word_WB
Forward1
Forward2   
```

These signals were selected because they show the instruction flow through the pipeline, the ALU operand values, the writeback value, and the forwarding control behavior.

## Expected Behavior

At the final dependent instruction, the ALU should receive:

```text
ALU_input1 = 15
ALU_input2 = 11
```

The expected final ALU result is:

```text
15 + 11 = 26
```

The value `15` comes from a previous arithmetic result, while the value `11` comes from a loaded memory value that reaches the writeback stage.

## Original Observed Behavior

Before the fix, the waveform showed that the final instruction did not receive the correct second operand.

![Before fix waveform](/Verification_Example/WAVEFORM_BEFORE.png)

Lets focus around time 80 sec, the expected value for `ALU_input2` was `11`, but the waveform showed:

```text
ALU_input2 = 0
```

Because the second operand was incorrect, the final ALU result was also incorrect.

Instead of calculating:

```text
ALU_result_EX = 15 + 11 = 26
```

The ALU unit calculated:

```text
ALU_result_EX = 15 + 0 = 15
```

the processor used the old register value and calculated the wrong result.

## Root Cause

The issue was a read-after-write timing mismatch in the register file.

At the same time that the writeback stage was writing the loaded value into the register file, the decode stage was trying to read that same register.

The loaded value became available at writeback, but the decode-stage register read still saw the old stored value before the new value was fully available.

In simple terms:

```text
Writeback stage was updating the register.
But decode stage was reading the same register at same time.
Therefore, the register outputted the old value instead of the newest writeback value.
```

This caused `ALU_input2` to receive `0` instead of `11`.

## Fix: Writeback-to-Decode Forwarding

There were two possible ways to solve this issue:

```text
Stall the pipeline for one extra cycle
Forward the writeback value directly into the decode-stage register outputs
```

Forwarding was the better solution because it avoids adding unnecessary stalls, and it makes the design less complicated.

The fix was added inside the register file read logic. If the writeback stage is writing to the same register that the decode stage is reading, the register file output must use the writeback value directly instead of the old stored register value.

### Before the Fix

Before the fix, the register file simply output the stored register values:

```systemverilog
always_comb begin
    data_out_1_ID = register1[rs_ID];
    data_out_2_ID = register1[rt_ID];
end
```

### After the Fix

After the fix, the register file checks whether the writeback destination register matches one of the source registers:

```systemverilog
always_comb begin
    if ((Register1_Write_WB) && (data_in_address_WB != 0) && (data_in_address_WB == rs_ID))
        data_out_1_ID = data_in_WB;
    else
        data_out_1_ID = register1[rs_ID];

    if ((Register1_Write_WB) && (data_in_address_WB != 0) && (data_in_address_WB == rt_ID))
        data_out_2_ID = data_in_WB;
    else
        data_out_2_ID = register1[rt_ID];
end
```

This bypasses the timing mismatch by sending the newest writeback value directly to the decode-stage outputs.

## New Observed Behavior

After adding writeback-to-decode forwarding, the waveform showed the correct value:

![After fix waveform](/Verification_Example/WAVEFORM_AFTER.png)

The waveform confirmed:

```text
ALU_input2 = 11
```

The final instruction then calculated the correct result:

```text
15 + 11 = 26
```

This matched the expected behavior.

Additional testing confirmed that the update did not break normal register reads or normal writeback behavior.

## Conclusion

This verification example exposed a real pipeline timing issue between register writeback and register read.

The original design allowed the decode stage to read an old register value while the writeback stage was updating that same register. This caused a chained dependency instruction to use the wrong operand.

The issue was fixed by adding writeback to decode forwarding inside the register file read logic. After the fix, the decode stage receives the newest writeback value whenever the writeback destination regsiter matches one of the source registers.
