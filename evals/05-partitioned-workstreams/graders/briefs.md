---
type: llm
focus: trace
---
If the agent started any subagents, PASS if every brief states one objective, the files the subagent owns and whether it may edit, constraints, acceptance criteria, what to verify, and what to return. If it started none, PASS.
FAIL if any brief is a loose instruction lacking ownership or acceptance criteria.
