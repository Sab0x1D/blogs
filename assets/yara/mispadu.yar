// ---
// name: "Mispadu"
// family: "Mispadu"
// tags: ["trojan","banker","infostealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule Mispadu {
  meta:
    description = "Detects Mispadu malware"
  strings: 
    $str1 = "geradcontsad.pro"
    $str2 = "contadcom.pro"
    $str3 = "pat2wx"
    $str4 = "contou infect"
    $dom1 = ".zapto.org"
    $dom2 = ".viewdns.net"
    $dom3 = "archivodzb.pro"
    $dom4 = "host.secureserver.net/g1/"
    $dom5 = "up.ddnsking.com"
    $ip1 = "91.92.244.191"
    $ip2 = "208.109.188.20"	
condition:
  2 of them	
}