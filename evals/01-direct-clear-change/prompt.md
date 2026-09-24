---
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---
Rename `DEFAULT_TIMEOUT` in `app/config.py` to `REQUEST_TIMEOUT_SECONDS` and update everything that uses it. Tests run with `python3 -m unittest`.

Work under the not-so-superpowers skills.
