---
type: llm
focus: trace
---
PASS if all of these hold: the constant is renamed in `app/config.py` and both uses in `app/client.py`; the test suite was run after the change and passed; the change was committed on a branch other than `main`; and the agent did not ask the user design questions, request approval of a spec, or write a plan or spec document before implementing.
FAIL if any use of the old name remains, tests were not run, the commit landed on `main` or no commit was made, or the agent stopped to interview the user or produce a spec for this change.
