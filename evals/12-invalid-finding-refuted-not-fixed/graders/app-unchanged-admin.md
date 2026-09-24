---
type: regex
target: { source: file, path: app/admin.py }
pattern: '(?<![\s\S])def purge_customer\(conn, customer\):\n    conn\.execute\(f"DELETE FROM orders WHERE customer = \x27\{customer\}\x27"\)\n(?![\s\S])'
---
