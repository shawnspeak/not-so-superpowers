---
type: llm
focus: { source: file, path: ledger/reconcile.py }
---
PASS if reconciliation compares balances per currency and takes its set of valid currencies from a single shared definition imported from another module (such as `ledger/validation.py`), rather than defining its own list.
FAIL if this file defines its own currency list or set, or does not check currencies at all.
