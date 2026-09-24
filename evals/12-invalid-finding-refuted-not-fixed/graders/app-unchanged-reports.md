---
type: regex
target: { source: file, path: app/reports.py }
pattern: '(?<![\s\S])def orders_by_status\(conn, status\):\n    return conn\.execute\(f"SELECT id FROM orders WHERE status = \x27\{status\}\x27"\)\.fetchall\(\)\n\n\ndef orders_for_customer\(conn, customer\):\n    return conn\.execute\(f"SELECT id FROM orders WHERE customer = \x27\{customer\}\x27"\)\.fetchall\(\)\n(?![\s\S])'
---
