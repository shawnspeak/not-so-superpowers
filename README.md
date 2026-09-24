# not-so-superpowers

A portable collection of seven skills for Codex and Claude Code that keeps
the strongest part of Superpowers — collaborative design — and replaces its
mandatory detailed-plan, task-per-agent execution pipeline with adaptive
orchestration suited to frontier models. Process is sized to the work: a
clear, local change is implemented directly; ceremony — written specs,
plans, approval gates — is reserved for work that needs it.

One persistent lead agent retains architectural and implementation context.
Delegation is selective: lesser or cheaper models take bounded low-risk work
when the harness allows model selection; peer or frontier models are
reserved for ambiguity, coupling, risk, and consequential review.

The skill files under [`skills/`](skills/) are the source of truth for the
stack's behavior; [`CLAUDE.md`](CLAUDE.md) records the design intent and the
conventions for changing them.

## The skills

| Skill | Responsibility |
|---|---|
| [`routing-work`](skills/routing-work/SKILL.md) | Classify the work, size the process to it (direct, light, or full), route it; holds the shared spec rules |
| [`brainstorming`](skills/brainstorming/SKILL.md) | Collaborative design: targeted questions, approach comparison, an early concrete draft, an approved contract |
| [`diagnosing`](skills/diagnosing/SKILL.md) | Root-cause investigation: reproduce, confirm the cause with evidence, an approved fix contract |
| [`triaging-findings`](skills/triaging-findings/SKILL.md) | External review triage: verify every finding, sweep for siblings, an approved triage contract with dispositions and replies |
| [`leading-implementation`](skills/leading-implementation/SKILL.md) | One persistent lead plans against the repository, implements end to end, replans from evidence, owns integration and commits |
| [`delegating-workstreams`](skills/delegating-workstreams/SKILL.md) | Bounded delegate briefs, ownership rules, capability-tier model selection |
| [`reviewing-work`](skills/reviewing-work/SKILL.md) | Independent review of logical outcomes and the aggregate against the contract |

Workflow: `routing-work` classifies the request and sizes the process from
repository evidence. A clear change needs no entry skill: at the direct
tier it goes straight to `leading-implementation` — no spec, just a stated
change and its verification — and at the light or full tier `routing-work`
states its contract. Otherwise an idea goes through `brainstorming`, a bug with an
unknown cause through `diagnosing`, and a batch of external review findings
through `triaging-findings`, each ending in an approved contract: stated in
the conversation for light work, or a spec file for full work that spans
sessions, models, or risky surfaces. `leading-implementation` plans against
the repository (into the spec file's Plan section at the full tier) and
carries the work to completion, using `delegating-workstreams` when work
genuinely branches and `reviewing-work` at risk boundaries and before
consequential completion.

## Installation

Each directory under `skills/` is independently installable — copy the whole
collection or just the skills you want. The skills themselves have no
harness-specific dependency; the plugin manifests below are additive.

**Claude Code (plugin, recommended)** — this repo is both a plugin and its
own single-plugin marketplace (`.claude-plugin/`). To enable it in one
project only, add to that project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "not-so-superpowers": {
      "source": { "source": "github", "repo": "shawnspeak/not-so-superpowers" }
    }
  },
  "enabledPlugins": {
    "not-so-superpowers@not-so-superpowers": true
  }
}
```

Interactive installs and `/plugin marketplace update` use your existing git
credentials (gh CLI, SSH agent), so a private repo works as-is; background
auto-update at session startup additionally needs `GITHUB_TOKEN`/`GH_TOKEN`
set. Skills are namespaced, e.g. `not-so-superpowers:brainstorming`.
Alternatively, skip the plugin and copy skill directories into
`<repo>/.claude/skills/` (per-project) or `~/.claude/skills/` (personal).

**Upgrading from 0.7 or earlier** — `mapping-work` was folded into
`leading-implementation`. Plugin installs pick this up on update. Re-run
`./install-codex.sh` (with or without `--link`): it removes a stale
`mapping-work` symlink, or a copy it can match to a version this
repository shipped, and leaves anything else under that name alone.
Hand-copied installs should delete that directory themselves.

**Codex** — Codex CLI has no plugin/marketplace mechanism; it discovers
skills from `.agents/skills/` (project) or `~/.agents/skills/` (user). Run
the installer:

```sh
./install-codex.sh                 # copy into ~/.agents/skills
./install-codex.sh --link          # symlink, so `git pull` here updates all installs
./install-codex.sh path/to/project/.agents/skills   # per-project
```

Only `delegating-workstreams` carries harness-specific material, isolated in
its `references/` directory. Core skill bodies are platform-neutral and
degrade gracefully: without subagents, parallelism, model selection, or
worktrees, the lead executes sequentially with the same ownership, evidence,
and review boundaries.

## Validation

- Structural: `tests/validate-structure.sh` — frontmatter, skill
  registration, placeholders, referenced files, cross-skill references,
  removed-skill names, platform neutrality, body size.
- Behavioral: [`evals/`](evals/README.md) — twelve `claude plugin eval`
  cases, each run with and without the plugin, covering process sizing,
  design collaboration, execution-mode selection, tier selection, coupling
  recovery, replanning, root-cause routing, review-finding triage, and
  evidence-based completion.
