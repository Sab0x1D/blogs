// ---
// name: "PDQ Connect"
// family: "PDQRAT"
// tags: ["rat","rmm","remote","legitimate-tool"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule PDQConnect {
  meta:
    description = "Detects PDQ RAT"
  strings: 
    $str1 = "PDQConnectAgent"
    $str2 = "pdq-connect-agent.exe"
    $ip1 = "34.54.45.198"
condition:
  any of them
}