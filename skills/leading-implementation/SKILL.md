---
name: leading-implementation
description: Use when implementing an approved design spec with an execution map — after mapping-work chooses an execution mode. One persistent lead carries the implementation end to end, retaining context, delegating selectively, and owning integration and the final report.
---

# Leading Implementation

One persistent lead is responsible for the implementation end to end. Context
learned while implementing — the real shape of the code, the surprises, the
constraints nobody wrote down — is the most valuable asset in the room. Do
not throw it away by fragmenting coupled work across fresh contexts.

## The lead's contract

- The **approved design spec** is the product and architecture contract.
  What must be built does not change without going back to the user.
- The **execution map** is a living coordination aid. Reshape it freely when
  evidence demands; record why.
- Implement **coherent vertical slices** — a package's outcome, end to end —
  rather than horizontal layers or micro-steps. Keep tightly coupled work in
  your own context.
- Run **focused verification after each meaningful slice**: the package's
  own acceptance criteria and verification commands, not the whole world.
- **Replan when evidence invalidates an assumption.** If the evidence only
  changes sequencing, update the map and continue. If it contradicts a
  material spec assumption, stop that path and resolve the product or
  architecture conflict with the user.

## Delegation is selective

Delegate only through `delegating-workstreams`, and only when the work
genuinely branches or an independent judgment is valuable: separate
workstreams behind stable interfaces, read-only reconnaissance, adversarial
checks, independent diagnosis. Never delegate tiny sequential edits to the
code you are already holding in context — the handoff costs more than the
work. High-volume mechanical work is the exception at the other end of the
scale: bulk renames, repetitive test scaffolding, boilerplate generation, and
similar sweeps are worth handing to a lesser-tier delegate even when they do
not branch — the volume dwarfs the handoff cost and the work needs none of
your accumulated context. Delegation transfers work, not accountability: you
inspect what comes back and you integrate it.

## Review at boundaries

Invoke `reviewing-work` at risk-appropriate boundaries — after a complete
logical slice whose failure would be expensive, and always before
consequential completion. Do not request review of every microscopic step.

## Escalate orchestration when

- repeated attempts at the same problem keep failing;
- repository impact turns out much broader than the map assumed;
- test results invalidate your mental model of the system;
- a security-sensitive question remains uncertain;
- your context has degraded enough that an independent reconstruction by a
  fresh delegate would be more reliable than pushing on.

Escalating means changing the topology — dispatching reconnaissance, getting
an independent diagnosis, raising the review tier — not silently grinding.

## Completion

The lead owns shared interfaces, integration, aggregate verification, and
the final report. Before declaring done:

1. run the relevant full validation, not just per-slice checks;
2. inspect the aggregate diff as a whole;
3. check every acceptance criterion in the spec against evidence;
4. report what changed, the evidence, and any remaining uncertainty —
   explicitly. Never infer success solely from a delegate's claim or a
   single passing command.
