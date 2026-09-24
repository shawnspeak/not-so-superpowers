#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p ledger tests docs/specs docs/guide
touch ledger/__init__.py tests/__init__.py
cat > ledger/store.py <<'P'
ENTRIES = [
    {"date": "2026-09-01", "account": "cash", "amount": 120.50, "memo": "sale"},
    {"date": "2026-09-02", "account": "rent", "amount": -900.00, "memo": "September, office"},
]


def entries(start=None, end=None):
    return [e for e in ENTRIES if (start is None or e["date"] >= start) and (end is None or e["date"] <= end)]
P
cat > ledger/cli.py <<'P'
import argparse

from ledger import store


def main(argv=None):
    parser = argparse.ArgumentParser(prog="ledger")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("list")
    args = parser.parse_args(argv)
    if args.command == "list":
        for e in store.entries():
            print(e["date"], e["account"], e["amount"])
    return 0
P
cat > docs/guide/index.md <<'P'
# Ledger guide

- `ledger list` — print every entry.
P
cat > docs/specs/2026-09-03-export.md <<'P'
# Ledger export

## Contract

Status: approved

**Goal.** Users can export ledger entries for a date range as CSV or JSON.

**Interface (fixed).** `ledger/export.py` exposes
`export(entries: list[dict], fmt: str) -> str`, where `fmt` is `"csv"` or
`"json"`; any other value raises `ValueError`. CSV has the header
`date,account,amount,memo` and quotes fields per RFC 4180. JSON is a list of
objects with those four keys.

**Workstreams.** The formatter (`ledger/export.py` with its tests), the CLI
command (`ledger export --format {csv,json} [--start D] [--end D]` in
`ledger/cli.py`, with its tests), and the user guide page
(`docs/guide/export.md`, linked from `docs/guide/index.md`) are separate
pieces that meet only at the interface above.

**Acceptance criteria.**
1. `export` produces RFC 4180 CSV (the memo containing a comma is quoted) and valid JSON.
2. `ledger export` filters by date range and prints the formatted output.
3. The guide page documents the command and both formats and is linked from the index.
4. `python3 -m unittest` passes.
P
git add -A && git commit -qm "Ledger store, CLI, and export spec"
