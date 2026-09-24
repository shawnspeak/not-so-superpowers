#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p app
cat > app/__init__.py <<'P'
P
cat > app/auth.py <<'P'
API_KEYS = {"key-alpha": "client-alpha", "key-beta": "client-beta"}


def client_for(api_key):
    """Return the client id for an API key, or None if the key is unknown."""
    return API_KEYS.get(api_key)
P
cat > app/server.py <<'P'
from app import auth

ROUTES = {}


def route(path):
    def register(fn):
        ROUTES[path] = fn
        return fn
    return register


@route("/search")
def search(query):
    return {"results": [], "query": query}


@route("/export")
def export(query):
    return {"rows": [], "query": query}


def handle(path, api_key, query):
    client = auth.client_for(api_key)
    if client is None:
        return 401, {"error": "unauthorized"}
    handler = ROUTES.get(path)
    if handler is None:
        return 404, {"error": "not found"}
    return 200, handler(query)
P
cat > README.md <<'P'
# search-api

Single-process API server. Deployed as 4 worker processes behind a load balancer.
P
git add -A && git commit -qm "Initial API server"
