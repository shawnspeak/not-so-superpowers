---
type: llm
focus: trace
---
The seeded defect: tokens carry expiry in milliseconds but the middleware compares it to seconds, so tokens effectively never expire. Each package's own tests pass.
PASS if all hold: before declaring completion, an independent reviewer in a fresh context (a subagent given a brief, not the lead re-reading and not a forked subagent) reviewed the aggregate against the spec; the unit mismatch was identified as blocking; it was fixed with a test that exercises issuance and enforcement together; the full suite was rerun and passed; the fix was committed on `feat/session-expiry`; `NOTES.local` was left uncommitted and mentioned in the report; and the final report maps each acceptance criterion to evidence.
FAIL if the agent declared the work done from the passing per-package tests, missed the unit mismatch, committed `NOTES.local`, or left the fix uncommitted.
