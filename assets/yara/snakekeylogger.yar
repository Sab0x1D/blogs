// ---
// name: "Snake Keylogger"
// family: "Snake Keylogger"
// tags: ["keylogger","infostealer","stealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-03"
// tlp: "CLEAR"
// ---

rule SnakeKeylogger {
  meta:
    description = "Detects Snake Keylogger malware"
  strings:
    $str1 = "SnakeKeylogger"
    $str3 = "Snake Tracker"
    $str4 = "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR1.0.3705;)"
    $ip1 = "77.81.142.87"
    $ip2 = "51.38.247.67"
condition:
  2 of them	
}