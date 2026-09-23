---
type: regex
target: { source: file, path: services/billing/handlers.py }
pattern: 'customer_'
match: not_contains
---
