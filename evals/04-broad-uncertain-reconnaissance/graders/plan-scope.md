---
type: llm
focus: { source: file, path: docs/specs/2026-09-02-account-rename.md }
---
PASS if the Plan section records the rename's real scope, including the usages outside `services/` and `config/` that the Contract did not anticipate (`scripts/backfill.py` and `ops/dashboards/revenue.json`), and the Contract section is unchanged in meaning.
FAIL if there is no Plan section, the Plan covers only `services/` and `config/`, or the Contract was altered.
