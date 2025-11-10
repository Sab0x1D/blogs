// ---
// name: "XWorm"
// family: "XWorm"
// tags: ["rat","remote","infostealer","keylogger","c2"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule XWorm {
  meta:
    description = "Detects the XWorm malware"
  strings: 
    $str1 = "freshinxworm.ddns.net"
    $str2 = "colmbat82.duckdns.org"
    $str3 = "XWorm"
    $str5 = "L_optReArmSku"
    $str6 = "futurist2.ddns.net"
    $str7 = "<Xwormmm>"
    $str8 = "XWorm V5.2"
    $str9 = "plat.zip"
    $dom1 = "xw9402may.duckdns.org"
    $dom2 = "dcxwq1.duckdns.org"
    $dom3 = "xw9402may.duckdns.org"
    $dom4 = "xwrmmone.duckdns.org"
    $ip1 = "154.53.51.233"
    $ip2 = "154.12.233.76"
    $ip3 = "91.207.57.115"
    $ip4 = "157.20.182.172"
condition:
  any of them	
}