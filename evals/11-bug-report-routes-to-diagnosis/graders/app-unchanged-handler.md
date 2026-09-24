---
type: regex
target: { source: file, path: app/handler.py }
pattern: '(?<![\s\S])from app import cache\n\n\ndef contact_card\(user_id\):\n    profile = cache\.get_profile\(user_id\)\n    return f"\{profile\[\x27name\x27\]\} <\{profile\[\x27email\x27\]\}>"\n(?![\s\S])'
---
