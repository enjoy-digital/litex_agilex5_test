#!/usr/bin/env python3

import re
import argparse

def extract_info(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Extract Logic Utilization (first number only, including commas)
    logic_utilization_match = re.search(r'Logic utilization \(in ALMs\)\s*;\s*([\d,]+)', content)
    if logic_utilization_match:
        logic_utilization = logic_utilization_match.group(1)
    else:
        logic_utilization = 'N/A'

    # Extract Total RAM Blocks
    ram_blocks_match = re.search(r'Total RAM Blocks\s*;\s*([\d,]+)\s*/\s*\d+', content)
    if ram_blocks_match:
        ram_blocks = ram_blocks_match.group(1)
    else:
        ram_blocks = 'N/A'

    # Extract Total DSP Blocks
    dsp_blocks_match = re.search(r'Total DSP Blocks\s*;\s*([\d,]+)\s*/\s*\d+', content)
    if dsp_blocks_match:
        dsp_blocks = dsp_blocks_match.group(1)
    else:
        dsp_blocks = 'N/A'

    # Print the extracted information
    print(f"ALMs: {logic_utilization}")
    print(f"RAMs: {ram_blocks}")
    print(f"DSPs: {dsp_blocks}")

def main():
    parser = argparse.ArgumentParser(description="Extract information from Intel Quartus report file.")
    parser.add_argument('file', type=str, help="Path to the report file")
    args = parser.parse_args()

    extract_info(args.file)

if __name__ == "__main__":
    main()
