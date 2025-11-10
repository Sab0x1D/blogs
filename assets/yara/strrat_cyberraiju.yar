// ---
// name: "StrRAT -Cyber Raiju"
// family: "StrRAT"
// tags: ["rat","java","infostealer","keylogger","plugin-based"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule StrRAT_CyberRaiju {
  meta:
    description = "Detects components or the presence of STRRat used in eCrime operations"
    author = "@CyberRaiju"
    date = "2022-05-19"
    hash1 = "ec48d708eb393d94b995eb7d0194bded701c456c666c7bb967ced016d9f1eff5"
    hash2 = "0A6D2526077276F4D0141E9B4D94F373CC1AE9D6437A02887BE96A16E2D864CF"
    reference = "https://www.jaiminton.com/reverse-engineering/strrat"
  strings:
    $ntwk1 = "wshsoft.company" fullword ascii
    $ntwk2 = "str-master.pw" fullword ascii
    $ntwk3 = "jbfrost.live" fullword ascii
    $ntwk4 = "ip-api.com" fullword ascii
    $ntwk5 = "strigoi" fullword ascii
    $host1 = "ntfsmgr" fullword ascii
    $host2 = "Skype" fullword ascii
    $host3 = "lock.file" fullword ascii
    $rat1 = "HBrowserNativeApis" fullword ascii
    $rat2 = "carLambo" fullword ascii
    $rat3 = "config" fullword ascii
    $rat4 = "loorqhustq" fullword ascii	  
condition:
  filesize < 2000KB and (2 of ($ntwk*) or all of ($host*) or 2 of ($rat*)) 
}