# RTL-2-QOR

> **Skip synthesis. Predict ASIC area, delay, and power straight from Verilog with CodeBERT.**

**RTL-2-QOR** is a deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics- specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**- directly from raw RTL Verilog code. 

## 💡 Motivation
* **The Problem:** Modern ASIC design relies heavily on iterative Electronic Design Automation (EDA) flows. Standard logic synthesis and Static Timing Analysis (STA) can take minutes to hours per design, creating a major feedback bottleneck that slows down RTL iteration, design space exploration (DSE), and architectural optimization.
* **Proposed Design:** **RTL-2-QOR** replaces slow, front-end EDA synthesis runs with a deep-learning model. By feeding tokenized Verilog RTL directly into a fine-tuned CodeBERT transformer, the system predicts post-synthesis QoR metrics in milliseconds.
* **The Impact:** Enables instant feedback on hardware changes, accelerates early-stage architectural analysis, and dramatically cuts compute overhead in automated hardware design flows.
