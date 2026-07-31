# Scenario 10 — Review findings are triaged on evidence, not obeyed

**Skills exercised:** `triaging-findings`, `mapping-work` (handoff)

## Setup

Stage a repo with a small completed change and a review of it containing a
mixed batch of findings:

- one real, blocking defect;
- one plausible-sounding finding that is **invalid** — e.g. it claims a
  null dereference on a path where the value is provably always set;
- one valid finding that is a single instance of a pattern repeated
  elsewhere — e.g. the same unescaped interpolation exists at two other
  call sites the reviewer did not flag;
- one stylistic comment with no failure scenario.

Deliver the findings as a pasted list or a PR review thread.

## Prompt

> Here's the review feedback on `<change>`. Please address it.

## Baseline expectation (without skills)

The agent works the comments top to bottom and "fixes" all of them —
including the invalid finding, adding defensive code for a failure that
cannot occur — misses the sibling instances of the repeated pattern, never
pushes back on anything, and produces no durable artifact tying findings to
outcomes.

## Expected behavior (with skills)

- The request routes to `triaging-findings` — not straight to code edits.
- Every finding is inventoried, restated as claim + location + failure
  scenario, and classified; the no-scenario stylistic comment is labeled an
  opinion.
- Each finding is verified **before** any fix: the invalid finding is
  refuted with cited evidence and dispositioned as a decline with a drafted
  reply — not fixed.
- The repeated-pattern finding triggers a sweep that surfaces the sibling
  instances as new findings, verified like the rest.
- The codebase is unchanged during triage.
- A triage spec is written and user-approved: per-finding verdicts with
  evidence, dispositions with rationale, drafted replies, and acceptance
  criteria for the fixes (naming failing tests where feasible).
- The approved spec hands off to `mapping-work` by file path.

## Success criteria

1. No finding is fixed before it is verified; each verdict cites evidence.
2. The invalid finding is refuted and declined with a drafted
   evidence-backed reply — no defensive code is added for it.
3. The sweep finds the sibling instances the reviewer missed, and they
   enter the triage as findings in their own right.
4. No production code is modified during triage.
5. A triage spec file exists with the full inventory, verdicts,
   dispositions, replies, and fix acceptance criteria; handoff goes to
   `mapping-work`.
