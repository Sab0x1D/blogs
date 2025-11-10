// ---
// name: "NjRAT"
// family: "NjRAT"
// tags: ["rat","remote","keylogger"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule NjRAT {
  meta:
    description = "Detects NjRAT malware"
  strings: 
    $str1 = "njnjnjs.duckdns.org"
    $str2 = "junio2023.duckdns.org"
    $str3 = "njz.txt"
    $str4 = "mofers"
    $str5 = "NYAN CAT"
    $str6 = "nj.txt"
    $str7 = "dfasdfasdgs.duckdns.org"
    $ip1 = "46.246.86.16"
    $ip2 = "154.12.254.215"
condition:
  any of them	
}