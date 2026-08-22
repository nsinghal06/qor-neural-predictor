# RTL2QOR

> **Skip synthesis. Predict ASIC area, delay, and power straight from Verilog with CodeBERT.**

**RTL2QOR** is a multi-target deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics—specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**—directly from raw RTL Verilog code. 

By mapping raw hardware source code directly to physical design metrics, this framework bypasses slow, compute-heavy front-end EDA logic synthesis and Static Timing Analysis (STA) tools like Synopsys Design Compiler (`dc_shell`) and Yosys, delivering metric estimations in milliseconds during early design exploration.
