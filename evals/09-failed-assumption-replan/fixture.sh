#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p vendor/mailer notify tests docs/specs
touch notify/__init__.py tests/__init__.py vendor/__init__.py
cat > vendor/mailer/__init__.py <<'P'
"""Vendored mail client, version 1.4. Sends one message per call."""

__version__ = "1.4"
SENT = []


def send(to, subject, body):
    SENT.append((to, subject, body))
    return {"id": len(SENT)}
P
cat > notify/templates.py <<'P'
def render(name, context):
    raise NotImplementedError
P
cat > notify/digest.py <<'P'
P
cat > docs/specs/2026-09-07-digest.md <<'P'
# Weekly digest email

## Contract

Status: approved

**Goal.** Each user receives one weekly digest email summarizing activity.

**Decisions.**
- Digests are rendered from a `"digest"` template in `notify/templates.py`.
- Digests are sent with `vendor.mailer.send_batch(messages)`, the mail
  client's batch API, in a single call per weekly run, so the provider's
  per-call rate limit is never hit.

**Acceptance criteria.**
1. `render("digest", {"name": ..., "items": [...]})` returns the digest body.
2. `notify.digest.run(users)` sends every user's digest in one `send_batch` call.
3. `python3 -m unittest` passes.

## Plan

**Workspace:** branch `feat/digest`.

**Mode:** coherent change.

- **P1 Digest sending** — `notify/digest.py` builds messages and sends them
  with `send_batch`. Tests assert the rendered bodies.
- **P2 Digest template** — the `"digest"` template in `notify/templates.py`.
  Lands after P1.
P
git add -A && git commit -qm "Notify scaffolding and digest spec"
git checkout -q -b feat/digest
