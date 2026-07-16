import pandas as pd
import re
import os
import csv

# ================== CONFIG ==================
INPUT_CSV = "metrex_1500_filtered.csv"
OUTPUT_CSV = "metrex_1500.csv"
OUTPUT_DIR = "rtl_modules_1500"
OUTPUT_TXT = "metrex_1500.txt"
# ============================================

df = pd.read_csv(INPUT_CSV)
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Regex to extract module blocks
module_block_regex = re.compile(r"(module\s+[\s\S]*?endmodule)", re.MULTILINE)
module_name_regex = re.compile(r"module\s+(\w+)")

final_rows = []

# ---------- Helper functions ----------
def extract_math(text):
    """Extract only the math expression after 'compute ... ='."""
    text = str(text)
    match = re.search(r'compute\s*(.*?)\s*=', text, re.DOTALL)
    return match.group(1).strip() if match else None

def extract_final_number(text):
    """Extract the final numeric total from the text."""
    nums = re.findall(r"(\d+\.?\d*)", str(text))
    return float(nums[-1]) if nums else None

# ---------- Process each design ----------
for idx, row in df.iterrows():
    design_number = idx + 1
    rtl = str(row["RTL"])

    # Extract all modules inside this design
    modules = module_block_regex.findall(rtl)
    if not modules:
        continue

    # Identify main module (first non-top)
    main_name = None
    for m in modules:
        name_match = module_name_regex.search(m)
        if name_match:
            name = name_match.group(1)
            if name.lower() != "top":
                main_name = name
                break

    if main_name is None:
        continue

    # Build full design text
    full_design_text = f"//{design_number}\n" + "\n\n".join(modules)

    # Save .v file
    filepath = os.path.join(OUTPUT_DIR, f"{main_name}.v")
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(full_design_text)

    # Clean QoR fields
    gate_counts = re.sub(r'^After synthesis, this design has\s*', '', str(row["synth"])).strip().rstrip('.')

    area_math = extract_math(row["area"])
    delay_math = extract_math(row["delay"])
    static_power_math = extract_math(row["static_power"])

    total_area = extract_final_number(row["area"])
    total_delay = extract_final_number(row["delay"])
    total_static_power = extract_final_number(row["static_power"])

    # Build CSV row
    final_rows.append({
        "module_name": main_name,
        "gate_counts": gate_counts,
        "area_math": area_math,
        "total_area": total_area,
        "delay_math": delay_math,
        "total_delay": total_delay,
        "static_power_math": static_power_math,
        "total_static_power": total_static_power
    })

# ---------- Save final CSV ----------
final_df = pd.DataFrame(final_rows)
final_df.to_csv(OUTPUT_CSV, index=False, quoting=csv.QUOTE_NONNUMERIC)

# ---------- Save human-readable TXT ----------
with open(OUTPUT_TXT, "w", encoding="utf-8") as f:
    for _, r in final_df.iterrows():
        f.write(f"MODULE: {r['module_name']}\n")
        f.write(f"GATES: {r['gate_counts']}\n")
        f.write(f"AREA MATH: {r['area_math']}\n")
        f.write(f"TOTAL AREA: {r['total_area']}\n")
        f.write(f"DELAY MATH: {r['delay_math']}\n")
        f.write(f"TOTAL DELAY: {r['total_delay']}\n")
        f.write(f"STATIC POWER MATH: {r['static_power_math']}\n")
        f.write(f"TOTAL STATIC POWER: {r['total_static_power']}\n")
        f.write("-" * 80 + "\n")

print("✅ Clean metrex_1500.csv created")
print("📁 Clean rtl_modules_1500/ created")
print("📄 Clean metrex_1500.txt created")
