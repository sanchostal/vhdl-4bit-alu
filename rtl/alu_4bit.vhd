# 4-Bit Synchronous ALU in VHDL (Artix-7 FPGA)

An 8-operation 4-bit Arithmetic Logic Unit (ALU) designed in synthesizable VHDL targeting the **Xilinx Artix-7 (XC7A35T)** FPGA. The design features registered I/O stages for static timing closure at 100 MHz and an exhaustive self-checking ModelSim verification environment.

## Architecture & Opcode Table

The ALU accepts two 4-bit unsigned operands (`A[3:0]`, `B[3:0]`) and a 3-bit operation selector (`opcode[2:0]`). Internal datapaths are widened to 5 bits (`unsigned(4 downto 0)`) to capture arithmetic carry/borrow and shift-out bits cleanly without vendor-specific libraries.

| Opcode (`2:0`) | Mnemonic | Operation | Description | `carry_o` Behavior |
| :---: | :---: | :--- | :--- | :--- |
| `000` | `ADD` | `A + B` | 4-bit Unsigned Addition | Asserted on unsigned overflow (`> 15`) |
| `001` | `SUB` | `A - B` | 4-bit Unsigned Subtraction | Asserted on unsigned borrow (`A < B`) |
| `010` | `AND` | `A and B` | Bitwise Logical AND | `0` |
| `011` | `OR` | `A or B` | Bitwise Logical OR | `0` |
| `100` | `XOR` | `A xor B` | Bitwise Logical XOR | `0` |
| `101` | `NOT` | `not A` | Bitwise Inversion of `A` | `0` |
| `110` | `SLL` | `A << 1` | Logical Shift Left by 1 bit | Captures shifted-out MSB `A(3)` |
| `111` | `SRL` | `A >> 1` | Logical Shift Right by 1 bit | `0` |

* **Zero Flag (`zero_o`):** Asserted (`'1'`) whenever the 4-bit output `result[3:0]` evaluates to `"0000"`.

## Synthesis & Timing Results (Vivado / Artix-7)

| Metric | Result |
| :--- | :--- |
| **Target Device** | Xilinx Artix-7 (`xc7a35tcpg236-1`) |
| **LUT Utilization** | 25 Slice LUTs |
| **Target Clock Frequency** | 100 MHz (`10.0 ns` period) |
| **Worst Negative Slack (WNS)** | `+0.3 ns` (Timing Met) |

## Exhaustive Functional Verification (ModelSim)

The testbench (`tb/tb_alu_4bit.vhd`) performs an exhaustive sweep across the entire input state space:
* $2^3 \text{ (opcodes)} \times 2^4 \text{ (operand A)} \times 2^4 \text{ (operand B)} = 2^{11} = \mathbf{2,048\text{ test vectors}}$.
* Every cycle is automatically checked against a behavioral golden reference function (`golden_model`) using VHDL `assert`/`report` checks for `result`, `carry_o`, and `zero_o`.
