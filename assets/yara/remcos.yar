// ---
// name: "Remcos"
// family: "Remcos"
// tags: ["rat","keylogger"]
// author: "Sab0x1D"
// last_updated: "2025-11-03"
// tlp: "CLEAR"
// ---

rule Remcos {
  meta:
    author = "Sab0x1D"
    description = "Detects Remcos malware"
  strings: 
    $str1 = "Remcos"
	  $str2 = "remcos"
	  $str3 = "XWinRemcoso"
	  $ip1 = "212.193.30.230"
	  $ip2 = "95.214.27.6"
	  $ip3 = "213.152.161.181"
	  $ip4 = "178.237.33.50"
	  $ip5 = "179.15.149.222"
	  $c21 = "allonsy.hopto.org"
	  $c22 = "181.131.217.242"
	  $c24 = "jelelaiyegba.duckdns.org"
	  $c25 = "bbuseruploads.s3.amazonaws.com"
	  $c26 = "estrillajuju.con-ip.com"
	  $c27 = "148.113.165.11"
  condition:
    any of them
}
