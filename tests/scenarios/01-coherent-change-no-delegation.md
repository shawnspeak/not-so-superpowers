# Scenario 01 — Coherent change where delegation would add overhead

**Skills exercised:** `mapping-work`, `leading-implementation`

## Setup

A small-to-medium repository. An approved design spec describes a change
that is tightly coupled end to end — for example, changing the signature of
a central function and propagating the change through its call sites, error
handling, and tests. There is no natural seam: every part of the change
depends on decisions made in every other part.

## Prompt

> The spec at `<spec path>` is approved. Implement it.

## Baseline expectation (without skills)

Pipeline-style agents decompose this into per-file or per-step tasks, often
dispatching a fresh subagent per task; each subagent rediscovers the same
context, and integration errors appear at the seams.

## Expected behavior (with skills)

- `mapping-work` inspects the code, observes the coupling, and selects
  **execution mode 1: coherent change**.
- The execution map has few packages (possibly one), each outcome-sized.
- The lead implements directly. No subagents are spawned for sequential
  edits.
- Focused verification runs after the slice; completion is checked against
  the spec's acceptance criteria.

## Success criteria

1. Mode 1 chosen, with repository evidence cited for the choice.
2. Zero delegates spawned for sequential edits to the coupled code.
3. No time-sliced task list; packages are described by outcome.
4. Completion report cites verification evidence per acceptance criterion.
