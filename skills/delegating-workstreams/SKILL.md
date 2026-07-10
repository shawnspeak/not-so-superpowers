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
- adversarial test derivation against stated acceptance criteria;
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

## Ownership rules

- Never run parallel delegates with edit permission over overlapping files.
- If workstreams turn out to be tightly coupled, or integration is becoming
  the dominant cost, **stop parallel edits and return ownership to the
  lead**. Absorbing two half-integrated diffs is worse than doing the work
  serially.

## Capability-tier selection

Use the strongest available model for the persistent lead. When the harness
exposes model selection for delegates, match tier to ambiguity and risk —
not to how important the overall project feels.

**Prefer a lesser (faster, cheaper) model** for bounded, low-ambiguity,
low-risk work:

- locating files, symbols, and patterns;
- summarizing a contained subsystem;
- running prescribed commands and collecting output;
- isolated changes behind an already-defined interface;
- routine tests written from explicit criteria;
- mechanical consistency checks;
- evidence collection.

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
