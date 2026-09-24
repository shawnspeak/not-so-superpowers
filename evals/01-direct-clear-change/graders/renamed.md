---
type: regex
target: { source: file, path: app/config.py }
pattern: '(^|\n)REQUEST_TIMEOUT_SECONDS(\s*:\s*int)?\s*=\s*30\b'
---
