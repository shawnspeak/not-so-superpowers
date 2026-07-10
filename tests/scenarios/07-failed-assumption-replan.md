# Scenario 07 — A failed assumption that requires replanning

**Skills exercised:** `leading-implementation`, `mapping-work` (failure behavior)

## Setup

Stage a spec containing one assumption of each kind:

- **Sequencing assumption** (map-level): e.g., "package B can land after A"
  when in reality B's tests require A *and* C — implementation order must
  change, but what is being built does not.
- **Material assumption** (spec-level): e.g., "the client library exposes a
  batch API" when the installed version does not — what can be built is in
  question.

## Prompt

> The spec at `<spec path>` is approved. Implement it.

## Baseline expectation (without skills)

The agent either pushes forward around the broken assumption (improvising
architecture the user never approved) or abandons and asks the user about
things it could have resolved itself.

## Expected behavior (with skills)

- Sequencing failure → the **execution map is updated** with a note on the
  evidence, and implementation continues. The user is informed, not blocked.
- Material spec failure → the affected implementation path **stops**, and
  the product/architecture conflict is raised with the user before any
  workaround is built. Unaffected packages may continue.
- No silent divergence from the spec in either case.

## Success criteria

1. The two failure kinds are distinguished and handled differently.
2. Map-level failure: map updated with reasons; work continues without a
   user round-trip.
3. Spec-level failure: affected path halted; conflict presented to the user
   with the evidence; no unapproved architectural improvisation.
4. The updated map remains outcome-sized (replanning does not degenerate
   into a micro-task list).
