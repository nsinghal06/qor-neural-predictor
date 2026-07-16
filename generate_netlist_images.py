import os
import subprocess
import re

# ========== CONFIGURATION ==========
RTL_DIR = "rtl_modules"
OUT_DIR = "gate_netlist_images"
DPI = 200
# ===================================

# Map Yosys internal cell names → clean display labels
GATE_MAP = {
    "$_AND_": "AND",
    "$_OR_": "OR",
    "$_XOR_": "XOR",
    "$_XNOR_": "XNOR",
    "$_NOT_": "NOT",
    "$_DFF_P_": "DFF",
    "$_DFF_N_": "DFF",
    "$_DFFE_PP_": "DFFE",
    "$_DFFE_NP_": "DFFE",
    "$_MUX_": "MUX",
    "$_AOI3_": "AOI",
    "$_OAI3_": "OAI",
    "$_NAND_": "NAND",
    "$_NOR_": "NOR",
}

os.makedirs(OUT_DIR, exist_ok=True)

print(f"📁 Looking for .v files in: {RTL_DIR}/")
print(f"📂 Images will be saved to: {OUT_DIR}/")
print("-" * 50)

def clean_node_label(match):
    """
    Extract the gate type from Yosys's giant HTML table.
    Replace the entire table with a simple text label.
    """
    full_table = match.group(0)
    
    # NEW FIX: Simple regex to catch $_AND_, $_DFF_P_, $_DFFE_PP_, etc.
    cell_match = re.search(r'\$_[A-Z_]+', full_table)
    
    if cell_match:
        raw_name = cell_match.group(0)  # e.g., "$_AND_", "$_DFFE_PP_"
        clean_name = GATE_MAP.get(raw_name, None)
        
        if clean_name is None:
            # Fallback: remove leading "$_" and trailing "_" from the raw name
            clean_name = raw_name[2:]  # Remove "$_"
            if clean_name.endswith("_"):
                clean_name = clean_name[:-1]  # Remove trailing "_"
        
        return f'label="{clean_name}"'
    else:
        # If we somehow can't find a cell type, leave it empty
        return 'label=""'

for filename in os.listdir(RTL_DIR):
    if not filename.endswith(".v"):
        continue

    module_name = filename[:-2]
    rtl_path = os.path.join(RTL_DIR, filename)

    print(f"🔧 Processing: {module_name}")

    # Step 1: Generate .dot file with Yosys
    yosys_cmd = (
        f'read_verilog {rtl_path}; '
        f'synth -top {module_name}; '
        f'show -format dot -prefix {module_name}'
    )
    
    result = subprocess.run(["yosys", "-p", yosys_cmd], capture_output=True, text=True)

    if result.returncode != 0:
        print(f"   ❌ Yosys failed: {result.stderr[:200]}...")
        continue

    dot_file = f"{module_name}.dot"

    if not os.path.exists(dot_file):
        print(f"   ❌ DOT file missing for {module_name}")
        continue

    # Step 2: Strip HTML tables → clean gate labels
    with open(dot_file, 'r') as f:
        content = f.read()

    # Find and replace all HTML table labels
    pattern = r'label=<\s*<TABLE[^>]*>.*?</TABLE>\s*>'
    content = re.sub(pattern, clean_node_label, content, flags=re.DOTALL | re.IGNORECASE)

    # Step 3: Remove edge labels (signal names) to keep wires clean
    def remove_edge_labels(dot):
        lines = dot.split("\n")
        cleaned = []
        for line in lines:
            if "->" in line:  # edge line
                # remove wire labels ONLY
                cleaned.append(re.sub(r'label="[^"]*"', 'label=""', line))
            else:
                cleaned.append(line)  # keep gate labels
        return "\n".join(cleaned)

    content = remove_edge_labels(content)


    with open(dot_file, 'w') as f:
        f.write(content)

    # Step 4: Convert DOT → High-Res PNG
    png_file = os.path.join(OUT_DIR, f"{module_name}.png")

    convert_cmd = ["dot", "-Tpng", f"-Gdpi={DPI}", dot_file, "-o", png_file]
    result = subprocess.run(convert_cmd, capture_output=True, text=True)

    if result.returncode == 0 and os.path.exists(png_file):
        print(f"   ✅ Saved: {png_file}")
    else:
        print(f"   ❌ Graphviz failed: {result.stderr[:200]}...")

    # Clean up the .dot file
    os.remove(dot_file)

print("-" * 50)
print("🎉 Done! Check your gate_netlist_images/ folder.")