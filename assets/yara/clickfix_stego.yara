// ---
// name: "ClickFix Stego Loader - LummaC2 / Rhadamanthys"
// family: "ClickFix"
// tags: ["stego","dotnet","loader","lumma","rhadamanthys"]
// author: "Sab0x1D"
// last_updated: "2025-11-30"
// tlp: "CLEAR"
// reference: "Huntress - ClickFix Gets Creative: Malware Buried in Images"
// ---

rule ClickFix_StegoLoader
{
  meta:
    description = "Heuristic detection of the ClickFix .NET stego loader that extracts shellcode from PNG pixels and injects into explorer.exe"
    author      = "Sab0x1D"
    date        = "2025-11-30"
    reference   = "https://www.huntress.com/blog/clickfix-malware-buried-in-images"
    tlp         = "CLEAR"
    malware_families = "LummaC2, Rhadamanthys"
    confidence  = "medium"

  strings:
    // .NET image-processing / stego-related strings
    $s_bitmap       = "System.Drawing.Bitmap" wide ascii
    $s_lockbits     = "LockBits" wide ascii
    $s_unlockbits   = "UnlockBits" wide ascii
    $s_pixelformat  = "PixelFormat.Format32bppArgb" wide ascii
    $s_bgra         = "Format32bppArgb" wide ascii

    // Common Win32 injection APIs
    $api_vaex       = "VirtualAllocEx" ascii
    $api_wpm        = "WriteProcessMemory" ascii
    $api_crt        = "CreateRemoteThread" ascii
    $api_op         = "OpenProcess" ascii

    // Explorer injection / process targeting hints
    $s_explorer     = "explorer.exe" wide ascii
    $s_inject       = "CreateRemoteThread in explorer" wide ascii nocase

    // AES / config hints
    $s_aes          = "System.Security.Cryptography.AesCryptoServiceProvider" wide ascii
    $s_rijndael     = "System.Security.Cryptography.RijndaelManaged" wide ascii
    $s_iv           = "IV" wide ascii
    $s_key          = "Key" wide ascii

  condition:
    // PE file
    uint16(0) == 0x5A4D and

    // Likely PE/.NET (simple heuristic PE signature check)
    for any i in (0..2) : (uint32(i*0x200 + 0x3C) < filesize and
                           uint32(uint32(i*0x200 + 0x3C)) == 0x00004550) and

    // Image processing + injection combo
    3 of ($s_bitmap, $s_lockbits, $s_unlockbits, $s_pixelformat, $s_bgra) and
    2 of ($api_vaex, $api_wpm, $api_crt, $api_op) and

    // Plus at least one extra hint to reduce FPs
    (1 of ($s_explorer, $s_inject) or 1 of ($s_aes, $s_rijndael, $s_iv, $s_key))
}