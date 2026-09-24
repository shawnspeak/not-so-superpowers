---
type: tool_order
before: { tool: Agent }
after: { tool: Bash, input_match: 'git (add|commit)[^"]*\b(auth|tests)/' }
---
