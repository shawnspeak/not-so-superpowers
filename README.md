# not-so-superpowers

A portable collection of five skills for Codex and Claude Code that keeps
the strongest part of Superpowers — collaborative design — and replaces its
mandatory detailed-plan, task-per-agent execution pipeline with adaptive
orchestration suited to frontier models.

One persistent lead agent retains architectural and implementation context.
Delegation is selective: lesser or cheaper models take bounded low-risk work
when the harness allows model selection; peer or frontier models are
reserved for ambiguity, coupling, risk, and consequential review.

Design spec: [`docs/specs/2026-07-10-frontier-orchestration-skill-stack-design.md`](docs/specs/2026-07-10-frontier-orchestration-skill-stack-design.md)

## The skills

| Skill | Responsibility |
|---|---|
| [`brainstorming`](skills/brainstorming/SKILL.md) | Collaborative design: clarify, compare approaches, produce an approved written spec |
| [`mapping-work`](skills/mapping-work/SKILL.md) | Inspect the repo, choose an execution mode, produce 3–8 outcome-sized work packages |
| [`leading-implementation`](skills/leading-implementation/SKILL.md) | One persistent lead implements end to end, replans from evidence, owns integration |
| [`delegating-workstreams`](skills/delegating-workstreams/SKILL.md) | Bounded delegate briefs, ownership rules, capability-tier model selection |
| [`reviewing-work`](skills/reviewing-work/SKILL.md) | Review logical outcomes and the aggregate against the spec; evidence-based completion |

Workflow: an idea goes through `brainstorming` to an approved spec; the spec
goes through `mapping-work` to an execution mode and living map;
`leading-implementation` carries it to completion, using
`delegating-workstreams` when work genuinely branches and `reviewing-work`
at risk boundaries and before consequential completion.

## Installation

Each directory under `skills/` is independently installable — copy the whole
collection or just the skills you want. There is no plugin manifest, no
installer, and no required harness-specific dependency.

**Claude Code** — copy into a skills directory:

- per-project: `<repo>/.claude/skills/<skill-name>/`
- personal: `~/.claude/skills/<skill-name>/`

**Codex** — copy into the skills location your Codex version supports
(commonly `~/.codex/skills/<skill-name>/`); check the current Codex
documentation.

Only `delegating-workstreams` carries harness-specific material, isolated in
its `references/` directory. Core skill bodies are platform-neutral and
degrade gracefully: without subagents, parallelism, model selection, or
worktrees, the lead executes sequentially with the same ownership, evidence,
and review boundaries.

## Validation

- Structural: `tests/validate-structure.sh` — frontmatter, placeholders,
  referenced files, platform neutrality, body size.
- Behavioral: `tests/scenarios/` — eight baseline-vs-forward scenarios
  covering execution-mode selection, tier selection, coupling recovery,
  replanning, and evidence-based completion.
