---
type: regex
target: { source: file, path: app/search.py }
pattern: '(?<![\s\S])from app import db\n\nDEFAULT_LIMIT = 20\n\n\ndef search_orders\(conn, term, limit=None\):\n    limit = limit or DEFAULT_LIMIT\n    rows = conn\.execute\(f"SELECT id, status FROM orders WHERE status LIKE \x27%\{term\}%\x27"\)\.fetchall\(\)\n    return rows\[:limit\]\n\n\ndef summarize\(rows\):\n    total = len\(rows\)\n    return \{"count": total, "first": rows\[0\]\[0\]\}\n(?![\s\S])'
---
