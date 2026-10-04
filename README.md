# 4-bit ALU: Layered SystemVerilog Testbench

A class-based, layered testbench for a 4-bit ALU, written in SystemVerilog.
It uses constrained-random stimulus, a self-checking scoreboard with a
reference model, and functional coverage.

**Live demo:** [Run on EDA Playground](https://edaplayground.com/x/nmBp)

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

## Features

- Randomized stimulus (`a`, `b`, `op_code`)
- Layered, class-based architecture connected by mailboxes
- Self-checking scoreboard that verifies `y`, `carry` and `zero`
- Functional coverage (op codes, operand ranges, flags, crosses)
- Pass/fail counters and coverage summary at the end of the run

## Testbench architecture

```
generator --> driver --> [ ALU (DUT) ] --> monitor --> scoreboard
   (mailbox)  (virtual interface)  (virtual interface)   (mailbox)
                                                             |
                                                          coverage
```

| Component    | Role                                                            |
|--------------|-----------------------------------------------------------------|
| transaction  | Randomized `a`, `b`, `op_code` plus output fields               |
| generator    | Creates random transactions and sends them to the driver        |
| driver       | Drives the DUT inputs through a virtual interface               |
| monitor      | Samples DUT inputs and outputs and sends them to the scoreboard |
| scoreboard   | Reference model checking `y`, `carry`, `zero`; counts pass/fail |
| coverage     | Covergroup sampled by the scoreboard for every transaction      |
| environment  | Builds and connects all components                              |
| test         | Program block that creates and runs the environment             |
| testbench    | Top module: instantiates the interface, DUT and test            |

## Functional coverage

| Coverpoint / cross | What it measures                                      |
|--------------------|-------------------------------------------------------|
| `cp_op`            | All 8 op codes                                        |
| `cp_a`, `cp_b`     | Operand ranges: 0, 1-7, 8-14, 15                      |
| `cp_carry`         | Carry flag 0 and 1                                    |
| `cp_zero`          | Zero flag 0 and 1                                     |
| `cross_op_zero`    | Every op code with each zero flag value               |
| `cross_op_carry`   | Every op code with each carry value (carry only on ADD, other combinations are ignored) |

## Project structure

```
ALU/
├── rtl/
│   └── design.sv
└── tb/
    ├── interface.sv
    ├── transaction.sv
    ├── coverage.sv
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

The number of vectors is set with `repeat(100)` in the generator, driver,
monitor and scoreboard. Change all four together.

## Sample result

```
[SCO][PASS] SUB | a=13 b=10 | y=3 carry=0 zero=0
--------------------------------------
Total=100  PASS=100  FAIL=0
Functional coverage = 96.43%
--------------------------------------
```

100 random vectors, all checks passed. Coverage is below 100% because a few
rare bins (such as a zero result for OR or AND) are not always hit by
random stimulus. Increasing the vector count raises it.

