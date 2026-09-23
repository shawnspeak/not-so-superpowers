---
type: llm
focus: trace
---
PASS if, by the end, the agent established the real scope of the rename before or while planning — including the usages outside `services/` and `config/` that the spec did not anticipate (`scripts/backfill.py` and `ops/dashboards/revenue.json`) — renamed them all, recorded the corrected scope in the plan, and committed on a branch other than `main`. If the agent used subagents for scoping, they were read-only and the lead did the editing itself.
FAIL if the agent only edited `services/` and `config/`, left any `customer_` identifier or key behind, handed the edits to subagents without isolation, or committed on `main`.
