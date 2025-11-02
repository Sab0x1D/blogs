#!/usr/bin/env python3
"""
build_yara_data.py
------------------
Scans /assets/yara/ for .yar or .yara files and compiles them into
_data/yara_rules.yml so ghostYara can display them.

Usage:
    python scripts/build_yara_data.py
"""

import os, re, yaml
from datetime import datetime

BASE = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
YARA_DIR = os.path.join(BASE, "assets", "yara")
DATA_OUT = os.path.join(BASE, "_data", "yara_rules.yml")

os.makedirs(os.path.dirname(DATA_OUT), exist_ok=True)
rules = []

front_re = re.compile(r"^//\s*---\s*$")
meta_re = re.compile(r"^//\s*(\w+):\s*(.*)$")

for fname in sorted(os.listdir(YARA_DIR)):
    if not fname.lower().endswith((".yar", ".yara")):
        continue
    path = os.path.join(YARA_DIR, fname)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    meta = {}
    rule_lines = []
    in_front = False
    for line in lines:
        if front_re.match(line):
            in_front = not in_front
            continue
        if in_front:
            m = meta_re.match(line)
            if m:
                key, val = m.groups()
                val = val.strip().strip('"').strip("'")
                meta[key] = val
            continue
        rule_lines.append(line.rstrip("\n"))

    # Basic fallback values
    meta.setdefault("id", os.path.splitext(fname)[0])
    meta.setdefault("name", os.path.splitext(fname)[0].replace("_", " ").title())
    meta.setdefault("author", "Sab0x1D")
    meta.setdefault("last_updated", datetime.today().strftime("%Y-%m-%d"))
    meta.setdefault("tlp", "CLEAR")
    meta["rule"] = "\n".join(rule_lines)

    # YAML expects list for tags if present
    if "tags" in meta and isinstance(meta["tags"], str):
        try:
            meta["tags"] = yaml.safe_load(meta["tags"])
        except Exception:
            meta["tags"] = [t.strip() for t in meta["tags"].split(",") if t.strip()]

    rules.append(meta)

with open(DATA_OUT, "w", encoding="utf-8") as out:
    yaml.safe_dump(rules, out, sort_keys=False, allow_unicode=True)

print(f"Built {len(rules)} rules → {os.path.relpath(DATA_OUT, BASE)}")
print("Drop new .yar/.yara files into /assets/yara/ and rerun this script.")
