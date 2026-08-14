# Verilog-Projects

A collection of beginner-to-intermediate Verilog HDL projects developed while learning **digital design, RTL coding, simulation, and FPGA development**.

These projects are written from scratch to strengthen understanding of **combinational logic, sequential logic, arithmetic circuits, counters, and basic hardware architecture**.

---

## Repository Structure

| Project | Description |
|--------|-------------|
| **16_bit_ALU** | Parameterized 16-bit Arithmetic Logic Unit with simulation testbench |
| **ALU_as_top_module** | Modular ALU design integrating arithmetic, logic, comparison, and shift units |
| **Combinational_logic_and_Sequential_logic** | Basic examples demonstrating combinational and clocked sequential circuits |
| **Down_counter** | Synchronous down counter implemented in Verilog |
| **LFSR** | Linear Feedback Shift Register for pseudo-random sequence generation |

---

## Project Highlights

### 16-bit ALU
- Addition
- Subtraction
- AND / OR / XOR
- Comparison operations
- Testbench included

### Modular ALU (Top Module)
- Arithmetic Unit
- Logic Unit
- Compare Unit
- Shift Unit
- Decoder-based control

### Down Counter
- Clocked synchronous design
- Reset support
- Synthesizable RTL

### LFSR
- Pseudo-random bit generation
- Useful for testing and communication systems

---

## Tools Used

- **Verilog HDL**
- **Xilinx Vivado**
- **Vivado Simulator / ModelSim**
- **VS Code**

---

## How to Run

### Vivado
1. Create a new RTL project
2. Add the source files
3. Add the corresponding testbench
4. Run **Behavioral Simulation**

### ModelSim
```bash
vlog *.v
vsim tb_module_name
run -all
```

---

## Example RTL

```verilog
module Down_counter(
    input clk,
    input rst,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b1111;
    else
        count <= count - 1'b1;
end

endmodule
```

---

## Learning Outcomes

Through these projects I practiced:

- Writing synthesizable Verilog
- Designing combinational circuits
- Designing sequential circuits
- Clock and reset handling
- Modular RTL design
- Creating simulation testbenches
- Understanding FPGA-oriented coding style

---

## Future Work

- Finite State Machines (FSM)
- UART Transmitter/Receiver
- SPI Controller
- PWM Generator
- Matrix Multiplier
- RISC-V Components
- FPGA implementation and timing analysis

---

## Author

**Nayanajith Shehan Ranasinghe**  
Electronic and Telecommunication Engineering  
University of Moratuwa

---

## License

This repository is intended for **educational and learning purposes**.