# RTL-2-QOR

**RTL-2-QOR** is a deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics- specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**- directly from raw RTL Verilog code. 

## 💡 Background & Motivation
### Logic Synthesis (The Traditional Flow)
In modern computer chip (ASIC) design, hardware engineers write code using hardware description languages like **Verilog** at the Register-Transfer Level (RTL). This code describes the logical flow of data between registers and logic gates. However, raw Verilog text does not tell an engineer the physical cost of the hardware:
* **Circuit Area ($\mu\text{m}^2$):** How much silicon die area the design occupies.
* **Critical Path Delay ($\text{ns}$):** The slowest signal propagation delay, dictating maximum clock frequency.
* **Static Power ($\text{mW}$):** Baseline power leakage and energy consumption.

Collectively referred to as **Quality of Results (QoR)** or **PPA (Power, Performance, Area)**, these metrics traditionally require passing the RTL through a process called **Logic Synthesis**.

During synthesis, Electronic Design Automation (EDA) tools (such as Synopsys Design Compiler or open-source Yosys) parse the RTL, optimize the logic, and map every behavioral statement into a gate-level netlist made up of actual silicon standard cells (e.g., NAND, NOR, D-Flip-Flops), followed by Static Timing Analysis (STA).

**The Problem**: Logic synthesis is a major computational bottleneck in digital design:
* **High Latency**: Running synthesis tools can take anywhere from tens of minutes to multiple hours for medium-to-large hardware blocks.
* **Iterative Friction**: Hardware development is highly iterative. If an engineer makes minor tweaks to the Verilog source to fix a bug or optimize performance, they must re-run the entire synthesis flow just to evaluate the physical impact.
* **Automated Search Limits**: Modern automated techniques, such as Design Space Exploration (DSE), require evaluating thousands of RTL design variations, making full synthesis computationally intractable.
  
**Proposed Approach: Fast Neural QoR Estimation
> **Note on Scope: Logic synthesis cannot be replaced entirely. Because synthesis produces the actual gate-level netlist required to manufacture the physical chip, full EDA compilation remains mandatory for final design sign-off and tape-out. In this context, the RTL-2-QOR model serves as a fast proxy model to provide instant feedback during early-stage iteration and architectural exploration. Since ML for EDA is an emerging research frontier, this project investigates whether pre-trained language models can approximate synthesis metrics before launching heavy toolchains.
