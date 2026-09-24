---
type: llm
focus: last_message
---
PASS if the final answer reports, labeled by severity, as blocking: unparseable numbers (empty strings, extensions, too few or too many digits) are overwritten with garbage such as "+" instead of being left unchanged and counted — and at least one further real failure mode, such as a NULL `phone` crashing the migration with a TypeError, international "00"-prefixed numbers being mangled, or the absence of any unparseable-row count in a log; and it presents the findings as input for the user's decision rather than declaring the migration safe.
FAIL if the unparseable-overwrite problem is missing, findings are unlabeled, or the migration is declared safe to run.
