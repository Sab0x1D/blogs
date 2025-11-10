// ---
// name: "FormBook -Elastic Security"
// family: "FormBook"
// tags: ["infostealer","keylogger","stealer"]
// author: "Sab0x1D"
// last_updated: "2025-11-10"
// tlp: "CLEAR"
// ---


rule FormBook_ElasticSecurity {
  meta:
    main_author = "Elastic Security"
    id = "5799d1f2-4d4f-49d6-b010-67d2fbc04824"
    fingerprint = "b262c4223e90c539c73831f7f833d25fe938eaecb77ca6d2e93add6f93e7d75d"
    creation_date = "2022-06-08"
    modified = "2022-09-29"
    threat_name = "Windows.Trojan.Formbook"
    reference_sample = "8555a6d313cb17f958fc2e08d6c042aaff9ceda967f8598ac65ab6333d14efd9"
  strings:
    $a = { E9 C5 9C FF FF C3 E8 00 00 00 00 58 C3 68 }
condition:
  all of them
}