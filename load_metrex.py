from datasets import load_dataset
import pandas as pd
import re

TARGET_SAMPLES = 1500
SHUFFLE_SEED = 42

# Load dataset
dataset = load_dataset("scale-lab/MetRex", split="train")
shuffled = dataset.shuffle(seed=SHUFFLE_SEED)

collected = []
count = 0

for example in shuffled:
    # Use the correct column name: "RTL"
    code = example.get("RTL", "")
    if not code:
        continue

    # Extract module name
    name_match = re.search(r"module\s+(\w+)", code)
    if not name_match:
        continue

    mod_name = name_match.group(1)

    # Skip top modules
    if mod_name.lower() == "top":
        continue

    count += 1
    labeled_code = f"//{count}\n{code}"

    new_example = dict(example)
    new_example["RTL"] = labeled_code        # keep the column name consistent
    new_example["module_name"] = mod_name
    collected.append(new_example)

    if count == TARGET_SAMPLES:
        break

if count < TARGET_SAMPLES:
    raise RuntimeError(
        f"Only found {count} non-top modules. Could not reach {TARGET_SAMPLES}."
    )

df = pd.DataFrame(collected)
df.to_csv("metrex_1500_filtered.csv", index=False)

print(f"✅ Saved {len(df)} rows to metrex_1500_filtered.csv")
print(f"Columns: {list(df.columns)}")