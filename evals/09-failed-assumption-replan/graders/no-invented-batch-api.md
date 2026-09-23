---
type: regex
target: { source: file, path: vendor/mailer/__init__.py }
pattern: 'send_batch'
match: not_contains
---
