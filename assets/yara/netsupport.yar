// ---
// name: "NetSupport Manager"
// family: "NetSupport"
// tags: ["rat","remote","legitimate-tool"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule NetSupport {
  meta:
    description = "Detects NetSupport Manager RAT"
  strings: 
    $str1 = "NetSupport Manager"
    $str2 = "f36a7294ff7aa92571a3fd7c91282dd5"
    $str4 = "geo.netsupportsoftware.com"
    $str6 = "client32.exe"
    $c21 = "81.19.137.226"
    $c22 = "192.236.192.48"
    $c23 = "blawx.com/letter.php"
condition:
  any of them
}