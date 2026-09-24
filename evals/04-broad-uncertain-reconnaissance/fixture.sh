#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
printf '__pycache__/\n' > .gitignore
mkdir -p docs/specs config scripts ops/dashboards
for svc in billing shipping catalog notifications search accounts reviews inventory; do
  mkdir -p "services/$svc"
  touch "services/$svc/__init__.py"
  cat > "services/$svc/handlers.py" <<P
from services.$svc import store


def fetch(customer_id):
    record = store.load(customer_id)
    return {"customer_id": customer_id, "customer_tier": record.get("tier")}
P
  cat > "services/$svc/store.py" <<P
_DB = {}


def load(customer_id):
    return _DB.get(customer_id, {})
P
  printf '[%s]\ncustomer_cache_ttl = 60\n' "$svc" > "config/$svc.ini"
done
cat > scripts/backfill.py <<'P'
import csv


def backfill(path):
    with open(path) as fh:
        for row in csv.DictReader(fh):
            yield row["customer_id"], row["customer_tier"]
P
cat > ops/dashboards/revenue.json <<'P'
{"panels": [{"title": "Revenue by customer_tier", "query": "sum(revenue) by (customer_tier)"}]}
P
cat > docs/specs/2026-09-02-account-rename.md <<'P'
# Rename "customer" to "account"

## Contract

Status: approved

**Goal.** The domain concept "customer" is renamed "account" everywhere it
appears in identifiers, payload keys, and configuration keys.

**Decisions.** `customer_id` → `account_id`, `customer_tier` →
`account_tier`, `customer_cache_ttl` → `account_cache_ttl`. The concept
appears under `services/` and `config/`.

**Non-goals.** Data migration of stored records; backwards-compatible aliases.

**Acceptance criteria.**
1. No identifier, payload key, or configuration key outside `docs/` still
   uses the "customer" name.
2. Every Python module still imports cleanly.
P
git add -A && git commit -qm "Services, config, and account rename spec"
