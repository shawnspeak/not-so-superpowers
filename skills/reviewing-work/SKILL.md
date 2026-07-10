---
name: reviewing-work
description: Use when a complete logical slice or the aggregate implementation needs review against an approved spec — at risk-appropriate boundaries and before consequential completion. Defines the review brief, evaluation order, and completion evidence.
---

# Reviewing Work

Review complete logical slices or the aggregate implementation — not every
microscopic step. A review earns its cost when the thing reviewed is a
coherent outcome whose defects would be expensive to discover later.

## The review brief

Whether the reviewer is a delegate, a peer model, or the lead re-reading
with fresh eyes, give it:

- the approved design spec (the contract being reviewed against);
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
   conventions, or fight them?
6. **Adequacy of verification** — do the tests and checks actually establish
   the acceptance criteria, or just pass?

## Findings

Classify material findings clearly:

- **Blocking** — violates the spec, breaks correctness, or introduces a
  risk in category 2–4. Must be resolved and **reverified** before
  completion; rerun the focused verification the fix affects.
- **Material, non-blocking** — worth fixing, does not gate completion;
  record the decision either way.
- **Minor** — note briefly or drop; do not let it crowd out the above.

A finding without a concrete failure scenario or spec citation is an
opinion; label it as such or omit it.

## After review: the lead closes out

Review does not end the work. The lead then:

1. runs the relevant **full validation**, not only the checks the review
   touched;
2. inspects the **aggregate diff** as a whole — integration seams,
   accidental inclusions, leftover scaffolding;
3. checks **each acceptance criterion** in the spec against evidence;
4. reports what changed, the evidence for it, and remaining uncertainty
   explicitly.

Verification output and the aggregate diff are evidence, not substitutes
for checking the acceptance criteria. Never infer success solely from a
delegate's claim, a reviewer's approval, or a single passing command.
