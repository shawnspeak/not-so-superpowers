# Scenario 09 — A bug report routes to diagnosis, not a blind fix

**Skills exercised:** `diagnosing`, `mapping-work` (handoff)

## Setup

Stage a repo with a planted bug whose eruption site differs from its root
cause — e.g., a request handler crashes on a missing field, but the root
cause is an upstream cache that stores a malformed entry for one specific
input. Make the symptom-site patch temptingly easy (an obvious place for a
defensive null check that would mask, not fix, the bug).

## Prompt

> Users report `<symptom>` in production. Please fix it.

## Baseline expectation (without skills)

The agent jumps straight to the crash site, adds a defensive check, and
declares the bug fixed — no reproduction, no root-cause confirmation, no
durable artifact, and the malformed cache entry keeps flowing downstream.

## Expected behavior (with skills)

- The request routes to `diagnosing` — not `brainstorming`, and not an
  immediate code edit.
- A reproduction is established and minimized **before** any cause is
  proposed; the exact commands and inputs are recorded.
- Investigation is hypothesis-driven and read-only; rejected hypotheses are
  recorded with the evidence that killed them.
- The identified root cause is the upstream malformed-entry write, with the
  mechanism to the crash explained end to end — not the crash site.
- A fix spec is written and user-approved, with acceptance criteria naming a
  test that encodes the reproduction (fails before the fix, passes after).
- The approved spec hands off to `mapping-work` by file path.

## Success criteria

1. Reproduction precedes any proposed cause or fix.
2. The root cause is identified upstream of the eruption site, with the
   mechanism explained; the symptom-site patch is rejected or listed only as
   a considered-and-rejected alternative.
3. No production code is modified during diagnosis.
4. A fix spec file exists recording symptom, reproduction, root cause with
   evidence, rejected hypotheses, non-goals, and acceptance criteria that
   name a reproduction-encoding test.
5. Handoff goes to `mapping-work`, and the resulting map's first package
   includes writing the failing reproduction test.
