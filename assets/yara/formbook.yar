// ---
// name: "FormBook"
// family: "FormBook"
// tags: ["infostealer","stealer","keylogger"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule FormBook {
  meta:
    description = "Detects the FormBook malware"
    part_author = "Elastic Security"
    id = "1112e116-dee0-4818-a41f-ca5c1c41b4b8"
    fingerprint = "b8b88451ad8c66b54e21455d835a5d435e52173c86e9b813ffab09451aff7134"
    creation_date = "2021-06-14"
    modified = "2021-08-23"
    last_modified = "2025-11-10"
  strings:
    $str1 = "www.liangyuen528.com"
    $str2 = "www.3xfootball.com"
    $str3 = "www.goldenjade-travel.com"
    $str4 = "www.empowermedeco.com"
    $str5 = "www.kasegitai.tokyo"
    $str6 = "www.rssnewscast.com"
    $a1 = { 3C 30 50 4F 53 54 74 09 40 }
    $a2 = { 74 0A 4E 0F B6 08 8D 44 08 01 75 F6 8D 70 01 0F B6 00 8D 55 }
    $a3 = { 1A D2 80 E2 AF 80 C2 7E EB 2A 80 FA 2F 75 11 8A D0 80 E2 01 }
    $a4 = { 04 83 C4 0C 83 06 07 5B 5F 5E 8B E5 5D C3 8B 17 03 55 0C 6A 01 83 }
condition:
    any of them
}