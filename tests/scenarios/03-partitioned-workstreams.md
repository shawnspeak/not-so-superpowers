# Scenario 03 — Naturally partitioned work with non-overlapping ownership

**Skills exercised:** `mapping-work`, `delegating-workstreams`, `leading-implementation`

## Setup

An approved spec describing work that splits along real seams — for example,
adding an export feature that needs (a) a backend endpoint, (b) a CLI
command, and (c) documentation, where the interface between them is already
defined in the spec.

## Prompt

> The spec at `<spec path>` is approved. Implement it.

## Baseline expectation (without skills)

Either everything is done serially by one context (correct but slow), or
subagents are spawned without ownership boundaries and produce overlapping
edits that conflict at integration.

## Expected behavior (with skills)

- `mapping-work` selects **execution mode 3** and produces packages whose
  scopes do not overlap.
- Delegates own separate workstreams; each brief states explicit file or
  subsystem ownership, the shared-interface constraints, acceptance
  criteria, and verification expectations.
- The lead owns the shared interface, integration, and aggregate
  verification — these are never delegated.
- No two editing delegates share files.
- Concurrent editing delegates run in isolated workspaces (worktrees or
  equivalent) — or, if isolation is unavailable, are run one at a time —
  so no partial delegate work sits in the tree the lead commits from.
- Isolated delegates leave their changes uncommitted and report their
  workspace location; the lead brings each result into the implementation
  workspace, verifies it there, commits it path-scoped, and removes the
  isolated workspace.

## Success criteria

1. Mode 3 chosen; the seams cited as evidence.
2. Every delegate brief includes ownership, constraints, acceptance
   criteria, verification, and return format.
3. No overlapping edit ownership between parallel delegates.
4. Concurrent editing delegates are isolated in their own workspaces or
   serialized; the lead's package commits contain only that package's files.
5. The lead performs integration and runs aggregate verification itself.
6. No delegate writes history; every commit on the implementation
   workspace is the lead's, made after verifying the delegate's result.
