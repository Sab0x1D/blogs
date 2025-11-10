// ---
// name: "Astaroth"
// family: "Astaroth"
// tags: ["infostealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule Astaroth {
  meta:
    author = "Sab0x1D"
    description = "Detects Astaroth malware"
  strings: 
    $str1 = "\\x73\\x63\\162\\x69\\x70\\x74\\x3a\\x48\\x54\\x74\\x70\\"	
condition:
  any of them
}

