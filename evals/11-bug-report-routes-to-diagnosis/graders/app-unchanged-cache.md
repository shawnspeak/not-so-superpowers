---
type: regex
target: { source: file, path: app/cache.py }
pattern: '(?<![\s\S])from app import profiles\n\n_CACHE = \{\}\n\n\ndef get_profile\(user_id\):\n    if user_id not in _CACHE:\n        profile = profiles\.fetch_profile\(user_id\)\n        # store a compact entry: drop empty fields\n        _CACHE\[user_id\] = \{k: v for k, v in profile\.items\(\) if v\}\n    return _CACHE\[user_id\]\n(?![\s\S])'
---
