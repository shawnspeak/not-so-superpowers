---
type: llm
focus: { source: file, path: docs/specs/2026-09-07-digest.md }
---
PASS if the Plan section now has the digest template proceeding before digest sending and records why — either the reorder itself (the sending package's tests need the template), or sending marked blocked on the user's decision about the missing `send_batch` with the template going first; the packages remain outcome-sized rather than split into micro-steps; and the Contract section is unchanged in meaning — still specifying `send_batch`.
FAIL if the Plan still has sending first with no note, the change carries no reason, the packages were broken into a step-by-step task list, or the Contract was edited to fit the missing API.
