import "pe"

// ---
// name: "DanaBot"
// family: "DanaBot"
// tags: ["trojan","banker","infostealer"]
// author: "Sab0x1D"
// last_updated: "2025-12-02"
// tlp: "CLEAR"
// ---

rule DanaBot
{
  meta:
    author      = "RussianPanda"
    description = "Detects DanaBot"
    date        = "2023-12-01"
    reference   = "Internal DanaBot analysis"

  strings:
    // code signature
    $s1 = { 55 8B EC 0A 45 08 34 4A 5D C2 04 00 }

    // UTF-16 strings (Mozilla + registry paths)
    $s2 = { 4D 00 6F 00 7A 00 69 00 6C 00 6C 00 61 00 20 00 53 00 65 00 61 00 4D 00 6F 00 6E 00 6B 00 65 00 79 }
    $s3 = { 4D 00 6F 00 7A 00 69 00 6C 00 6C 00 61 00 20 00 54 00 68 00 75 00 6E 00 64 00 65 00 72 00 62 00 69 00 72 00 64 00 }
    $s4 = { 53 00 6F 00 66 00 74 00 77 00 61 00 72 00 65 00 5C 00 4F 00 52 00 4C 00 5F 00 57 00 49 00 4E 00 56 00 43 00 }
    $s5 = { 53 00 6F 00 66 00 74 00 77 00 61 00 72 00 65 00 5C 00 45 00 78 00 63 00 6F 00 74 00 65 00 64 00 20 00 53 00 65 00 73 00 73 00 69 00 6F 00 6E 00 73 00 5C 00 50 00 61 00 73 00 73 00 77 00 6F 00 72 00 64 00 }

    // Delphi marker
    $delphi_class = { 44 45 4C 50 48 49 43 4C 41 53 53 }

  condition:
    uint16(0) == 0x5A4D and          // PE file (MZ)
    pe.is_32bit() and                // most DanaBot samples observed as 32-bit
    $delphi_class and                // Delphi malware marker
    3 of ($s1, $s2, $s3, $s4, $s5)
}
