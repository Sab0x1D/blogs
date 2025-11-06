// ---
// name: "XenoRAT"
// family: "XenoRAT"
// tags: ["rat","remote"]
// author: "Sab0x1D"
// last_updated: "2025-11-06"
// tlp: "CLEAR"
// ---

rule XenoRAT
{
meta:
	description = "Detects Xeno RAT malware"
strings: 
    $str1 = "xeno rat client"
	$str2 = "XenoManager"
	$str3 = "xeno_rat_client"
	$str4 = "xeno rat" nocase
condition:
  any of them
}

