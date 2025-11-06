// ---
// name: "DcRAT"
// family: "DcRAT"
// tags: ["rat","remote"]
// author: "Sab0x1D"
// last_updated: "2025-11-06"
// tlp: "CLEAR"
// ---

rule DcRAT
{
meta:
	description = "Detects DcRat"
strings: 
  	$str1 = "DcRat" nocase
	$str3 = "DcRatByqwqdanchun"
	$str4 = "DcRatMutex" nocase
	$str5 = "DCRat-Log"
	$str6 = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36 Edg/95.0.1020.53"
	$c21 = "wins23octok.duckdns.org"
	$c22 = "enviasept.duckdns.org"
	$str7 = "DcRat By qwqdanchun1"
	$str8 = "DarkCrystal RAT"
	$str9 = "DCRat-Log#"
condition:
  2 of them
}