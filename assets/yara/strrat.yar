// ---
// name: "StrRAT"
// family: "StrRAT"
// tags: ["rat","java","infostealer","keylogger","plugin-based"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule StrRAT {
  meta:
    description = "Detects StrRAT malware"
  strings: 
    $str1 = "STRRAT"
    $str2 = "carLambo"
    $str3 = "RegisterClipboardFormat(Ljava/lang/String;)"
    $str4 = "HBrowserNativeApis"
    $str5 = "jbfrost.livestrigoi"
    $str6 = "Branchlock"
    $str7 = "strigoi"
    $c21 = "lastdopelast.ddns.net"
    $c22 = "mysaviourlives.ddns.net"
condition:
  any of them	
}