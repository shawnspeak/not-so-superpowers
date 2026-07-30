---
name: reviewing-work
description: Use when a complete logical slice or the aggregate implementation needs review against an approved spec — at risk-appropriate boundaries and before consequential completion. Defines the review brief, evaluation order, and completion evidence.
---

# Reviewing Work

Review complete logical slices or the aggregate implementation — not every
microscopic step. A review earns its cost when the thing reviewed is a
coherent outcome whose defects would be expensive to discover later.

## Who reviews

Match reviewer independence to consequence. At routine boundaries, the
reviewer may be a delegate, a peer model, or the lead re-reading with fresh
eyes. Before **consequential completion** — authentication, data migrations,
public APIs, anything where a shipped defect is expensive — the reviewer
must be independent of the lead: a delegate or peer model (up-tier where
warranted, per `delegating-workstreams`) that did not write the changes.
The author re-reading their own work is not independent, however fresh the
eyes.

When no independent reviewer is available — no subagents or peer model in
the harness — the lead falls back to reviewing as a deliberate separate
pass with the full brief below, and the completion report must state that
the review was not independent and why. Degraded independence is reported,
never silent.

## The review brief

Whoever reviews, give them:

- the approved spec (the contract being reviewed against);
- the relevant diff or artifacts;
- the verification evidence already collected (test output, command results);
- the known tradeoffs and deliberate deviations, so they are not re-litigated;
- an **explicit request to search for missing requirements and failure
  modes** — what the implementation does not handle, not just whether what
  it does is pretty.

A reviewer without the spec can only check style; that is not this skill.

## Evaluation order

Evaluate in this order, so scarce attention lands on what matters most:

1. **Acceptance-criteria and spec compliance** — is each criterion met, with
   evidence? Is anything in the spec silently unimplemented?
2. **Correctness and failure behavior** — does it work, and what happens on
   bad input, partial failure, or unexpected state?
3. **Regressions and compatibility** — what existing behavior, callers, or
   data does this change break?
4. **Security, concurrency, migration, and operational risks** — where the
   change touches them.
5. **Maintainability and fit** — does it follow the repository's
   conventions, or fight them? Is it over-built — abstractions, options,
   or defenses beyond what the spec demands?
6. **Adequacy of verification** — do the tests and checks actually establish
   the acceptance criteria, or just pass?

## Findings

Report every material finding, classified:

- **Blocking** — violates the spec, breaks correctness, or introduces a
  risk in category 2–4. Must be resolved and **reverified** before
  completion; rerun the focused verification the fix affects.
- **Material, non-blocking** — worth fixing, does not gate completion;
  record the decision either way.
- **Minor** — note briefly; do not let it crowd out the above.

A finding without a concrete failure scenario or spec citation is an
opinion; report it labeled as such rather than dropping it. The reviewer
reports and labels; deciding what to act on is the lead's filter, applied
with the labels in view — never the reviewer's, applied silently.

## After review: the lead closes out

Review does not end the work. The lead runs the completion sequence in
`leading-implementation` — full validation, aggregate diff, acceptance
criteria against evidence, explicit report — once, at completion, not
repeated after every review. A reviewer's approval is input to that
close-out, never a substitute for it.
