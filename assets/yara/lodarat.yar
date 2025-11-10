// ---
// name: "LodaRAT"
// family: "LodaRAT"
// tags: ["rat","infostealer","cookies"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule LodaRAT {
  meta:
    description = "Detects LodaRAT malware"
  strings: 
    $ip1 = "172.111.138.100"
    $str1 = "mp3quran.net"
condition:
  any of them
}