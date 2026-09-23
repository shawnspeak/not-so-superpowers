---
type: llm
focus: last_message
---
PASS if the final answer lists all eight `format_date` call sites (one `view.py` in each of orders, invoices, shipping, returns, payroll, audit, exports, reminders) with file and line, and correctly marks the four that pass `style="uk"` (invoices, returns, audit, reminders).
FAIL if any call site is missing, invented, or misclassified.
