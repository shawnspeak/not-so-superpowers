---
type: llm
focus: trace
---
PASS if the review subagent's brief included the spec, the migration code or diff, known tradeoffs, and an explicit request to hunt for missing requirements and failure modes; and the final answer reports, labeled by severity, as blocking: unparseable numbers (empty strings, extensions, too few or too many digits) are overwritten with garbage such as "+" instead of being left unchanged and counted — and at least one further real failure mode, such as a NULL `phone` crashing the migration with a TypeError, international "00"-prefixed numbers being mangled, or the absence of any unparseable-row count in a log. The agent presents the findings as input for the user's decision rather than declaring the migration safe.
FAIL if the review was performed only by the agent itself, the brief omitted the spec, or the unparseable-overwrite problem is missing.
