// ---
// name: "GotoRAT"
// family: "GotoRAT"
// tags: ["rat","remote"]
// author: "Sab0x1D"
// last_updated: "2025-11-06"
// tlp: "CLEAR"
// ---

rule GotoRAT{
meta:
	description = "detects GotoRAT malware"
strings: 
	$str1 = "GoTo Resolve"
	$str2 = "GoToResolve"
	$c21 = "https://dumpster.console.gotoresolve.com/api/sendEventsV2"
	$c22 = "34.120.195.249"
condition:
  any of them
}


