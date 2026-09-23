---
type: tool_order
before: { tool: Bash, input_match: 'checkout -b|switch -c|worktree add' }
after: { tool: Bash, input_match: 'git commit' }
---
