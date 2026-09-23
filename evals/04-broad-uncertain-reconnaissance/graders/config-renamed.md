---
type: regex
target: { source: file, path: config/billing.ini }
pattern: 'customer_'
match: not_contains
---
