---
name: reviewing-work
description: Use when a complete logical slice or the aggregate implementation needs review against an approved contract — at risk-appropriate boundaries and before consequential completion. Defines reviewer independence, the review brief, evaluation order, and finding labels.
---

# Reviewing Work

Review complete logical slices or the aggregate implementation — not every
microscopic step. A review earns its cost when the thing reviewed is a
coherent outcome whose defects would be expensive to discover later.

## Who reviews

At routine boundaries the reviewer may be a delegate, a peer model, or the
lead re-reading as a deliberate separate pass. Before **consequential
completion** — authentication, data migrations, public interfaces, anything
where a shipped defect is expensive — the reviewer must be independent of
the lead: a delegate or peer model, up-tier where warranted per
`delegating-workstreams`, that did not write the changes and works in a
fresh context that sees only the review brief. A delegate that inherits the
lead's conversation shares the author's blind spots and is not independent.

When no independent reviewer is available, the lead reviews as a separate
pass with the full brief, and the completion report states that the review
was not independent and why. Degraded independence is reported, never
silent.

## The review brief

Give the reviewer:

- the contract being reviewed against, carried as `delegating-workstreams`
  directs for every brief;
- the diff or artifacts;
- the verification evidence already collected;
- known tradeoffs and deliberate deviations, so they are not re-litigated;
- an explicit request to search for missing requirements and failure
  modes — what the implementation does not handle, not only whether what it
  does is well written.

A reviewer without the contract can only check style; that is not this
skill.

## Evaluation order

Spend attention in this order:

1. **Contract compliance** — is each acceptance criterion met, with
   evidence? Is anything silently unimplemented?
2. **Correctness and failure behavior** — bad input, partial failure,
   unexpected state.
3. **Regressions and compatibility** — existing behavior, callers, data.
4. **Security, concurrency, migration, operational risk** — where touched.
5. **Maintainability and fit** — repository conventions followed or
   fought; anything over-built beyond what the contract demands.
6. **Adequacy of verification** — do the checks establish the criteria, or
   merely pass?

The order structures attention, not the report: a category with nothing
material earns silence, not a section.

## Findings

Report every finding, labeled:

- **Blocking** — violates the contract, breaks correctness, or introduces a
  risk in categories 2–4. Resolved before completion, with the
  verification the fix affects rerun.
- **Material** — worth fixing, does not gate completion; the decision is
  recorded either way.
- **Minor** — noted briefly.

A finding without a concrete failure scenario or contract citation is an
**opinion**; report it labeled as such rather than dropping it. The
reviewer reports and labels; the lead decides what to act on, with the
labels in view. A reviewer's approval is input to the lead's completion
close-out in `leading-implementation`, never a substitute for it.
