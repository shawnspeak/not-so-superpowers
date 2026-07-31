---
name: diagnosing
description: Use when the user brings a bug, regression, failure, or unexplained behavior whose cause is unknown — before designing or writing any fix. Guides evidence-driven root-cause investigation to a reproduction, a confirmed cause, and an approved fix spec.
---

# Diagnosing

Converge on the true cause of a reported problem through evidence, then turn
that understanding into an approved fix spec. The output is a durable written
contract for what must be fixed and why — it is not the fix itself.

`brainstorming` explores a design space where several answers are
legitimate; diagnosing converges on a single truth the system already
contains. Do not compare solutions until the cause is confirmed.

## Boundary

This skill is for problems brought as the task — a bug report, a regression,
a failure the user wants explained. Failures that surface mid-implementation
(a red verification, a delegate's broken result) stay with the lead under
`leading-implementation`, which already routes stuck or architecture-changing
diagnosis through delegation. A batch of findings arriving from an external
review enters through `triaging-findings`, which routes an individual
finding here when its symptom is real but its mechanism is unknown.

## Ground in what exists

Read the code paths the symptom implicates, the relevant configuration, the
logs and error output, and recent history before theorizing. For a
regression, version-control history is the sharpest instrument: find when
the behavior changed and what landed then (bisect when the repository
supports it). Never diagnose against an imagined codebase.

Clarify the symptom with the user one question at a time, favoring questions
whose answers discriminate between candidate causes: expected versus actual
behavior, when it started, environment, whether it reproduces reliably.

## Reproduce before theorizing

A diagnosis without a reproduction is a guess. Before proposing any cause:

- reproduce the failure yourself, recording the exact commands and inputs;
- minimize the reproduction — strip everything that does not change the
  outcome;
- if the failure cannot be reproduced, that becomes the investigation —
  what differs between the reporting environment and yours is now the
  question. If you must proceed on partial evidence, the spec says so
  explicitly.

## Investigate by hypothesis

Work one hypothesis at a time, stated before it is tested. Prefer the
experiment that could disprove the hypothesis fastest over the one that
would confirm it comfortably. Instrument, isolate, and bisect rather than
stare. Keep a short written trail of hypotheses rejected and the evidence
that killed each; the trail goes in the spec so the next reader does not
re-walk dead ends.

Investigation leaves the codebase unchanged: do not fix, refactor, or clean
up while in there. Temporary instrumentation is removed before the
investigation ends.
If the harness offers delegation, bounded read-only reconnaissance of
candidate subsystems may be dispatched per `delegating-workstreams`; its
absence never blocks — investigate sequentially.

## Confirm the root cause

A cause is confirmed when three things hold:

1. **Mechanism** — you can explain the chain from cause to observed symptom
   with no hand-waved link;
2. **Prediction** — toggling the cause toggles the symptom in the
   reproduction;
3. **History** — it explains why the problem appears when and where it
   does, and not elsewhere.

Distinguish the root cause from the place the symptom erupts; patching the
eruption site is how the bug comes back. If several contributing causes
exist, record all of them and say which ones the fix will address.

## Compare fix approaches

With the cause confirmed, present the plausible fixes with honest
tradeoffs — typically the minimal targeted fix versus a deeper correction of
the flaw that allowed the bug. Recommend one and say why; let the user
choose. A fix whose blast radius exceeds the bug's is a design effort:
recommend taking it through `brainstorming` as its own spec rather than
expanding this diagnosis.

## Write the fix spec

Write a durable spec to the project's documentation location (for example
`docs/specs/YYYY-MM-DD-<topic>.md` — the same convention as design specs).
It records:

- the symptom and its impact;
- the reproduction — exact steps, inputs, observed versus expected;
- the root cause with its evidence chain, plus rejected hypotheses in brief;
- the chosen fix approach and what was rejected;
- regression risk — what the fix could plausibly break;
- non-goals — nearby flaws deliberately left alone;
- acceptance criteria — at minimum, that the reproduction is encoded as a
  test that fails before the fix and passes after, wherever the codebase
  makes that feasible.

Writing that failing test is deliberately left to implementation, but the
spec must describe the reproduction precisely enough that encoding it
requires no rediscovery. Downstream, that test is the preferred delegation
contract.

Self-review the spec against the investigation for anything found but
omitted, anything asserted but never evidenced, and internal
contradictions. Then require the user to review the written document
itself. Conversational agreement is not approval; the file is the contract.

## Handoff

An approved fix spec transitions to `mapping-work`, exactly as a design
spec does. Most fixes will map to a coherent-change mode with few
packages — but that is mapping-work's decision, made against repository
evidence. If diagnosis uncovered multiple independent problems, split them
into separate specs, each approved on its own.

## Portability

Assume no specific debugger, tracer, or platform facility. Use what the
project offers — test runner, logging, bisect — when it helps, but the
method is tool-independent: reproduction, hypothesis, evidence. The absence
of any given tool must never block a diagnosis.
