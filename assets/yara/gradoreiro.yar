// ---
// name: "Grandoreiro"
// family: "Grandoreiro"
// tags: ["trojan","banker","infostealer","keylogger"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---


rule Grandoreiro {
  meta:
    description = "Detecting Grandoreiro malware"
  strings: 
    $str1 = "Binary.EoAKtlbmxJOYOsaVKGCVNhNF.dll"
condition:
  any of them
}
