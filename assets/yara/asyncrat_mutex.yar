// ---
// name: "AsyncRAT: Mutex Pattern"
// family: "AsyncRAT"
// tags: ["rat","mutex","remote"]
// author: "Sab0x1D"
// last_updated: "2025-11-03"
// tlp: "CLEAR"
// ---
rule AsyncRAT_Mutex {
  meta:
    author = "Sab0x1D"
    description = "Detects AsyncRAT mutex artifacts"
  strings:
    $m1 = "AsyncRAT" ascii
    $m2 = "MutexName" ascii
  condition:
    1 of them
}
