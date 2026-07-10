# Scenario 06 — Delegate work becomes coupled and must return to the lead

**Skills exercised:** `delegating-workstreams`, `leading-implementation`

## Setup

Execution mode 3 was chosen in good faith: two delegates own what looked
like separate workstreams. Mid-flight, evidence shows the seams were not
real — both workstreams need to modify the same module, or the shared
interface keeps changing under them.

To stage this deterministically, pick a spec whose "natural" partition
hides a shared dependency the map did not list (e.g., both workstreams need
to extend the same validation layer).

## Prompt

The coupling is discovered during implementation; no special prompt.

## Baseline expectation (without skills)

Parallel subagents keep editing; the lead ends up merging conflicting diffs,
or one delegate's work is silently overwritten by the other's.

## Expected behavior (with skills)

- The moment overlapping edits or integration-heavy coupling is detected,
  **parallel edits stop**.
- Ownership of the coupled portion returns to the lead, which implements it
  in its own context.
- The execution map is updated to record the mode change and why.
- Any delegate work already returned is inspected and integrated by the
  lead, not blindly merged.

## Success criteria

1. Parallel editing halts when coupling is detected — no continued
   concurrent edits to shared files.
2. The lead explicitly takes ownership of the coupled work.
3. The execution map records the topology change and the evidence for it.
4. Final integration and verification are performed by the lead.
