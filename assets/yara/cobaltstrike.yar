// ---
// name: "Cobalt Strike Ransomware"
// family: "Cobalt Strike"
// tags: ["c2","framework","ransomware"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule Cobalt Strike {
  meta:
    author = "Sab0x1D"
    description = "Detects the Cobalt Strike Ransomware"
  strings: 
    $str1 = "HTTP/1.1 101 Switching Protocols"
    $ip1 = "159.75.57.69"
    $ip2 = "12.202.180.134"
    $ip3 = "192.197.113.45"
condition:
  2 of them
}


