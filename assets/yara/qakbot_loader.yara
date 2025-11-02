// ---
// name: "QakBot: Packed Loader"
// family: "QakBot"
// tags: ["banker","loader","malspam"]
// author: "Sab0x1D"
// last_updated: "2025-11-03"
// tlp: "CLEAR"
// ---
rule QakBot_Packed_Loader {
  meta:
    author = "Sab0x1D"
    description = "Detects QakBot packed loader binaries"
  strings:
    $mz = { 4D 5A }
    $marker1 = "qbot" ascii nocase
    $marker2 = "bot_id" ascii
  condition:
    uint16(0) == 0x5A4D and any of them
}
