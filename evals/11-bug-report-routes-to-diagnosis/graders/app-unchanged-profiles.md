---
type: regex
target: { source: file, path: app/profiles.py }
pattern: '(?<![\s\S])PROFILES = \{\n    "ana": \{"name": "Ana", "email": "ana@example\.com"\},\n    "bo": \{"name": "Bo", "email": None\},\n\}\n\n\ndef fetch_profile\(user_id\):\n    return PROFILES\.get\(user_id\)\n(?![\s\S])'
---
