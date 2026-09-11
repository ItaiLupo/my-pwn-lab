---
tags: [arches, arm, ARM, arm-registers, assembly, low-level, registers]
---

## ARM Link Register (LR / R14) Architecture Guide

The **Link Register (LR)**,  
designated as **R14** in ARM 32-bit architecture, is a special-purpose register used to facilitate fast function calls.  
It physically holds the return address for a function so the processor knows where to resume execution once a subroutine finishes.

---

### 1. The Core Rule: Preserving the Return Address

In x86 architectures, when a function call (`CALL`) is made, the return address is automatically pushed onto the stack memory.  
ARM handles this differently to save memory bandwidth.  
When you use a Branch with Link instruction (**`BL`** or **`BLX`**),  
the CPU automatically takes the address of the *next* instruction and copies it directly into the **`LR`**.

#### The Flow:

`BL my_function` is called.  
The CPU copies the next chronological address into `LR`.  
The CPU jumps to `my_function`.

---

### 2. Returning from a Function

Once a function completes its execution, it must query the `LR` to get back to the parent function.  
There are two primary ways this is handled in assembly:

#### 🔹 Method A: Leaf Functions (Using `BX`)

If a function is a "leaf function" (meaning it does not call any other functions inside its own body), the `LR` never changes.  
The function can return instantly with a single instruction:

```assembly
bx lr    ; Branch and Exchange to the address inside LR
```

#### 🔹 Method B: Non-Leaf Functions (Using the Stack)

If a function needs to call *another* function inside its body, the new `BL` call will overwrite the `LR`.  
To prevent losing the original return address, the function must save `LR` to the stack immediately during its prologue:

```assembly
my_function:
    push {r4, lr}      ; 1. Save original LR (and r4) to the Stack
    bl   another_func  ; 2. This overwrite LR with a new return address
    pop  {r4, pc}      ; 3. Pop the saved original LR directly into the PC!
```

*Note: Popping the saved `LR` value straight into the `PC` triggers an immediate jump back to the parent function, eliminating the need to run `bx lr` at the end.*

---

### 3. The BLX / BX Mode Switch Reminder

Because `LR` values are generated or interacted with via Branch and Exchange (`BX`/`BLX`) mechanisms, the **Least Significant Bit (Bit 0)** of the address inside `LR` determines the execution state:
* If Bit 0 of `LR` is `1`, the processor will switch to **Thumb mode** upon return.
* If Bit 0 of `LR` is `0`, the processor will switch to **ARM mode** upon return.
