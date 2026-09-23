#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p app
touch app/__init__.py
cat > app/db.py <<'P'
import sqlite3


def connect():
    conn = sqlite3.connect(":memory:")
    conn.execute("CREATE TABLE orders (id INTEGER, customer TEXT, status TEXT)")
    return conn
P
cat > app/reports.py <<'P'
def orders_by_status(conn, status):
    return conn.execute(f"SELECT id FROM orders WHERE status = '{status}'").fetchall()


def orders_for_customer(conn, customer):
    return conn.execute(f"SELECT id FROM orders WHERE customer = '{customer}'").fetchall()
P
cat > app/admin.py <<'P'
def purge_customer(conn, customer):
    conn.execute(f"DELETE FROM orders WHERE customer = '{customer}'")
P
git add -A && git commit -qm "Order storage and admin"
git checkout -q -b feat/order-search
cat > app/search.py <<'P'
from app import db

DEFAULT_LIMIT = 20


def search_orders(conn, term, limit=None):
    limit = limit or DEFAULT_LIMIT
    rows = conn.execute(f"SELECT id, status FROM orders WHERE status LIKE '%{term}%'").fetchall()
    return rows[:limit]


def summarize(rows):
    total = len(rows)
    return {"count": total, "first": rows[0][0]}
P
git add -A && git commit -qm "Add order search"
