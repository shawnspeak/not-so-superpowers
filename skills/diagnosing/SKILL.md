---
name: diagnosing
description: Use when the user brings a bug, regression, failure, or unexplained behavior whose cause is unknown — before designing or writing any fix. Guides evidence-driven root-cause investigation to a reproduction, a confirmed cause, and an approved fix contract. A defect whose cause-to-symptom mechanism is already in view — not merely its crash site — is a clear change for routing-work.
---

# Diagnosing

Converge on the true cause of a reported problem through evidence, then turn
that understanding into an approved fix contract. `brainstorming` explores a
design space where several answers are legitimate; diagnosing converges on
the single truth the system already contains. Do not compare fixes until
the cause is confirmed.

## Boundary

This skill is for problems brought as the task. Failures that surface
mid-implementation stay with the lead under `leading-implementation`. A
batch of findings from an external review enters through
`triaging-findings`, which routes a finding here when its symptom is real
but its mechanism is unknown.

## Evidence before questions

Read the code paths the symptom implicates, the configuration, the logs and
error output, and recent history before theorizing. For a regression,
version control is the sharpest instrument: find when the behavior changed
and what landed then — bisect when the repository supports it. Never
diagnose against an imagined codebase.

Ask the user only what the evidence cannot settle — expected versus actual
behavior, environment, frequency — batching the independent questions and
favoring those whose answers discriminate between candidate causes.

## Reproduce before theorizing

A diagnosis without a reproduction is a guess. Reproduce the failure
yourself, recording the exact commands and inputs, then minimize it — strip
everything that does not change the outcome. If it will not reproduce, that
becomes the investigation: what differs between the reporting environment
and yours. If you must proceed on partial evidence, the contract says so.

## Investigate by hypothesis

Work one hypothesis at a time, stated before it is tested. Prefer the
experiment that could disprove it fastest over the one that would confirm
it comfortably. Instrument, isolate, and bisect rather than stare. Keep a
short trail of rejected hypotheses and the evidence that killed each, so
the next reader does not re-walk dead ends.

Investigation leaves the codebase unchanged: no fixing, refactoring, or
cleanup, and temporary instrumentation is removed before it ends. Bounded
read-only reconnaissance of candidate subsystems may be delegated per
`delegating-workstreams`; without delegation, investigate sequentially.

## Confirm the root cause

A cause is confirmed when three things hold:

1. **Mechanism** — the chain from cause to symptom has no hand-waved link;
2. **Prediction** — toggling the cause toggles the symptom in the
   reproduction;
3. **History** — it explains why the problem appears when and where it
   does, and not elsewhere.

Distinguish the root cause from the place the symptom erupts; patching the
eruption site is how the bug comes back. When several causes contribute,
record all of them and say which the fix addresses.

## Choose the fix

Present the plausible fixes with honest tradeoffs — typically the minimal
targeted fix versus a deeper correction of the flaw that allowed the bug —
recommend one, and let the user choose. When one fix is plainly right,
present the cause, its evidence, and that fix together for a single
approval. A fix whose blast radius exceeds the bug's is design work: take
it through `brainstorming` as its own contract.

## The fix contract

Size it per `routing-work`. The contract records:

- the symptom and its impact;
- the reproduction — exact steps and inputs, observed versus expected,
  precise enough that encoding it as a test needs no rediscovery;
- the root cause with its evidence chain, and rejected hypotheses in brief;
- the chosen fix, and regression risk — what it could plausibly break;
- non-goals — nearby flaws deliberately left alone;
- acceptance criteria — at minimum, the reproduction encoded as the
  failing test `routing-work` requires of every defect fix.

Spend precision on the reproduction; elsewhere, cite evidence rather than
replaying the investigation. Apply the spec rules in `routing-work`.

## Handoff

An approved fix contract goes to `leading-implementation`. If diagnosis
uncovered several independent problems, split the contract per
`routing-work`.

## Portability

Assume no specific debugger, tracer, or platform facility. The method —
reproduction, hypothesis, evidence — is tool-independent, and the absence
of any given tool never blocks a diagnosis.
