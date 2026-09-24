---
type: llm
focus: { source: file, path: docs/specs/2026-09-03-export.md }
---
PASS if the Plan section states an execution mode grounded in the repository (the fixed `export` interface and the separable formatter, CLI, and guide pieces) and, if it assigns delegates, gives each non-overlapping file ownership, keeps the `export` interface and integration with the lead, and names the workspace branch. Choosing to implement it all as the lead is acceptable only if the Plan justifies that from the size of the pieces.
FAIL if there is no Plan section, delegates share files, or integration or final verification is assigned to a delegate.
