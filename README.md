# RTL-2-QOR

**RTL-2-QOR** is a deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics- specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**- directly from raw RTL Verilog code. 

## Table of Contents
* [1. Background & Motivation](#1-background--motivation)
  * [1.1 Traditional ASIC Synthesis Bottleneck](#11-traditional-asic-synthesis-bottleneck)
  * [1.2 Proposed Approach: Neural QoR Estimation](#12-proposed-approach-neural-qor-estimation)
* [2. Data Pipeline & Preprocessing](#2-system-architecture--pipeline)
  * 

## 💡 Background & Motivation
### 1.1 Traditional ASIC Synthesis Bottleneck
In modern computer chip (ASIC) design, hardware engineers write code using hardware description languages like **Verilog** at the Register-Transfer Level (RTL). This code describes the logical flow of data between registers and logic gates. However, raw Verilog text does not tell an engineer the physical cost of the hardware:
* **Circuit Area ($\mu\text{m}^2$):** How much silicon die area the design occupies.
* **Critical Path Delay ($\text{ns}$):** The slowest signal propagation delay, dictating maximum clock frequency.
* **Static Power ($\text{mW}$):** Baseline power leakage and energy consumption.

Collectively referred to as **Quality of Results (QoR)** or **PPA (Power, Performance, Area)**, these metrics traditionally require passing the RTL through a process called **Logic Synthesis**.

During synthesis, Electronic Design Automation (EDA) tools (such as Synopsys Design Compiler or open-source Yosys) parse the RTL, optimize the logic, and map every behavioral statement into a gate-level netlist made up of actual silicon standard cells (e.g., NAND, NOR, D-Flip-Flops), followed by Static Timing Analysis (STA).

### The Problem: Logic synthesis is a major computational bottleneck in digital design
* High Latency: Running synthesis tools can take anywhere from tens of minutes to multiple hours for medium-to-large hardware blocks.
* Iterative Friction: Hardware development is highly iterative. If an engineer makes minor tweaks to the Verilog source to fix a bug or optimize performance, they must re-run the entire synthesis flow just to evaluate the physical impact.
* Automated Search Limits: Modern automated techniques, such as Design Space Exploration (DSE), require evaluating thousands of RTL design variations, making full synthesis computationally intractable.
  
### 1.2 Proposed Approach: Fast Neural QoR Estimation
> Note on Scope: Logic synthesis cannot be replaced entirely as it produces the actual gate-level netlist required to tape-out and manufacture the physical chip. In this context, the RTL-2-QOR model serves as a proxy model to provide instant feedback during early-stage iteration and architectural exploration.
> Since ML for EDA is an emerging area of research, this project investigates whether pre-trained language models can approximate synthesis metrics before launching heavy toolchains.
* Goal: Provides post-synthesis QoR estimation to bypass slow, compute-heavy EDA logic synthesis during early design exploration.
* Input: Raw RTL Verilog code files.
* Core Model: A fine-tuned microsoft/codebert-base transformer encoder that extracts structural, semantic, and syntactic patterns directly from tokenized HDL.
* Prediction Head: Multi-target MLP regression heads operating on the sequence embedding to simultaneously predict total circuit area ($\mu\text{m}^2$), critical path delay ($\text{ns}$), and static power ($\text{mW}$).
