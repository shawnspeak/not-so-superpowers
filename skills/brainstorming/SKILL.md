---
name: brainstorming
description: Use when the user brings an idea, feature request, or problem that needs design before implementation — before writing code for any non-trivial change. For a bug or failure whose cause is unknown, use diagnosing first. Guides collaborative design through clarifying questions, alternative comparison, and an approved written spec.
---

# Brainstorming

Turn a rough idea into an approved design spec through collaboration, not
interrogation or a premature jump to solutions. The output is a durable written
contract for what must be built. It is not an implementation plan.

## Before proposing anything

Inspect the current project first. Read the relevant code, existing docs,
recent history, and configuration. Ground every question and proposal in what
actually exists. Never design against an imagined codebase.

## Clarify the problem

Ask questions **one at a time** and wait for each answer. Do not batch a
questionnaire. Cover, in whatever order the conversation makes natural:

- purpose — what problem this solves and for whom;
- constraints — technical, product, compatibility, timeline;
- non-goals — what is explicitly out of scope;
- success criteria — how the user will know it worked.

Stop asking when new answers stop changing the design. Prefer questions whose
answers change what you would build over questions that merely fill in a
template.

## Compare approaches

Present two or three plausible approaches with honest tradeoffs. Recommend
one and say why. If only one approach is genuinely viable, say so and explain
what you rejected. Let the user choose or redirect.

## Present the design in sections

Walk through the design in sections sized for the user to actually review —
one coherent topic at a time, pausing for reaction. Cover:

- architecture and how it fits the existing system;
- components and their responsibilities;
- data flow;
- failure behavior — what happens when things go wrong;
- testing and verification strategy.

Incorporate feedback as you go. Do not present a wall of text and ask "any
questions?"

## Write the spec

Once the sections are agreed, write a durable design spec to the project's
documentation location (for example `docs/specs/YYYY-MM-DD-<topic>.md`, or
wherever this project keeps design documents). The spec records goal, design
decisions, failure behavior, non-goals, and acceptance criteria — the things
that stay true regardless of how implementation unfolds.

The spec is a contract, not a transcript: every sentence should bind the
implementation. Record the chosen approach and why in brief; rejected
alternatives earn a line only when the rejection itself is a constraint.

Self-review the written spec before showing it: check it against the
conversation for anything agreed but omitted, anything included but never
agreed, and internal contradictions — and cut prose that describes rather
than binds. Fix what you find.

Then require the user to review the written document itself. Conversational
agreement is not approval of the spec; the file is the contract.

## Handoff

An approved spec transitions to `mapping-work`, which inspects the repository
and chooses an execution strategy. Do **not** mandate an exhaustive
implementation plan or a task-per-agent workflow as a condition of finishing
design — whether any detailed plan is needed is `mapping-work`'s decision,
made against repository evidence.

If the design is too large to be one coherent unit of work, recommend
splitting it into multiple specs, each reviewed and approved on its own, and
agree on the split with the user.

## Portability

Do not assume any specific visual companion, documentation-style skill,
commit policy, or platform tool. If a helpful capability is available
(diagram rendering, a docs skill, a spec template), use it when it improves
the collaboration — but its absence must never block design work.
