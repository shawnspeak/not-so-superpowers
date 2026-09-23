---
type: llm
focus: last_message
---
The seeded defect: tokens carry expiry in milliseconds but the middleware compares it to seconds, so tokens effectively never expire. Each package's own tests pass.
PASS if all hold: the final report says an independent reviewer found the milliseconds/seconds mismatch and that it was treated as blocking; it was fixed with a test that exercises issuance and enforcement together; the full suite was rerun and passed; the fix was committed; `NOTES.local` is mentioned as left uncommitted; and each acceptance criterion is mapped to evidence.
FAIL if the work is declared done on the strength of the per-package tests, the unit mismatch is not reported, or the fix is reported as uncommitted.
