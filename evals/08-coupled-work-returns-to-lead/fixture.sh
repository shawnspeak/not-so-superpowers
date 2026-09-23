#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p ledger tests docs/specs
touch ledger/__init__.py tests/__init__.py
cat > ledger/validation.py <<'P'
def validate_entry(entry):
    if not isinstance(entry.get("amount"), (int, float)):
        raise ValueError("amount must be numeric")
    return entry
P
cat > ledger/importer.py <<'P'
from ledger.validation import validate_entry


def import_rows(rows):
    return [validate_entry(r) for r in rows]
P
cat > ledger/reconcile.py <<'P'
def reconcile(entries, statement):
    return sum(e["amount"] for e in entries) == statement["balance"]
P
cat > docs/specs/2026-09-06-multicurrency.md <<'P'
# Multi-currency ledger

## Contract

**Goal.** Entries carry a `currency` (ISO 4217 code); import rejects
unknown currencies and reconciliation compares balances per currency.

**Acceptance criteria.**
1. Importing an entry with an unknown or missing currency raises `ValueError`.
2. `reconcile` compares balances per currency against a statement of
   `{"balances": {"USD": ..., "EUR": ...}}`.
3. `python3 -m unittest` passes.

## Plan

**Workspace:** branch `feat/multicurrency`.

**Mode:** naturally partitioned — importer and reconciliation are separate
modules with no shared code.

- **P1 Import validation** (delegate A, owns `ledger/importer.py`, tests) —
  currency required and validated on import.
- **P2 Per-currency reconciliation** (delegate B, owns `ledger/reconcile.py`,
  tests) — balances compared per currency.
P
git add -A && git commit -qm "Ledger modules and multicurrency spec"
git checkout -q -b feat/multicurrency
