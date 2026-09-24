---
type: llm
focus: last_message
---
PASS if the final report shows the lead integrated the pieces, ran the full test suite itself, and made the commits; and, if delegates edited files concurrently, that each worked in an isolated worktree and did not commit.
FAIL if the report says delegates edited the shared tree concurrently, a delegate committed, or final verification was left to a delegate.
