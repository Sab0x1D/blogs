// ---
// name: "StrRAT -Elastic Security"
// family: "StrRAT"
// tags: ["rat","java","infostealer","keylogger","plugin-based"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---

rule StrRAT_ElasticSec {
  meta:
    author = "Elastic Security"
    id = "a3e48cd2-e65f-40db-ab55-8015ad871dd6"
    fingerprint = "efda9a8bd5f9e227a6696de1b4ea7eb7343b08563cfcbe73fdd75164593bd111"
    creation_date = "2024-03-13"
    modified = "2024-03-21"
    threat_name = "Windows.Trojan.STRRAT"
    reference_sample = "97e67ac77d80d26af4897acff2a3f6075e0efe7997a67d8194e799006ed5efc9"
  strings:
    $str1 = "strigoi/server/ping.php?lid="
    $str2 = "/strigoi/server/?hwid="
condition:
  all of them
}