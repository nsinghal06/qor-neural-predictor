# RTL-2-QOR

**RTL-2-QOR** is a deep learning regression framework designed to estimate downstream ASIC **Quality of Results (QoR)** metrics- specifically **Total Circuit Area ($\mu\text{m}^2$)**, **Critical Path Delay ($\text{ns}$)**, and **Static Power ($\text{mW}$)**- directly from raw RTL Verilog code. 


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
```math
\hat{y}_{pred} = \exp((\hat{z}_{pred} \cdot \sigma_{train}) + \mu_{train}) - 1
```
     
## 4. Training Configuration & Hyperparameters
Training was conducted in PyTorch using cloud-hosted NVIDIA T4 GPUs (16 GB VRAM) on Kaggle. The pipeline optimizes multi-target loss stability, memory throughput, and gradient flow across the 12-layer transformer encoder and dedicated MLP heads.

### 4.1 Multi-Task Loss Formulation
Because hardware metrics span vastly different numerical ranges in standard scale, regression is performed entirely on standardized log-transformed targets. To mitigate the impact of residual outliers, the model is trained using **Smooth L1 (Huber) Loss** ($\beta = 1.0$):

$$\mathcal{L}_{\text{Smooth L1}}(z, \hat{z}) = \begin{cases} 0.5 (z - \hat{z})^2 & \text{if } |z - \hat{z}| < 1 \\ |z - \hat{z}| - 0.5 & \text{otherwise} \end{cases}$$

The total training objective is computed as the unweighted composite sum across all three regression heads:

$$\mathcal{L}_{\text{total}} = \mathcal{L}_{\text{area}} + \mathcal{L}_{\text{delay}} + \mathcal{L}_{\text{power}}$$

### 4.2 Training Dynamics & Hardware Acceleration
* **Automatic Mixed Precision (AMP):** Utilized `torch.cuda.amp` to perform transformer matrix multiplications and activations in `FP16`, cutting peak VRAM utilization by $\sim 50\%$ and maximizing Tensor Core throughput while keeping critical weight accumulations in `FP32`.
* **Optimization & Regularization:** Fine-tuned using `AdamW` ($\beta_1=0.9, \beta_2=0.999$, weight decay $= 0.01$) to decouple weight decay from gradient updates.
* **Learning Rate Scheduling:** Managed via `ReduceLROnPlateau` monitoring validation Smooth L1 loss (decay factor $\gamma = 0.5$, patience $= 2$ epochs) to prevent oscillations as the model approached convergence.

### 4.3 Hyperparameter Summary

| Hyperparameter | Configuration | Rationale |
| :--- | :--- | :--- |
| **Model Backbone** | `microsoft/codebert-base` | 125M parameter pre-trained code representation model |
| **Batch Size** | 16 | Maximizes GPU memory saturation on 16 GB NVIDIA T4 |
| **Peak Learning Rate** | $3 \times 10^{-5}$ | Conservative fine-tuning rate to avoid catastrophic forgetting |
| **LR Scheduler** | `ReduceLROnPlateau` | Dynamically steps down LR when validation loss flattens |
| **Loss Function** | Smooth L1 (Huber) | Quadratic near zero for precision; linear at tails for outlier robustness |
| **Optimizer** | `AdamW` | Decoupled weight decay ($0.01$) for transformer stability |
| **Precision** | FP16 / FP32 (AMP) | `torch.cuda.amp` for memory reduction and Tensor Core compute |
| **Epochs** | 20 | Early-stopping monitored against validation loss |

## 5. Results & Evaluation
The model was evaluated on a held-out test split of 1,500 unseen Verilog designs to assess predictive correlation and relative error against a feature-count baseline.

### 5.1 Quantitative Performance Comparison

| Target Metric | Baseline<br>$\text{Log } R^2$ | Transformer<br>$\text{Log } R^2$ | Baseline<br>Med-APE (%) | Transformer<br>Med-APE (%) |
| :--- | :---: | :---: | :---: | :---: |
| **Area&nbsp;($\mu\text{m}^2$)** | 0.1817 | **0.9052** | $3.98 \times 10^8\%$ | **22.57%** |
| **Delay&nbsp;($\text{ns}$)** | 0.0514 | **0.8701** | $1.04 \times 10^9\%$ | **25.12%** |
| **Power&nbsp;($\mu\text{W}$)** | 0.1910 | **0.9022** | $3.67 \times 10^8\%$ | **27.23%** |


### 5.2 Training Convergence & Loss Dynamics
<img width="744" height="419" alt="image" src="https://github.com/user-attachments/assets/8dc1843b-1769-45cc-8c27-e7677f2e93b7" />


* **Stable Convergence:** The Smooth L1 loss curve exhibits rapid convergence within the first 5 epochs, dropping from an initial validation loss of $\sim 0.16$ to $< 0.05$.
* **Minimal Overfitting:** Validation loss closely tracks the training loss throughout all 20 epochs, plateauing around epoch 13 without divergence, confirming effective regularization via dropout ($p=0.1$) and decoupled weight decay ($0.01$).
<img width="735" height="112" alt="image" src="https://github.com/user-attachments/assets/a8fa5898-ea22-4c6a-9801-119c31f5e177" />


### 5.3 Test Set Parity Analysis
<img width="856" height="466" alt="image" src="https://github.com/user-attachments/assets/0a3a5c3a-9564-4a3e-8036-b86bc3a7309b" />

* **Baseline Limitations (Top Row):** Naive feature counts fail to capture non-linear logic synthesis effects, resulting in horizontal scatter clusters with near-zero correlation ($\text{Log } R^2 \le 0.191$) and catastrophic Med-APE ($> 10^8\%$) caused by near-zero ground truth values.
* **Transformer Alignment (Bottom Row):** Predictions cluster tightly along the ideal diagonal ($y = x$) across multiple orders of magnitude ($\text{Log } R^2 \ge 0.870$), demonstrating that multi-head self-attention effectively extracts structural datapath hierarchies directly from raw RTL syntax.
* **Physical Coupling:** Power predictions closely mirror the area distribution, confirming that the transformer encoder independently learned the physical relationship between silicon area and leakage power without explicit rule injection.

## 6. Summary & Key Takeaways
* **Direct RTL-to-QoR Mapping:** Successfully demonstrated that a pre-trained transformer (`CodeBERT`) can directly learn the non-linear transformations of logic synthesis from raw Verilog HDL, bypassing traditional hand-engineered AST or graph features.
* **Strong Predictive Accuracy:** Achieved $\text{Log } R^2 \ge 0.87$ across all targets ($R^2 > 0.90$ for area and power) and maintained median estimation errors under $28\%$ ($\text{Med-APE} = 22.57\%\text{--}27.23\%$) across designs spanning multiple orders of magnitude.
* **Learned Physical Coupling:** Without manual rule-based programming, the self-attention heads inherently captured real silicon physics—notably the direct relationship between active cell area and static leakage power.
* **Rapid Design Space Exploration:** Addition to traditional multi-hour logic synthesis runs with sub-second, millisecond-level inference, enabling fast architectural feedback and high-throughput optimization during early design phases.
