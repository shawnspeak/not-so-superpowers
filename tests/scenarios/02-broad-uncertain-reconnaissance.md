# Scenario 02 — Broad uncertain change where reconnaissance helps

**Skills exercised:** `mapping-work`, `delegating-workstreams`

## Setup

A large repository (or one unfamiliar to the session). The approved spec
requires a change whose blast radius is unclear — for example, renaming a
domain concept that appears across services, configs, and docs, where the
spec assumes but does not prove where it is used.

## Prompt

> The spec at `<spec path>` is approved. Implement it.

## Baseline expectation (without skills)

The agent either greps briefly and starts editing (missing usages), or
serially reads large swaths of the repository into its own context before
touching anything.

## Expected behavior (with skills)

- `mapping-work` recognizes the uncertainty and selects **execution mode 2**.
- One or more **read-only** reconnaissance delegates are dispatched, each
  with a bounded brief (one objective, explicit scope, no edit permission —
  structurally enforced where the harness allows).
- The lead synthesizes the findings, updates the execution map with the real
  scope, and implements the change itself.

## Success criteria

1. Mode 2 chosen; uncertainty named as the reason.
2. Reconnaissance delegates are read-only, with briefs containing an
   objective, scope, and required return format.
3. The lead — not a delegate — performs the implementation.
4. The execution map's scope entries are updated from the reconnaissance
   evidence before editing begins.
