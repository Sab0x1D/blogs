// ---
// name: "FormBook -Elastic"
// family: "FormBook"
// tags: ["infostealer","stealer","keylogger"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule FormBook_Elastic {
  meta:
    author = "Elastic Security"
    id = "772cc62d-345c-42d8-97ab-f67e447ddca4"
    fingerprint = "3d732c989df085aefa1a93b38a3c078f9f0c3ee214292f6c1e31a9fc1c9ae50e"
    creation_date = "2022-05-23"
    modified = "2022-07-18"
    threat_name = "Windows.Trojan.Formbook"
    reference = "https://www.elastic.co/security-labs/formbook-adopts-cab-less-approach"
  strings:
    $a1 = "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; Trident/7.0; rv:11.0) like Gecko"
    $a2 = "signin"
    $a3 = "persistent"
    $r1 = /.\:\\Users\\[^\\]{1,50}\\AppData\\Roaming\\[a-zA-Z0-9]{8}\\[a-zA-Z0-9]{3}log\.ini/ wide
condition:
    2 of ($a*) and $r1
}