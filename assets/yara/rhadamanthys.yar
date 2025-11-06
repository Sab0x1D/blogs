// ---
// name: "Rhadamanthys Stealer"
// family: "Rhadamanthys"
// tags: ["infostealer","stealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-06"
// tlp: "CLEAR"
// ---

rule Rhadamanthys {
  meta:
    author = "Sab0x1D"
    description = "Detects Rhadamanthys Stealer variant of the RedLine malware"
  strings: 
    $str1 = "Notepad++\\plugins\\config"
    $str2 = "atomic_qt\\config"
    $str3 = "Qtum-Electrum\\config"
    $str4 = "Electrum-LTC\\config"
    $str5 = ".gir3n"
    $ip1 = "45.128.234.63"
    $ip2 = "185.172.128.163"
  condition:
    3 of them
}