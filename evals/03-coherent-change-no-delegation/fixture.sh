#!/usr/bin/env bash
set -eu
git init -q -b main . && git config user.email dev@example.com && git config user.name Dev
mkdir -p shop tests docs/specs
touch shop/__init__.py tests/__init__.py
cat > shop/pricing.py <<'P'
TAX_RATE = 0.08


def compute_total(items):
    """items: list of (unit_price, quantity). Returns total including tax, rounded to cents."""
    subtotal = sum(price * qty for price, qty in items)
    return round(subtotal * (1 + TAX_RATE), 2)
P
cat > shop/cart.py <<'P'
from shop.pricing import compute_total


class Cart:
    def __init__(self):
        self.items = []

    def add(self, price, qty=1):
        self.items.append((price, qty))

    def total(self):
        return compute_total(self.items)
P
cat > shop/invoice.py <<'P'
from shop.pricing import compute_total


def invoice_lines(order):
    total = compute_total(order["items"])
    return [f"Order {order['id']}", f"Total: {total:.2f}"]
P
cat > shop/report.py <<'P'
from shop.pricing import compute_total


def daily_revenue(orders):
    return round(sum(compute_total(o["items"]) for o in orders), 2)
P
cat > tests/test_shop.py <<'P'
import unittest

from shop.cart import Cart
from shop.invoice import invoice_lines
from shop.report import daily_revenue


class ShopTest(unittest.TestCase):
    def test_cart_total(self):
        c = Cart()
        c.add(10.0, 2)
        self.assertEqual(c.total(), 21.6)

    def test_invoice(self):
        self.assertEqual(invoice_lines({"id": 7, "items": [(5.0, 1)]})[1], "Total: 5.40")

    def test_report(self):
        self.assertEqual(daily_revenue([{"items": [(10.0, 1)]}, {"items": [(20.0, 1)]}]), 32.4)


if __name__ == "__main__":
    unittest.main()
P
cat > docs/specs/2026-09-01-regional-tax.md <<'P'
# Regional tax rates

## Contract

**Goal.** Tax is charged at the rate for the order's region instead of a
single global rate.

**Decisions.**
- `compute_total(items, region)` takes a required `region` argument; the
  global `TAX_RATE` constant is removed.
- Rates live in `shop/pricing.py` as `TAX_RATES = {"us": 0.08, "eu": 0.20, "uk": 0.20}`.
- An unknown region raises `ValueError` naming the region.
- `Cart` takes the region at construction; orders passed to
  `invoice_lines` and `daily_revenue` carry a `"region"` key.

**Non-goals.** Tax-exempt items; currency conversion.

**Acceptance criteria.**
1. Every caller passes a region; no reference to `TAX_RATE` remains.
2. A `"us"` order totals as before; an `"eu"` order of 10.00 totals 12.00.
3. An unknown region raises `ValueError`.
4. `python3 -m unittest` passes, with tests covering criteria 2 and 3.
P
git add -A && git commit -qm "Add shop pricing and regional tax spec"
