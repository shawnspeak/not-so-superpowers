---
type: llm
focus: trace
---
PASS if the agent's execution-mode choice is explicit and grounded in the repository (the fixed interface and separable pieces), and whatever topology it chose obeys the ownership rules: any subagents that edit files have explicit, non-overlapping file ownership and either run in isolated worktrees or run one at a time; subagents do not commit; the lead owns the `export` interface, integrates the pieces, runs the full test suite itself, and makes every commit on a branch other than `main`. Choosing to implement it all as the lead is acceptable only if the agent justifies that choice from the size of the pieces.
FAIL if editing subagents share files or run concurrently in the same tree, a subagent commits, integration or final verification is delegated, or commits land on `main`.
