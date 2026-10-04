# 4-bit ALU: Layered SystemVerilog Testbench

A class-based, layered testbench for a 4-bit ALU, written in SystemVerilog.
The ALU supports 8 operations and produces `carry` and `zero` flags.

## ALU operations

| op_code | Operation   | Result            |
|---------|-------------|-------------------|
| 000     | ADD         | a + b (carry out) |
| 001     | SUB         | a - b             |
| 010     | AND         | a & b             |
| 011     | OR          | a \| b            |
| 100     | XOR         | a ^ b             |
| 101     | NOT         | ~a                |
| 110     | LEFT SHIFT  | a << 1            |
| 111     | RIGHT SHIFT | a >> 1            |

`zero` is set when the result `y` is 0. `carry` is set only on ADD overflow.

## Testbench architecture

```
generator --> driver --> [ ALU (DUT) ] --> monitor --> scoreboard
   (mailbox)   (virtual interface)      (virtual interface)  (mailbox)
```

| Component    | Role                                                              |
|--------------|-------------------------------------------------------------------|
| transaction  | Randomized `a`, `b`, `op_code` plus output fields                 |
| generator    | Creates random transactions and sends them to the driver          |
| driver       | Drives the DUT inputs through a virtual interface                 |
| monitor      | Samples DUT inputs and outputs and sends them to the scoreboard   |
| scoreboard   | Reference model that checks `y`, `carry` and `zero`               |
| environment  | Builds and connects all components                                |
| test         | Program block that creates and runs the environment               |
| testbench    | Top module: instantiates the interface, DUT and test              |

## Project structure

```
ALU/
├── rtl/
│   └── design.sv
└── tb/
    ├── interface.sv
    ├── transaction.sv
    ├── generator.sv
    ├── driver.sv
    ├── monitor.sv
    ├── scoreboard.sv
    ├── environment.sv
    ├── test.sv
    └── testbench.sv
```

## How to run

Only `design.sv` and `testbench.sv` are compiled directly. The other
testbench files are pulled in with `` `include ``.

QuestaSim:

```
vlog -mfcu +incdir+tb rtl/design.sv tb/testbench.sv
vsim -c top -do "run -all; exit"
```

EDA Playground: put `design.sv` in the design pane, the testbench files in
the testbench pane, and select QuestaSim.

## Sample output

```
[SCO][PASS] OR | a=2 b=15 | y=15 carry=0 zero=0
[SCO][PASS] NOT | a=6 b=1 | y=9 carry=0 zero=0
[SCO][PASS] RIGHT SHIFT | a=13 b=9 | y=6 carry=0 zero=0
[SCO][PASS] LEFT SHIFT | a=5 b=0 | y=10 carry=0 zero=0
[SCO][PASS] ADD | a=13 b=12 | y=9 carry=1 zero=0
[SCO][PASS] ADD | a=2 b=14 | y=0 carry=1 zero=1
[SCO][PASS] RIGHT SHIFT | a=4 b=14 | y=2 carry=0 zero=0
[SCO][PASS] ADD | a=7 b=4 | y=11 carry=0 zero=0
```

