---
tags: ["arm-registers", "assembly", "low-level", arm, registers]
---

In the ARM 32-bit architecture,  
the registers **r0, r1, r2, and r3** are designated as the scratchpad registers used for passing inputs into functions and retrieving outputs upon completion.  
This behavior is strictly defined by the **ARM Architecture Procedure Call Standard (AAPCS)**.

---

## 1. Core Functions

These four registers serve dual purposes depending on whether a function is starting or finishing.

### 📥 Function Arguments (Inputs)

When a function is called, the first four arguments are loaded directly into these registers from left to right:
* **`r0`**: Holds the 1st argument.
* **`r1`**: Holds the 2nd argument.
* **`r2`**: Holds the 3rd argument.
* **`r3`**: Holds the 4th argument.

*Note: If a function requires 5 or more arguments, the remaining inputs are pushed onto the Stack (`SP`).*

### 📤 Function Return Values (Outputs)

When a function finishes execution and hits a `return` statement:
* **`r0`**: The primary register used to hold the return value. 
* **`r0 + r1`**: Used together if the function returns a 64-bit value (like a `long long` integer).

---

## 2. Volatile (Scratch) Nature

Registers `r0` through `r3` are **caller-saved (volatile)**. 

This means a function is legally allowed to overwrite or corrupt the values inside `r0-r3` at any time without backing them up.  
If the parent function needs those values after a function call finishes, it is the parent's job to save them to the stack before triggering the branch.

---

## 3. The "Unoptimized Code" Trap (Debugging Context)

When analyzing unoptimized binaries (common in reverse engineering exercises), you will frequently see calculations happening inside `r3` instead of `r0`.

### Example Breakdown:

```assembly
mov r3, #42    ; The compiler uses r3 as a temporary workspace
mov r0, r3    ; The compiler moves the final answer into r0 right before leaving
bx  lr        ; Returns to parent function (r0 contains 42)
```

Even though the math happens inside `r3`, the program must copy it to `r0` before exiting, because the calling environment expects the output to be in `r0`.

## 4. Advanced AAPCS Allocation Constraints

### ⚠️ The Even-Odd Pair Rule (64-bit Types)

AAPCS mandates that 64-bit data types (such as `long long` integers) must naturally align to an even-numbered core register pair (`r0:r1` or `r2:r3`). 

If register alignment fails, a register is intentionally wasted:

```c
// Example Function Prototype:
void my_func(int a, long long b, int c);
```

* **`a`** (32-bit) lands in **`r0`**.
* **`b`** (64-bit) requires an even pair. Since `r1` is odd, **`r1` is left empty/skipped**. `b` occupies **`r2` and `r3`**.
* **`c`** (32-bit) cannot fit in the registers anymore, so it is pushed onto the **Stack**.

### 📐 Stack Alignment Contract

The AAPCS specifies that at any function call boundary, the Stack Pointer (`SP`) **must be 8-byte aligned** (divisible by 8).  
Even if a function only pushes a single 4-byte register, it must adjust the stack pointer by an extra 4 padding bytes to maintain this 8-byte boundary constraint before branching out.
