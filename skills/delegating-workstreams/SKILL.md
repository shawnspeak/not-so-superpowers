---
name: delegating-workstreams
description: Use when the implementation lead, a diagnosis, a triage, or a review decides to hand a bounded objective to a subagent — reconnaissance, an isolated workstream, a mechanical sweep, finding verification, adversarial checks, independent diagnosis, or review. Defines delegate briefs, ownership rules, and capability-tier model selection.
---

# Delegating Workstreams

Use the harness's subagent facilities only for bounded objectives that
benefit from a separate context. Delegation transfers work, not
accountability: the lead shapes the brief, inspects the returned evidence,
and integrates the result.

Invoking this stack, or approving a contract under it, is the user's
permission to use subagents: never skip a delegation these skills direct —
reviews included — because the user did not explicitly ask for one. When a
skill engaged on its own and the user did neither, ask once before the
first delegate. The permission covers bounded delegates the
lead briefs and integrates itself; it never authorizes a scripted
multi-agent orchestration run, which needs the user's own explicit request.
Once an objective is delegated, do not also pursue it yourself, and never
act on, report, or predict a delegate's result before it has returned.

## What to delegate, and to which tier

Match the delegate's tier to the objective's ambiguity and risk, not to how
important the project feels. Run the lead on the strongest model the budget
allows; leading one tier below the frontier is a legitimate economy when
the lead delegates **up** for the judgments that warrant it.

**Lesser (faster, cheaper) model** — bounded, low-ambiguity, low-risk:

- read-only reconnaissance — locating and summarizing files, symbols,
  patterns, contained subsystems;
- running prescribed commands and collecting evidence;
- isolated changes behind an already-defined interface;
- implementation against a pre-written failing test suite it may not
  modify;
- high-volume mechanical sweeps — bulk renames, repetitive scaffolding,
  boilerplate — that need volume, not the lead's context;
- routine tests written from explicit criteria, and mechanical consistency
  checks;
- verifying a review finding whose failure scenario is mechanically
  checkable.

**Peer or frontier model** — ambiguity, coupling, or consequence:

- ambiguous or underspecified requirements, and shared-interface design;
- broadly coupled changes;
- security, concurrency, migrations, destructive operations — including
  verifying security-flavored findings;
- adversarial test derivation against acceptance criteria;
- independent diagnosis of a failure the lead is stuck on, especially one
  that may change the architecture;
- adversarial review and consequential final review.

Never delegate small sequential edits to code the lead already holds, work
whose interface is still being designed, or anything tightly coupled to what
the lead is concurrently editing.

## The delegate brief

Every brief states, explicitly:

1. **One objective** — a single outcome, not a list of chores;
2. **Context** — only what is necessary: a path to the spec file when one
   exists rather than restated prose; at the light tier, the approved
   contract restated in full, since the delegate cannot see the
   conversation;
3. **Ownership** — the exact files or subsystems the delegate may touch, and
   whether it may modify files at all;
4. **Constraints and non-goals**;
5. **Acceptance criteria** — how the delegate knows it succeeded;
6. **Verification** — what it must run and report;
7. **Return format** — conclusions with paths and line references, the
   diff summary, the evidence; never pasted file contents, which hand the
   context cost back to the lead.

A brief the assigned model cannot succeed at safely is a lead error. Tighten
it when assigning down-tier: sharper ownership, more explicit criteria, less
judgment. When a delegate returns weak or unverified work, tighten the
brief, raise the tier, take the work back, or change execution mode — in
that order of preference.

## Tests as the contract

When acceptance criteria are crisp and testable, the strongest brief
encodes them as failing tests before delegation: the objective is "make
these pass," and verification is running them. The delegate must not
modify the tests — a diff that edits them is a rejected result. Require a
general solution in the same breath: implement the logic the tests
exercise, not code fitted to their inputs, and report a test believed wrong
rather than working around it. Inspect the returned diff for test-tailored
shortcuts — hardcoded expected values, special-cased inputs — before
accepting it. The tests are derived in the lead's context or by a separate
delegate, never by the one that implements against them.

## Ownership rules

- Never run parallel delegates with edit permission over overlapping files.
- Delegates that edit concurrently each work in an isolated workspace — a
  worktree or equivalent — in addition to non-overlapping ownership. When
  isolation is unavailable, run editing delegates one at a time.
- Delegates do not write history on the implementation workspace. An
  isolated delegate leaves its changes uncommitted and reports where its
  workspace is; the lead brings the changes over, verifies them, commits
  path-scoped, and removes the isolated workspace.
- If workstreams turn out tightly coupled, or integration becomes the
  dominant cost, **stop parallel edits and return ownership to the lead**.
  Absorbing two half-integrated diffs is worse than serial work.

## Harness mechanics

For the concrete primitives:

- Claude Code: read `references/claude-code.md`
- Codex: read `references/codex.md`

If subagents, parallelism, or model selection are unavailable, do not force
them: the lead does the same work sequentially with the same ownership,
evidence, and review boundaries. The brief discipline, not the facility, is
what makes delegation safe.
