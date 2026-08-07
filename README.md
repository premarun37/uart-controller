# UART Controller

A UART (Universal Asynchronous Receiver Transmitter) Controller designed in Verilog HDL and implemented through the RTL-to-GDSII physical design flow using OpenLane and the Sky130 PDK.

## Project Structure

```text
uart_controller/
├── img
│   └── floorplan.png
├── README.md
└── src
    ├── top.v
    ├── uart_rx.v
    └── uart_tx.v
```

## Features

- UART Transmitter (TX)
- UART Receiver (RX)
- Verilog RTL Design
- OpenLane Physical Design Flow
- Timing-Clean Design (WNS = 0 ns, TNS = 0 ns)

## Tools Used

- Verilog HDL
- OpenLane
- OpenROAD
- Yosys
- Sky130 PDK
- GTKWave

---

# Synthesis Results

| Parameter | Value |
|------------|---------|
| Total Cells | 438 |
| Total Wires | 441 |
| D Flip-Flops | 84 |
| Sequential Power | 503 µW |
| Combinational Power | 300 µW |
| Leakage Power | 2.06 nW |
| Switching Power | 172 µW |
| Internal Power | 631 µW |
| Total Power | 803 µW |
| Die Area | 10000 µm² (100 × 100) |
| Cell Area | 4704.512 µm² |
| Cell Utilization | 47.04 % |
| TNS | 0.00 ns |
| WNS | 0.00 ns |
| Worst Setup Slack | 7.06 ns |
| Worst Hold Slack | 0.08 ns |
| Clock Skew | 0.05 ns |
| CRPR | 0 ns |
| Max Slew Violations | 0 |
| Max Capacitance Violations | 0 |
| Max Fanout Violations | 0 |
| Input Delay | 2.0 ns |
| Output Delay | 2.0 ns |
| Clock Uncertainty | 0.25 ns |
| Clock Transition | 0.15 ns |
| Timing Derate | 5.0 % |
| Unused Signals | tx_done |

---

# Floorplan Results

![Floorplan](img/floorplan.png)

| Parameter | Value |
|------------|---------|
| Die Area (LL) | (0.0, 0.0) µm |
| Die Area (UR) | (64.41, 175.13) µm |
| Die Width | 64.41 µm |
| Die Height | 175.13 µm |
| Core Area (LL) | (5.52, 10.88) µm |
| Core Area (UR) | (158.7, 163.2) µm |
| Core Width | 153.18 µm |
| Core Height | 152.32 µm |
| Macro Count | 0 |
| Pin Placement | Random |
| Tie Cells | 0 |
| Endcaps | 112 |
| Tap Cells | 319 |
| VPWR Nodes | 1208 |
| VGND Nodes | 1266 |
| Voltage Sources | 1 |

---

# Timing Constraints

| Parameter | Value |
|------------|---------|
| Input Delay | 2 ns |
| Output Delay | 2 ns |
| Clock Uncertainty | 0.25 ns |
| Clock Transition | 0.15 ns |
| Timing Derate | 5 % |
| Load | 0.033442 pF |

---

# Author

**Prem Arun P**  

