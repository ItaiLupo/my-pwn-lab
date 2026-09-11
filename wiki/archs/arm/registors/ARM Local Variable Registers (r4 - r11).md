---
tags: [arm, arm-registers, assembly, low-level, registers]
---

## ARM Local Variable Registers (r4 - r11)

In the ARM 32-bit architecture, the registers **r4 through r11** are designated as the standard workspace for holding local variables and long-lived data.  
This behavior is strictly regulated by the ARM Architecture Procedure Call Standard (AAPCS).

---

### 1. The Core Rule: Callee-Saved (Non-Volatile)

Unlike the scratchpad registers (`r0-r3`), registers `r4-r11` **must be preserved** across function calls. 

* If a function decides to use `r6` (or any register in the `r4-r11` block), it is legally obligated to back up the original data before modifying it.
* This contract ensures that when a parent function calls a child function, it can safely store data in `r6` and trust that the data will remain completely intact when the child function returns.

---

### 2. Standard Assembly Implementation (Push & Pop)

To fulfill the AAPCS contract, compilers automatically inject stack preservation mechanics at the entry (**prologue**) and exit (**epilogue**) of a function.

```assembly
my_function:
    push {r4, r6, lr}  ; 1. Prologue: Save original r4 and r6 to the stack
    
    mov r6, #100       ; 2. Body: Safely overwrite r6 for local math
    bl  other_function ; 3. Call another function (other_function won't ruin r6)
    
    pop {r4, r6, pc}   ; 4. Epilogue: Restore original r4/r6 and return
```

---

### 3. Special Purpose Aliases within this Block

While all of these are general-purpose registers, two registers within this group often carry hidden roles depending on the OS or compiler settings:
* **`r7`**: Frequently used as the **Frame Pointer (FP)** on Thumb code and Linux systems to track the stack frame boundary. It is also the register used to hold the **Syscall Number** when triggering software interrupts (`svc 0`).
* **`r11`**: Frequently used as the **Frame Pointer (FP)** when compiling standard 32-bit ARM mode code.
