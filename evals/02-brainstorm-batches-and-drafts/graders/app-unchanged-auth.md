---
type: regex
target: { source: file, path: app/auth.py }
pattern: '(?<![\s\S])API_KEYS = \{"key-alpha": "client-alpha", "key-beta": "client-beta"\}\n\n\ndef client_for\(api_key\):\n    """Return the client id for an API key, or None if the key is unknown\."""\n    return API_KEYS\.get\(api_key\)\n(?![\s\S])'
---
