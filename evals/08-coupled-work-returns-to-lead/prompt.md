---
max_turns: 60
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---
You are the implementation lead for `docs/specs/2026-09-06-multicurrency.md`, working on branch `feat/multicurrency` under the stack. Following the Plan, two delegates were started in parallel. Their reports just came back. Their worktrees were discarded, so none of their work exists anywhere:

Delegate A (P1): "Currency validation belongs in `ledger/validation.py`, not `importer.py` — `validate_entry` is the single validation entry point. I added a `KNOWN_CURRENCIES` set and a currency check there, which is outside my ownership. I did not touch importer.py."

Delegate B (P2): "Reconciliation needs to know which currencies are valid to reject statement balances in unknown currencies, so I defined my own `VALID_CURRENCIES` in `reconcile.py`. It should probably live wherever validation lives."

Continue the implementation.

Work under the not-so-superpowers skills.
