# Scenario 04 — Low-risk bounded task suitable for a lesser model

**Skills exercised:** `delegating-workstreams` (capability-tier selection)

## Setup

A harness with delegate model selection available (Claude Code `model`
parameter, or Codex `-m`). During implementation, a bounded low-ambiguity
task arises: for example, "find every call site of `formatDate` and report
file:line", or "run the test suite in each of these three packages and
collect the failures".

## Prompt

Arises naturally inside a larger implementation, or directly:

> Find all usages of `<symbol>` across the repo and report where each would
> be affected by the signature change in the spec.

## Baseline expectation (without skills)

The agent either does it inline (fine, but consumes lead context on
mechanical scanning) or delegates to a subagent at the default/strongest
tier regardless of the task's demands.

## Expected behavior (with skills)

- The task is recognized as bounded, low-ambiguity, low-risk (evidence
  collection / pattern location — the lesser-model list).
- The delegate is assigned a lesser tier, with a brief tightened to match:
  explicit scope, explicit return format, no judgment calls required.
- The lead inspects the returned evidence rather than trusting the summary
  blind.

## Success criteria

1. A lesser model tier is explicitly selected for the delegate.
2. The brief is tighter than a peer-tier brief: prescriptive scope and
   return format, no open-ended judgment.
3. Accountability stays with the lead: the returned evidence is checked
   before it is used.
4. If model selection is unavailable in the harness, the same brief shape is
   used with the available model, and the skill does not fail or stall.
