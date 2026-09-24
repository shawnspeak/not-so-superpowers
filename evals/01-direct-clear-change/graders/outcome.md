---
type: llm
focus: last_message
---
PASS if the response reports the rename as done and verified by a passing test run, without asking the user design questions or asking them to approve a spec, contract, or plan.
FAIL if the response asks the user to answer questions or approve anything before the change is made, or reports the change as unverified.
