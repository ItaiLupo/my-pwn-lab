---
tags: [arches, arm, ARM, arm-registers, assembly, low-level, registers]
---

## ARM Program Counter (PC / R15) Architecture Deep Dive

The **Program Counter (PC)**, designated as **R15** in ARM architecture,  
is the register responsible for tracking the execution flow of the processor.  

While it serves a similar logical purpose to `EIP` (x86) or `RIP` (x64),  
its mechanical behavior differs due to historical hardware optimizations.

---

### 1. The Core Rule: Pipeline Offset

In standard x86 architectures, the instruction pointer points directly to the next instruction to be executed.  
In ARM, however, due to the processor's 3-stage pipeline architecture (Fetch, Decode, Execute), the `PC` points ahead of the instruction currently being executed.

When an instruction reads the `PC`, the value returned depends strictly on the current **Processor Mode**:

| Feature               | 🔹 ARM Mode                                                                                | 🔹 Thumb Mode                                                                              |
| :-------------------- | :----------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------- |
| **Instruction Size**  | 4 bytes (32-bit)                                                                           | 2 bytes (16-bit)                                                                           |
| **Pipeline Position** | 2 instructions ahead                                                                       | 2 instructions ahead                                                                       |
| **The Formula**       | $\text{Value of PC} = \text{Current Address} + 8$                                          | $\text{Value of PC} = \text{Current Address} + 4$                                          |
| **Math Example**      | Current `0x8000` $\rightarrow$ PC is `0x8008`                                              | Current `0x8000` $\rightarrow$ PC is `0x8004`                                              |
| **How to Identify**   | Addresses in GDB/Disassembler jump by **4** (e.g., `0x8000` and the next line is `0x8004`) | Addresses in GDB/Disassembler jump by **2** (e.g., `0x8000` and the next line is `0x8002`) |

---

### 2. Reference Execution Example (ARM Mode)

Consider the following execution context executing in standard 32-bit ARM Mode:

```assembly
0x00008cdc <+8>:  mov r3, pc
0x00008ce0 <+12>: add r0, r1, r2
0x00008ce4 <+16>: sub r4, r4, #1
```

#### Execution Breakdown at `0x00008cdc`:

The CPU **Executes** the instruction at `0x00008cdc` (`mov r3, pc`).  
Simultaneously, the CPU is **Decoding** the instruction at `0x00008ce0`.  
Simultaneously, the CPU is **Fetching** the instruction at `0x00008ce4`.

Because the `PC` register physically updates at the **Fetch** stage, reading `pc` at address `0x00008cdc` yields the value **`0x00008ce4`**.

---

### 3. Key Takeaways for Vulnerability Research & Reverse Engineering

* **Data Manipulation:** Operations like `ADD R0, PC, R1` evaluate the math using the pipelined position ($+8$ or $+4$), not the current row pointer.
* **Branching:** Modifying `PC` directly (e.g., `MOV PC, LR` or `POP {..., PC}`) alters the flow of control immediately, acting as a jump instruction.
* **Interworking (BX/BLX):** When jumping to a new address using branching instructions, the least significant bit (LSB) of the target address determines if the processor switches modes (`1` for Thumb, `0` for ARM).
