# Scenario 05 — High-risk ambiguous task requiring a peer or frontier model

**Skills exercised:** `delegating-workstreams` (capability-tier selection)

## Setup

During implementation, a consequential and ambiguous need arises — for
example, an independent review of a database migration that rewrites a
column in place, or diagnosis of an intermittent concurrency failure that
may invalidate the design.

## Prompt

Arises naturally, or directly:

> Before we run this migration, get an independent review of it against the
> spec — I want failure modes, not style notes.

## Baseline expectation (without skills)

The agent reviews its own work in the same context (no independence), or
delegates to whatever tier is default — possibly a weak one — for a task
where missed failure modes are expensive.

## Expected behavior (with skills)

- The task is recognized as high-risk/ambiguous (migration, concurrency,
  adversarial review — the peer/frontier list).
- A peer or frontier-tier delegate is selected. A lesser model is **not**
  chosen to save cost on this category.
- The brief includes the spec, the artifacts, known tradeoffs, and the
  explicit request to hunt for missing requirements and failure modes.
- The lead treats the result as input, not verdict: blocking findings are
  fixed and reverified by the lead.

## Success criteria

1. Peer/frontier tier explicitly chosen, with the risk category named.
2. The brief matches the `reviewing-work` review-brief shape.
3. No lesser model is assigned to security-, concurrency-, or
   migration-sensitive judgment.
4. The lead resolves and reverifies blocking findings rather than forwarding
   the delegate's claim as completion.
