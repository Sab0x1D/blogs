// ---
// name: "RedLine Stealer: Config Markers"
// family: "RedLine"
// tags: ["stealer","infostealer","config"]
// author: "Sab0x1D"
// last_updated: "2025-11-03"
// tlp: "CLEAR"
// ---
rule RedLine_Config_Markers {
  meta:
    author = "Sab0x1D"
    description = "Detects RedLine Stealer config markers"
  strings:
    $a = "Software\\RedLine" wide
    $b = "Wallets\\Bitcoin" wide
  condition:
    any of them
}
