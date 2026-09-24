#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p auth tests docs/specs
touch auth/__init__.py tests/__init__.py
cat > docs/specs/2026-09-08-session-expiry.md <<'P'
# Session expiry

## Contract

Status: approved

**Goal.** Sessions expire after a configured lifetime; expired sessions are
rejected.

**Decisions.** `auth/tokens.py` issues tokens carrying an absolute expiry;
`auth/middleware.py` rejects a token whose expiry has passed.
`SESSION_LIFETIME_SECONDS = 3600`.

**Acceptance criteria.**
1. A token is accepted until its lifetime elapses and rejected afterwards.
2. `python3 -m unittest` passes.

## Plan

**Workspace:** branch `feat/session-expiry`.

**Mode:** coherent change.

- **P1 Token issuance** — tokens carry an absolute expiry. Done.
- **P2 Middleware enforcement** — expired tokens rejected. Done.
P
git add -A && git commit -qm "Session expiry spec"
git checkout -q -b feat/session-expiry
cat > auth/tokens.py <<'P'
import time

SESSION_LIFETIME_SECONDS = 3600


def issue(user_id, now=None):
    now = time.time() if now is None else now
    # expiry in milliseconds since epoch
    return {"user": user_id, "exp": int((now + SESSION_LIFETIME_SECONDS) * 1000)}
P
cat > tests/test_tokens.py <<'P'
import unittest

from auth import tokens


class TokensTest(unittest.TestCase):
    def test_expiry_is_lifetime_ahead_in_ms(self):
        self.assertEqual(tokens.issue("u", now=1000)["exp"], (1000 + 3600) * 1000)
P
git add -A && git commit -qm "Issue tokens with absolute expiry"
cat > auth/middleware.py <<'P'
import time


def is_valid(token, now=None):
    now = time.time() if now is None else now
    # exp is seconds since epoch
    return token["exp"] > now
P
cat > tests/test_middleware.py <<'P'
import unittest

from auth import middleware


class MiddlewareTest(unittest.TestCase):
    def test_rejects_expired(self):
        self.assertFalse(middleware.is_valid({"exp": 100}, now=200))

    def test_accepts_live(self):
        self.assertTrue(middleware.is_valid({"exp": 300}, now=200))
P
git add -A && git commit -qm "Reject expired tokens in middleware"
printf 'scratch notes, not part of the change\n' > NOTES.local
