---
name: leading-implementation
description: Use when implementing an approved spec (design or fix) with an execution map — after mapping-work chooses an execution mode. One persistent lead carries the implementation end to end, retaining context, delegating selectively, and owning integration and the final report.
---

# Leading Implementation

One persistent lead is responsible for the implementation end to end. Context
learned while implementing — the real shape of the code, the surprises, the
constraints nobody wrote down — is the most valuable asset in the room. Do
not throw it away by fragmenting coupled work across fresh contexts.

## The lead's contract

- The **approved spec** is the product and architecture contract.
  What must be built does not change without going back to the user.
- The **execution map** is a living coordination aid. Reshape it freely when
  evidence demands; record why.
- Implement **coherent vertical slices** — a package's outcome, end to end —
  rather than horizontal layers or micro-steps. Keep tightly coupled work in
  your own context.
- Build the **simplest implementation that satisfies the acceptance
  criteria**. Abstractions, configurability, and defensive code the spec
  does not demand are scope creep, not diligence.
- Run **focused verification after each meaningful slice**: the package's
  own acceptance criteria and verification commands, not the whole world.
- **Replan when evidence invalidates an assumption.** If the evidence only
  changes sequencing, update the map and continue. If it contradicts a
  material spec assumption, stop that path and resolve the product or
  architecture conflict with the user.

## Confirm the workspace

Before the first change, confirm that the workspace the map names — the
branch or worktree the implementation lives on — matches reality, and create
it if it does not exist yet. If the map is silent, decide now and record the
decision in the map: follow the project's branching convention when one
exists; prefer a dedicated feature branch when the change is multi-file and
the session sits on the default branch; note the absence of version control
rather than inventing it. A different session resuming this work must be
able to find the work in progress from the map alone.

Check the workspace for pre-existing uncommitted changes at the same time.
They belong to the user: never stage them into a package commit, never
revert them, leave them as found. If any overlap files the map expects the
implementation to touch, resolve the conflict with the user before the
first change. From then on the tree is unambiguous, even to a resumed
session: an uncommitted change inside a package's scope is work in
progress; anything outside it is the user's.

## Commit at package boundaries

When the workspace is under version control, a verified package is a
commit. Once a package's focused verification passes, commit its changes
before moving on — one atomic, green checkpoint per package, written in the
project's commit style as read from its history rather than a style imposed
on it. Do not let verified work accumulate uncommitted across package
boundaries: committed checkpoints are what let a resumed session recover
the work.

A package commit is path-scoped. Stage only the files the package's work
actually touched, and inspect the staged diff before committing to confirm
it contains exactly that work — not pre-existing user changes, not a
concurrent delegate's partial work. Never stage the whole tree in a
workspace that holds anything besides the package's own changes.

History on the implementation workspace belongs to the lead. Verify a
delegate's returned work before committing it, and never commit failing or
unverified work as a completed package — if you must checkpoint
mid-package, label the commit explicitly as work in progress.

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

When a package's acceptance criteria are crisp and testable, consider making
tests the delegation contract: encode the criteria as failing tests before
any implementation exists, then hand "make these pass without modifying
them" to a lesser-tier delegate — the lowest-ambiguity brief there is, since
done is machine-checked, not argued. The full contract — who derives the
tests, the general-solution requirement, the overfitting inspection on
returned work — lives in `delegating-workstreams`.

## Review at boundaries

Invoke `reviewing-work` at risk-appropriate boundaries — after a complete
logical slice whose failure would be expensive, and always before
consequential completion. The consequential-completion review must be
independent of the lead — delegate it through `delegating-workstreams`
(up-tier where warranted); reviewing your own work does not gate
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
2. inspect the aggregate diff as a whole — integration seams, accidental
   inclusions, leftover scaffolding;
3. check every acceptance criterion in the spec against evidence;
4. report what changed, the evidence, and any remaining uncertainty —
   explicitly. Never infer success solely from a delegate's claim, a
   reviewer's approval, or a single passing command.

Completion leaves the implementation's changes fully committed: work that
exists only in an uncommitted working tree is not done. Pre-existing
changes that were in the workspace before work began are left untouched
and noted in the final report, so their presence is explained rather than
mistaken for stranded work.
