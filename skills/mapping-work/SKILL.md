---
name: mapping-work
description: Use when an approved design spec exists and needs to become an execution strategy — after brainstorming produces a spec, before implementation starts. Chooses an execution mode from repository evidence and produces outcome-sized work packages.
---

# Mapping Work

Translate an approved design spec into a repository-grounded execution
strategy. The spec says what must be built; this skill decides how the work
is shaped. Repository evidence — not habit, not a fixed pipeline — determines
the topology.

## Validate before mapping

Before producing any map, inspect the code the spec touches. Confirm the
spec's technical assumptions: the interfaces it names exist, the seams it
relies on are real, the subsystems it partitions are actually separable. If a
material assumption is wrong, stop and resolve the conflict with the user
before mapping against it (see the spec's failure-behavior rules).

## Choose an execution mode

Pick exactly one, based on what inspection showed:

1. **Coherent change.** The work is one tightly coupled thread. The
   persistent lead implements directly, retaining full context. Delegation
   would add handoff cost without benefit.
2. **Uncertain or broad change.** The blast radius or the current state is
   unclear. Dispatch bounded delegates for **read-only reconnaissance**;
   the lead synthesizes their findings and implements.
3. **Naturally partitioned change.** The work splits along real seams with
   stable interfaces between them. Delegates own separate workstreams with
   non-overlapping file ownership; the lead owns shared interfaces and
   integration.

State the chosen mode and the evidence for it. The mode can change later if
implementation evidence contradicts it.

## Produce the execution map

Write a concise, living execution map — normally **three to eight
outcome-sized work packages** — and persist it as a file alongside the spec
(for example `docs/specs/YYYY-MM-DD-<topic>-execution-map.md`). The
implementation lead may be a different session or a different model; the map
must survive the handoff without the conversation that produced it. Each
package records:

- **Outcome** — the cohesive, independently verifiable result it delivers;
- **Dependencies** — which packages must land first;
- **Scope** — the likely files or subsystems it touches;
- **Constraints** — the architectural decisions from the spec that bind it;
- **Acceptance criteria** — how to tell it is done;
- **Verification** — the commands, tests, or checks that establish it;
- **Risks** — rollout, rollback, migration, or operational concerns, when
  applicable.

Size packages by outcome, never by duration. Do not decompose coherent work
into mechanical two-to-five-minute actions; a package that is "rename the
field, then update the callers, then fix the tests" is one package, not
three. Do not judge a package's quality by how long it takes.

The map is intentionally revisable. When implementation evidence contradicts
it — a seam that isn't there, a dependency that runs the other way — update
the map and note why. Only the spec is a durable contract; the map is a
coordination aid.

## Detailed implementation plan: conditional

A separate detailed implementation plan is **not** a default step. Recommend
one only when it has independent coordination value:

- execution spans multiple sessions and context will not survive;
- multiple owners or repositories must coordinate;
- rollout and rollback must be sequenced;
- interfaces must be agreed before parallel work starts;
- security, compliance, or operations risk demands a reviewable procedure.

Otherwise the spec plus the execution map is the complete planning artifact.

## Handoff

Hand the execution mode and map to `leading-implementation` by file path.
The lead owns the work from here; the map travels with it as a living
document.
