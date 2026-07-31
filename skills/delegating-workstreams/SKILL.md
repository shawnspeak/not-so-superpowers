---
name: delegating-workstreams
description: Use when the implementation lead decides to hand a bounded objective to a subagent — reconnaissance, an isolated workstream, adversarial checks, or independent diagnosis. Defines delegate briefs, ownership rules, and capability-tier model selection.
---

# Delegating Workstreams

Use the harness's native subagent facilities only for bounded objectives that
benefit from a separate context. Delegation transfers work, not
accountability: the lead shapes the brief, inspects the returned evidence,
and integrates the result.

## Suitable objectives

- read-only repository reconnaissance;
- investigation of a contained subsystem;
- implementation of an isolated package behind a stable interface;
- implementation of a package against a pre-written failing test suite;
- high-volume mechanical sweeps (bulk renames, repetitive scaffolding,
  boilerplate) that need volume, not the lead's context;
- adversarial test derivation against stated acceptance criteria;
- verification or refutation of a single review finding against its stated
  failure scenario;
- independent diagnosis of a failure the lead is stuck on;
- review of a completed logical change.

Unsuitable: tiny sequential edits to code the lead already holds in context,
work whose interface is still being designed, and anything tightly coupled
to what the lead is concurrently editing.

## The delegate brief

Every brief contains, explicitly:

1. **One objective** — a single outcome, not a list of chores;
2. **Context** — only what is necessary, plus links to durable artifacts
   (the spec, the execution map entry) rather than restated prose;
3. **Ownership** — the exact files or subsystems the delegate may touch;
4. **Constraints and non-goals** — what must not change, what is out of scope;
5. **Acceptance criteria** — how the delegate knows it succeeded;
6. **Verification expectations** — what the delegate must run and report;
7. **Return format** — what the lead needs back (findings, diff summary,
   evidence), stated concretely;
8. **Edit permission** — whether the delegate may modify files at all.

A brief the assigned model cannot succeed at safely is a lead error, not a
delegate error. Shape the brief to the tier (below).

**Signal, not file dumps.** A reconnaissance delegate returns conclusions —
what was found, where, with paths and line references — never pasted file
contents, which hand the context cost back to the lead. Say so in the
return format.

**Tests as the contract.** When acceptance criteria are crisp and testable,
the strongest brief encodes them as failing tests before delegation: the
objective is "make these tests pass," the tests are the acceptance criteria,
and verification is running them. State explicitly that the delegate must
not modify the tests — a returned diff that edits them is a rejected result,
not a negotiation. Require a general solution in the same breath: the
delegate implements the logic the tests exercise, not code tailored to
their specific inputs, and reports a test it believes is wrong rather than
working around it. Inspect the returned diff for test-tailored shortcuts —
hardcoded expected values, special-cased inputs — before accepting it.
Derive the tests in the lead's context or delegate the derivation as its
own bounded objective, never to the delegate that will implement against
them.

## Ownership rules

- Never run parallel delegates with edit permission over overlapping files.
- Delegates that edit concurrently each work in an isolated workspace — a
  worktree or equivalent — so partial work never shares a tree with the
  lead's commits or another delegate's edits. Isolation is in addition to
  non-overlapping ownership, not a substitute for it. When isolation cannot
  be created, run editing delegates one at a time.
- Delegates do not write history on the implementation workspace. A
  delegate's result is its changes and evidence; the lead verifies the work
  and makes the commit.
- If workstreams turn out to be tightly coupled, or integration is becoming
  the dominant cost, **stop parallel edits and return ownership to the
  lead**. Absorbing two half-integrated diffs is worse than doing the work
  serially.

## Capability-tier selection

Run the persistent lead on a strong model — the strongest the budget allows.
Leading one tier below the frontier is a legitimate economy when design and
mapping already ran at the top tier: the lead then delegates **up-tier** for
the judgments that warrant it — adversarial final review, diagnosis that may
change the architecture, security calls — rather than carrying the frontier
model through the whole implementation. When the harness exposes model
selection for delegates, match tier to ambiguity and risk — not to how
important the overall project feels.

**Prefer a lesser (faster, cheaper) model** for bounded, low-ambiguity,
low-risk work:

- locating and summarizing: files, symbols, patterns, contained subsystems;
- running prescribed commands and collecting evidence;
- isolated changes behind an already-defined interface;
- implementation against a pre-written failing test suite it may not modify;
- routine tests written from explicit criteria;
- verifying a review finding whose failure scenario is mechanically
  checkable;
- mechanical consistency checks.

**Use a peer or frontier model** for:

- ambiguous or underspecified requirements;
- shared-interface design;
- broadly coupled changes;
- security, concurrency, migrations, destructive operations;
- diagnosis that may change the architecture;
- adversarial review and consequential final review.

Tighten the brief when assigning down-tier: sharper ownership, more explicit
criteria, less judgment required. If a delegate returns weak, incomplete, or
unverified work, tighten the brief, raise the tier, take the work back, or
change execution mode — in that order of preference.

If model selection is unavailable, keep the same task-shaping rules with the
model you have; the brief discipline is what makes delegation safe.

## Harness mechanics

This skill describes delegation by intent: start a bounded delegate, wait for
results, send a follow-up. For the concrete primitives:

- Claude Code: read `references/claude-code.md`
- Codex: read `references/codex.md`

If subagents, parallelism, or model selection are unavailable in the current
harness, do not force them: the lead executes the same work sequentially,
preserving the same ownership boundaries, evidence expectations, and review
points.
