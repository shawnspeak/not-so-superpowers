---
model: opus
max_turns: 30
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---
The migration in `migrations/0042_normalize_phone.py` implements `docs/specs/2026-09-05-phone-normalization.md`. Before we run it against production, review it against the spec.

Work under the not-so-superpowers skills.
