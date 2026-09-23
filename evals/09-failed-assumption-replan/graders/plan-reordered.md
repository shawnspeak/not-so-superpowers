---
type: llm
focus: { source: file, path: docs/specs/2026-09-07-digest.md }
---
PASS if the Plan section now puts the digest template before digest sending and records why (the sending package's tests need the template), and the Contract section is unchanged in meaning — still specifying `send_batch`.
FAIL if the package order is unchanged, the reorder carries no reason, or the Contract was edited to fit the missing API.
