---
type: llm
focus: trace
---
PASS if the final answer lists all eight `format_date` call sites (one `view.py` in each of orders, invoices, shipping, returns, payroll, audit, exports, reminders) with file and line, correctly marks the four that pass `style="uk"` (invoices, returns, audit, reminders), and — if a subagent was used — the subagent was given a lesser model tier (for example `haiku` or `sonnet`) with a prescriptive scope and return format, and the lead checked the returned list before reporting it.
FAIL if any call site is missing or misclassified, or a subagent's summary was relayed without any check.
