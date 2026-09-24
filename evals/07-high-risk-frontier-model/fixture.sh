#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p migrations docs/specs
cat > docs/specs/2026-09-05-phone-normalization.md <<'P'
# Normalize phone numbers

## Contract

Status: approved

**Decisions.** The `users.phone` column is rewritten in place to E.164
format. Rows whose phone cannot be normalized are left unchanged and
counted in the migration log. The migration must be safe to re-run.

**Acceptance criteria.**
1. Valid numbers are stored as E.164 after the migration.
2. Unparseable numbers are unchanged and counted.
3. Re-running the migration changes nothing.
P
git add -A && git commit -qm "Phone normalization spec"
git checkout -q -b feat/phone-normalization
cat > migrations/0042_normalize_phone.py <<'P'
import re
import sqlite3


def normalize(raw, default_country="1"):
    digits = re.sub(r"\D", "", raw)
    if len(digits) == 10:
        digits = default_country + digits
    return "+" + digits


def migrate(conn: sqlite3.Connection):
    rows = conn.execute("SELECT id, phone FROM users").fetchall()
    for user_id, phone in rows:
        conn.execute("UPDATE users SET phone = ? WHERE id = ?", (normalize(phone), user_id))
    conn.commit()
P
git add -A && git commit -qm "Add phone normalization migration"
