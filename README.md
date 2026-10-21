# 4-Bit ALU in VHDL (Artix-7 FPGA)

This repo has my 8-operation 4-bit ALU written in VHDL for the Xilinx Artix-7 FPGA (`xc7a35tcpg236-1` on the Basys 3 board)[cite: 1]. 

## How It Works

The ALU takes two 4-bit unsigned inputs (`A` and `B`) and a 3-bit `opcode` to pick between 8 arithmetic, logical, and shift operations[cite: 1]. 

To handle the carry-out flag (`carry_o`) cleanly without messy workarounds, I widened the internal math signals to 5 bits (`unsigned(4 downto 0)`) using `ieee.numeric_std`[cite: 1]. The lower 4 bits (`3 downto 0`) go to the output `result`, and the 5th bit (`bit 4`) gives the carry or borrow flag[cite: 1]. The inputs and outputs are registered on the clock edge so Vivado can measure real register-to-register timing.

### Opcode Table

| Opcode | Operation | Math / Logic | `carry_o` Flag |
| :--- | :--- | :--- | :--- |
| `000` | **ADD** | `A + B` | `1` on unsigned overflow (`> 15`) |
| `001` | **SUB** | `A - B` | `1` on unsigned borrow (`A < B`) |
| `010` | **AND** | `A and B` | `0` |
| `011` | **OR** | `A or B` | `0` |
| `100` | **XOR** | `A xor B` | `0` |
| `101` | **NOT** | `not A` | `0` |
| `110` | **SLL** | `A << 1` | Captures shifted-out MSB `A(3)` |
| `111` | **SRL** | `A >> 1` | `0` |

* **Zero Flag (`zero_o`):** Goes high (`1`) whenever the 4-bit `result` equals `0000`[cite: 1].

## Verification (`tb/tb_alu_4bit.vhd`)

Since the inputs are small (3-bit opcode + 4-bit `A` + 4-bit `B` = 11 bits total), I didn't need random testing[cite: 1]. Instead, I wrote a self-checking testbench in ModelSim that loops through all `2^11 = 2,048` possible input combinations[cite: 1]. 

On every clock cycle, the testbench compares the hardware output (`result`, `carry_o`, and `zero_o`) against a behavioral reference model (`golden_model`) using VHDL `assert` statements and flags any mismatches in the console[cite: 1].

## Synthesis & Timing Results (Vivado)

I synthesized the design in Vivado targeting the Basys 3 Artix-7 (`xc7a35tcpg236-1`) with a 100 MHz clock constraint (`10.0 ns` period)[cite: 1]:
* **LUT Usage:** 25 Slice LUTs[cite: 1]
* **Clock Target:** 100 MHz[cite: 1]
* **Worst Negative Slack (WNS):** `+0.3 ns` (Timing met)[cite: 1]

## Files

* `rtl/alu_4bit.vhd` - 4-bit ALU VHDL source code
* `tb/tb_alu_4bit.vhd` - Self-checking testbench (tests all 2,048 combinations)[cite: 1]
* `constraints/basys3_artix7.xdc` - 100 MHz clock constraint for Vivado
