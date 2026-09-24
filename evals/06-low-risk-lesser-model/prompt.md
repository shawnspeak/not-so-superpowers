---
model: opus
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---
We're implementing `docs/specs/2026-09-04-date-locale.md` under the stack. Before any edits: find every call site of `format_date` across the repo and report `file:line` for each, noting which ones currently pass `style=`. Don't change any files yet.

Work under the not-so-superpowers skills.
