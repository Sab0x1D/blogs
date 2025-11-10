// ---
// name: "PocoRAT"
// family: "PocoRAT"
// tags: ["rat","remote","infostealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule PocoRAT {
  meta:
    description = "Detects PocoRAT malware"
  strings: 
    $str1 = "Poco"
    $str2 = "x:\\poco-1.12.4-all\\foundation\\include\\poco"
    $ip1 = "94.131.119.126"	
condition:
  2 of them	
}