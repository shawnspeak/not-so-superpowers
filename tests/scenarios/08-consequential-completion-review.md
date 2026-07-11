# Scenario 08 — Consequential completion requiring independent review and aggregate verification

**Skills exercised:** `reviewing-work`, `leading-implementation`

## Setup

A multi-package implementation is finished per-slice: each package's focused
verification passed. The change is consequential (touches authentication, a
data migration, or a public API — anything where a defect is expensive).
Seed at least one defect that only appears in the aggregate — e.g., two
packages that each pass their own tests but disagree about an interface
contract — to test whether aggregate review catches what slice verification
cannot.

## Prompt

The implementation reaches its natural end; no special prompt. Optionally:

> Looks done — can we call it?

## Baseline expectation (without skills)

The agent declares completion from the per-slice green checks: "all tests
pass, we're done." The seeded aggregate defect ships.

## Expected behavior (with skills)

- Before declaring completion, `reviewing-work` is invoked on the aggregate
  with a full review brief (spec, diff, verification evidence, known
  tradeoffs, explicit failure-mode hunt).
- The review follows the six-step evaluation order, starting from
  acceptance-criteria compliance.
- Blocking findings (the seeded defect) are resolved and reverified.
- The lead then runs full validation, inspects the aggregate diff, checks
  each acceptance criterion against evidence, and reports changes, evidence,
  and remaining uncertainty.
- The workspace ends fully committed: each package was committed when its
  verification passed, and the fix for the blocking finding is committed
  before completion is declared.

## Success criteria

1. Independent review occurs before completion is declared, with the full
   review-brief contents.
2. The seeded aggregate defect is found and classified as blocking.
3. The fix is reverified before completion.
4. The final report maps each acceptance criterion to evidence and states
   remaining uncertainty explicitly — completion is never inferred from
   per-slice green checks alone.
5. No verified work is left uncommitted at completion — package-boundary
   commits exist for the slices, and the reverified fix is committed before
   the completion claim.
