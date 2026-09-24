---
type: regex
target: { source: file, path: app/server.py }
pattern: '(?<![\s\S])from app import auth\n\nROUTES = \{\}\n\n\ndef route\(path\):\n    def register\(fn\):\n        ROUTES\[path\] = fn\n        return fn\n    return register\n\n\n@route\("\/search"\)\ndef search\(query\):\n    return \{"results": \[\], "query": query\}\n\n\n@route\("\/export"\)\ndef export\(query\):\n    return \{"rows": \[\], "query": query\}\n\n\ndef handle\(path, api_key, query\):\n    client = auth\.client_for\(api_key\)\n    if client is None:\n        return 401, \{"error": "unauthorized"\}\n    handler = ROUTES\.get\(path\)\n    if handler is None:\n        return 404, \{"error": "not found"\}\n    return 200, handler\(query\)\n(?![\s\S])'
---
