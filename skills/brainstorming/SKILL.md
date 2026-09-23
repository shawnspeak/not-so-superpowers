---
name: brainstorming
description: Use when a feature, change, or problem needs design before implementation — when there are decisions to make or legitimate alternative approaches to weigh. For a bug whose cause is unknown, use diagnosing; a clear change with one obvious approach is routed and sized by routing-work. Produces an approved design contract through targeted questions, approach comparison, and an early concrete draft.
---

# Brainstorming

Turn a design-shaped request into an approved contract for what must be
built. The contract is not an implementation plan. If the tier is not yet
set, size the work per `routing-work` first; a request that turns out to
have one obvious approach goes back to `routing-work` as a clear change.

## Ground first

Read the relevant code, docs, recent history, and configuration before
proposing anything. Never design against an imagined codebase. Any question
the code can answer, answer from the code.

## Ask only what the user can answer

Collect the questions whose answers would change what you build — purpose,
constraints, non-goals, how the user will judge success. Ask the independent
ones together in one batch, each with your recommended answer where you have
one. Ask one at a time only when a question depends on an earlier answer.
Where a sensible default exists, put it in the draft as a stated decision
rather than asking. Stop asking when answers stop changing the design.

## Compare approaches

When legitimate alternatives exist, present two or three with honest
tradeoffs and recommend one. If only one is viable, say so in a line and
name what you rejected. This can travel in the same message as the
question batch. Let the user choose or redirect.

## Draft early, then iterate

As soon as the approach is chosen, write the draft contract. People
critique a concrete draft far better than they answer abstract questions,
so iterate on the draft, not in conversation about it. Put the decisions you
made on the user's behalf first, so they are reviewed rather than
discovered.

The contract records, as they apply:

- goal — the problem solved and for whom;
- design decisions — the chosen approach and why, in brief; architecture
  and fit with the existing system; components and responsibilities; data
  flow. A rejected alternative earns a line only when its rejection is
  itself a constraint;
- failure behavior — what happens when things go wrong;
- verification strategy;
- non-goals;
- acceptance criteria.

Apply the spec rules in `routing-work` — binding prose, self-review, and
approval of the written contract.

## Handoff

An approved contract goes to `leading-implementation`. Do not mandate a
detailed implementation plan or a task-per-agent workflow as a condition of
finishing design; how the work is shaped is the lead's decision, made
against repository evidence. If the design is too large to be one coherent
unit, split the contract per `routing-work`.

## Portability

Assume no visual companion, docs skill, or spec template. Use one when it
helps the collaboration; its absence never blocks design work.
