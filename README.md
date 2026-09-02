# RTL-2-QOR

**RTL-2-QOR** is a deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics- specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**- directly from raw RTL Verilog code. 

## Table of Contents
* [1. Background & Motivation](#1-background--motivation)
  * [1.1 Traditional ASIC Synthesis Bottleneck](#11-traditional-asic-synthesis-bottleneck)
  * [1.2 Proposed Approach: Neural QoR Estimation](#12-proposed-approach-neural-qor-estimation)
* [2. Data Pipeline & Preprocessing](#2-data-pipeline--preprocessing)
  * [2.1 Dataset]

## 💡1. Background & Motivation
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

## 📁 2. Dataset & Preprocessing
### 2.1 Dataset Extraction
The dataset is derived from [`scale-lab/MetRex`](https://huggingface.co/datasets/scale-lab/MetRex) on Hugging Face which contains 25.9k Verilog RTL designs with their corresponding post-synthesis QoR ground-truths. 
* **Filtered Subset:** 15,000 hardware designs meeting the sequence constraint ($\le 512$ tokens).
* **Cleaning:** Stripped HDL comments, redundant compiler directives, and invalid encoding characters.
* **Dataset Splits (Fixed Seed):**
  * **Train:** 12,000 samples (80%)
  * **Validation:** 1,500 samples (10%)
  * **Test:** 1,500 samples (10%)
 
### 2.2 Target Normalization
The raw QoR metrics span vastly different physical magnitudes (e.g., Delay $\sim 10^{-1}\,\text{ns}$ vs. Power $\sim 10^4\,\mu\text{W}$). Training on unnormalized targets causes high-magnitude metrics to dominate loss gradients.
To equalize learning across all heads, labels undergo a two-stage transformation during batch loading:
1. **Natural Log Transform:** Compresses the exponential dynamic range:
   $$y_{\text{log}} = \ln(1 + y_{\text{real}})$$
2. **Z-Score Standardization:** Scaled using training set mean ($\mu_{\text{train}}$) and standard deviation ($\sigma_{\text{train}}$):
   $$z_{\text{true}} = \frac{y_{\text{log}} - \mu_{\text{train}}}{\sigma_{\text{train}}}$$

During evaluation and inference, the network's standardized output ($\hat{z}$) is restored to physical engineering units via the inverse functions:

$$\hat{y}_{\text{log}} = (\hat{z} \cdot \sigma_{\text{train}}) + \mu_{\text{train}}$$ $$\hat{y}_{\text{final}} = \exp(\hat{y}_{\text{log}}) - 1$$

### Metric Conversions Example
| Metric | Raw Label<br>($y_{\text{real}}$) | Log Target<br>($\ln(1 + y)$) | Train Z-Score<br>($z_{\text{true}}$) | Model Output<br>($\hat{z}_{\text{pred}}$) | Restored Log<br>($\hat{y}_{\text{log}}$) | Final Predicted<br>($\hat{y}_{\text{real}}$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Area&nbsp;($\mu\text{m}^2$)** | 500.00 | 6.22 | −0.31 | −0.28 | 6.28 | 532.78 |
| **Delay&nbsp;($\text{ns}$)** | 0.50 | 0.41 | −0.43 | −0.40 | 0.43 | 0.54 |
| **Power&nbsp;($\mu\text{W}$)** | 15,000.00 | 9.62 | +0.96 | +0.91 | 9.51 | 13,493.42 |

## 3. Model Architecture
<img width="874" height="380" alt="image" src="https://github.com/user-attachments/assets/dd51e364-1658-4cc5-85b9-5b6b3d9c75bd" />

The architecture adapts `microsoft/codebert-base` into a multi-target regression pipeline. Raw Verilog RTL is tokenized, contextualized through a 12-layer transformer backbone, and mapped to physical metrics via dedicated prediction heads.

1. **Tokenization & Input Embeddings:**
   * **Byte-Pair Encoding (BPE):** Raw Verilog modules are tokenized using CodeBERT's BPE tokenizer to a fixed maximum sequence length of $512$ tokens, padding shorter sequences with `<PAD>` tokens and truncating longer ones.
   * **Tensor Outputs:** Tokenization produces two input tensors:
     * **Input Token IDs:** $I \in \mathbb{R}^{B \times 512}$
     * **Attention Masks:** $M \in \mathbb{R}^{B \times 512}$ (where $1$ denotes a code token and $0$ denotes padding)
   * **Embedding Lookup & Fusion:** Token IDs are mapped through a $768$-dimensional lookup table and added element-wise to learned $768$-dimensional positional embeddings (positions $0\text{–}511$), producing the initial encoder tensor:
     $$X \in \mathbb{R}^{B \times 512 \times 768}$$
     
2. **Pre-trained CodeBERT Transformer Encoder:**
   * **Bidirectional Attention:** The initial input tensor $X \in \mathbb{R}^{B \times 512 \times 768}$ passes through the 12-layer transformer backbone (12 attention heads per layer) to compute contextualized token interactions, generating the latent representation tensor:
     $$H \in \mathbb{R}^{B \times 512 \times 768}$$
   * **Hierarchical Representation:**
     * **Layers 1–4:** Capture lexical tokens and local surface syntax.
     * **Layers 5–8:** Model intermediate syntactic relationships and circuit structural dependencies.
     * **Layers 9–12:** Encode high-level architectural semantics, datapath topologies, and control-flow logic.
   * **Sequence Pooling:** The contextual embedding corresponding to the leading `[CLS]` token (index $0$) is isolated as the global summary vector for the entire RTL module:
     $$h_{\text{CLS}} \in \mathbb{R}^{B \times 768}$$
3. **Multi-Head MLP Predictors & Output Reconstruction:**
   * **Gradient Isolation:** The global summary vector $h_{\text{CLS}} \in \mathbb{R}^{B \times 768}$ branches into three independent, task-specific MLP regression heads. Decoupling the heads ensures that loss gradients from one metric (e.g., Power) do not cause negative transfer or destabilize the weights dedicated to predicting the other targets (Area, Delay).
   * **Head Architecture:** Each metric predictor employs an identical 3-layer feed-forward network with GELU activations and regularization:
     $$\text{Linear}(768 \rightarrow 256) \rightarrow \text{GELU} \rightarrow \text{Dropout}(p = 0.1) \rightarrow \text{Linear}(256 \rightarrow 128) \rightarrow \text{GELU} \rightarrow \text{Linear}(128 \rightarrow 1)$$
   * **Output Fusion:** Outputs from the three individual heads are concatenated to form the standardized log-space QoR prediction vector:
```math
\hat{z}_{pred} = [\hat{z}_{area}, \hat{z}_{delay}, \hat{z}_{power}] \in \mathbb{R}^{B \times 3}
```
   * **Target Recovery:** Each standardized scalar is un-scaled through the inverse pipeline to yield final physical units:
     $$\hat{y}_{\text{pred}} = \exp\big((\hat{z}_{\text{pred}} \cdot \sigma_{\text{train}}) + \mu_{\text{train}}\big) - 1$$
     
## 4. Training Configuration & Hyperparameters
## 5. Results & Evaluation
