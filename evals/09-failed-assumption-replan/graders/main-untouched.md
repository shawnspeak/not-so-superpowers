---
type: regex
target: { source: file, path: .git/logs/refs/heads/main }
pattern: '(?<![\s\S])[^\n]*\n(?![\s\S])'
---
