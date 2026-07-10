# not-so-superpowers

A portable collection of five skills for Codex and Claude Code that keeps
the strongest part of Superpowers — collaborative design — and replaces its
mandatory detailed-plan, task-per-agent execution pipeline with adaptive
orchestration suited to frontier models.

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

- Structural: `tests/validate-structure.sh` — frontmatter, placeholders,
  referenced files, platform neutrality, body size.
- Behavioral: `tests/scenarios/` — eight baseline-vs-forward scenarios
  covering execution-mode selection, tier selection, coupling recovery,
  replanning, and evidence-based completion.
