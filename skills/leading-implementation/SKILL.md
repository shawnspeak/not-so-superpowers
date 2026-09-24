---
name: leading-implementation
description: Use when implementing approved work — an approved contract from brainstorming, diagnosing, or triaging-findings, or a clear change routed directly. One persistent lead plans the work against the repository, implements it end to end, delegates selectively, and owns integration, commits, and the final report.
---

# Leading Implementation

One persistent lead is responsible for the implementation end to end.
Context learned while implementing — the real shape of the code, the
surprises, the constraints nobody wrote down — is the most valuable asset
in the room. Do not throw it away by fragmenting coupled work across fresh
contexts.

## The lead's contract

- The approved **contract** says what must be built. It does not change
  without going back to the user.
- The **plan** is a coordination aid. Reshape it freely when evidence
  demands, and record why; at the full tier the revised spec file rides the
  next commit, so the committed Plan never lags the one the lead works from.
- Build the **simplest implementation that satisfies the acceptance
  criteria**. Abstractions, configurability, and defenses the contract does
  not demand are scope creep, not diligence.
- Implement **coherent vertical slices**, each verified by its own
  acceptance criteria and commands — not horizontal layers or micro-steps.
- **Replan when evidence invalidates an assumption.** Evidence that only
  changes sequencing updates the plan and is reported to the user without
  waiting for approval. Evidence that contradicts a material contract
  assumption stops that path until the conflict is resolved with the user.

## Plan against the repository

If the work arrived without a route or tier, classify and size it per
`routing-work` first and follow its route: only a clear change or an
approved contract is implemented here.

Before the first change, confirm the contract is approved — its spec file
marks it approved, or the user approved it in this conversation; a draft
goes back to the user — then inspect the code the contract touches and
confirm its technical assumptions: the interfaces it names exist, the
seams it relies on are real, the subsystems it partitions are separable. A
wrong material assumption goes back to the user before any work is planned
against it.

If the spec file already has a Plan, this is a resumed session: run the
same check against the packages that remain and confirm the workspace the
Plan names still exists — if it is gone or already merged, ask the user
before recreating it. See which packages its history already holds and
continue from there rather than replanning from scratch.

At the direct tier the plan is the one-line statement of change and
verification, and the whole change is one package; the rest of this
section applies to light and full work.

Choose one execution mode from what inspection showed, and state the
evidence for it:

1. **Coherent change** — one tightly coupled thread. Implement directly;
   delegation would add handoff cost without benefit.
2. **Uncertain or broad change** — the blast radius or current state is
   unclear. Dispatch read-only reconnaissance, correct the plan's scope
   from its findings, then implement.
3. **Naturally partitioned change** — real seams with stable interfaces.
   Delegates own separate workstreams with non-overlapping files; the lead
   owns shared interfaces and integration.

Break the work into outcome-sized **packages** — usually one to eight. A
package is an independently verifiable, independently committable result,
never a timed micro-step: "rename the field, update the callers, fix the
tests" is one package. Each records its outcome, the contract decisions
that bind it, dependencies, likely scope, acceptance criteria,
verification commands, and risks where they apply.

The tier decides where the plan lives:

- **light** — the plan stays in the lead's working context. The moment
  the work must outlive the conversation, per `routing-work`, promote the
  contract to a file and write its Plan as at the full tier;
- **full** — the plan is written into the spec file's Plan section before
  the first change, opening with a `Workspace:` line that names the branch
  or worktree decided below, so a different session can resume from the
  file alone.

The plan records decisions that drive the work, never workspace state
snapshots. A separate detailed procedure is warranted only when it has
independent coordination value: multiple owners or repositories, sequenced
rollout and rollback, interfaces to agree before parallel work, or a
security, compliance, or operations risk that demands a reviewable
procedure.

## Confirm the workspace

Before the first change, settle the workspace — the branch or worktree the
implementation lives on. Follow the project's branching convention when one
exists. Otherwise, stay on the current branch only when it already belongs
to this work; from the default branch or a branch holding unrelated work,
create a dedicated feature branch. Commits never land on the default branch
unless the project's convention puts them there. Where there is no version
control, say so rather than inventing it.

Check for pre-existing uncommitted changes at the same time. They belong to
the user: never stage them, never revert them. The spec file this stack
wrote is the exception — it is the work's own artifact, and the lead
commits it with its Plan as the first commit on the workspace, or as the
next commit when it is promoted mid-work. If any user
change overlaps files the plan expects to touch, resolve that with the user
before the first change.
From then on, an uncommitted change inside a package's scope is work in
progress; anything outside it is the user's.

## Commit at package boundaries

Under version control, a verified package is a commit. Once a package's
verification passes, commit it before moving on, in the project's commit
style as read from its history. Implementing approved work under this skill
is the user's request for these package commits when the user invoked the
stack or approved a contract under it — do not stop to ask before each one.
At the direct tier, if the stack engaged on its own and the user did
neither, ask once before the first commit. Pushing, merging, and rewriting
history remain the user's call.

Commits are path-scoped: stage only the files the package touched — plus
the spec file when its Plan changed since it was last committed — and
inspect the staged diff to confirm it holds exactly that work — no user
changes, no delegate's partial work. Only the lead writes history on the
implementation workspace. Never commit failing or unverified work as a
completed package; a mid-package checkpoint is labeled work in progress.

## Delegate selectively

Delegate only through `delegating-workstreams`, and only when the work
genuinely branches, needs volume rather than your context, or benefits from
an independent judgment. When a
package's criteria are crisp and testable, failing tests written first are
the strongest delegation contract; its rules live in
`delegating-workstreams`.

## Review at boundaries

Invoke `reviewing-work` after a complete slice whose failure would be
expensive, and always before consequential completion, where the reviewer
must be independent of the lead. Skip review for low-risk direct changes.
Do not review every microscopic step.

## Escalate when

- repeated attempts at the same problem keep failing;
- repository impact is much broader than planned;
- test results invalidate your model of the system;
- a security-sensitive question remains uncertain;
- your context has degraded enough that a fresh delegate's independent
  reconstruction would be more reliable.

Escalating changes the topology — reconnaissance, an independent diagnosis,
an up-tier reviewer, a higher process tier for the whole work — rather than
silently grinding.

## Completion

The lead owns shared interfaces, integration, aggregate verification, and
the final report. Before declaring done, once:

1. run the relevant full validation, not just per-slice checks;
2. inspect the aggregate diff — integration seams, accidental inclusions,
   leftover scaffolding;
3. check every acceptance criterion against evidence;
4. report what changed, the evidence, and remaining uncertainty, in brief —
   citing evidence rather than replaying it. Never infer success from a
   delegate's claim, a reviewer's approval, or a single passing command.

Completion leaves the implementation's changes fully committed. Pre-existing
user changes are left untouched and noted in the report, so their presence
is explained rather than mistaken for stranded work.
