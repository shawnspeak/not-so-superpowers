# CLAUDE.md

Portable five-skill orchestration stack for Claude Code and Codex:
`brainstorming` → `mapping-work` → `leading-implementation`, with
`delegating-workstreams` and `reviewing-work` as support skills. The product
of this repo is skill *prose* — there is no application code. Editing here
means editing instructions that a frontier model will follow, so precision of
language is the engineering.

## Design intent (why the prose says what it says)

- **One persistent lead, selective delegation.** The stack deliberately
  rejects Superpowers-style task-per-agent pipelines. Context retained by a
  single lead is treated as the most valuable asset; never add prose that
  encourages fragmenting coupled work across fresh contexts.
- **Durable artifacts at every handoff.** The spec
  (`docs/specs/YYYY-MM-DD-<topic>.md`) and the execution map (persisted
  alongside it) must let a *different session or model* pick up the work
  cold. Any new handoff introduced between skills must travel via a file,
  not conversation. This includes where the work lives: the map records the
  workspace (branch or worktree) so a resumed session finds the work in
  progress without repo-state archaeology — the skills follow project
  branching convention rather than imposing one. The history is a durable
  artifact too: the lead commits each work package as its verification
  passes (in the project's commit style, read from its history), so
  verified work is never stranded in an uncommitted tree and completion
  leaves the workspace fully committed. Delegates return changes and
  evidence; only the lead writes history on the implementation workspace.
- **Tiered model economics.** Intended usage: a frontier model (e.g. Fable)
  runs brainstorming and mapping; a strong-but-cheaper model (e.g. Opus)
  runs the lead; bounded low-ambiguity and high-volume mechanical work goes
  down-tier (e.g. Haiku); the lead delegates *up*-tier for adversarial
  review, architecture-changing diagnosis, and security calls. When
  acceptance criteria are crisp and testable, failing tests written before
  implementation are the preferred down-tier contract — "make these pass
  without modifying them" makes done machine-checkable. Keep new prose
  compatible with this split.
- **Independent review gates consequential completion.** The lead's own
  re-read may cover routine boundaries, but the review before consequential
  completion must come from a reviewer that did not write the changes — a
  delegate or peer model, up-tier where warranted. When the harness offers
  no independent reviewer, the lead's fallback self-review must be declared
  in the completion report; degraded independence is reported, never silent.
- **Spec is contract, map is coordination aid.** Skills must never let the
  spec change silently; map reshaping is free but recorded.

## Hard conventions (enforced by tests/validate-structure.sh)

- Each skill is `skills/<name>/SKILL.md`; frontmatter `name:` must equal the
  directory name; `description:` must be trigger-focused and contain the
  phrase "Use when".
- Core SKILL.md bodies are **platform-neutral**: they may point at
  `references/` files but must never require a harness-specific command (no
  backtick `codex ...` or `claude ...` invocations in the body).
- SKILL.md bodies stay ≤200 lines — they are loaded selectively.
- No `TODO`/`FIXME`/`TBD`/`XXX`/`{{placeholders}}` anywhere under `skills/`.
- Every `references/*.md` path mentioned in a SKILL.md must exist.

Run `bash tests/validate-structure.sh` after **every** skill edit.

## Soft conventions (not machine-checked — keep them by hand)

- Harness-specific mechanics live only in `delegating-workstreams/references/`
  (`claude-code.md`, `codex.md`). The claude-code reference may name model
  tiers (`haiku`/`opus`/`fable`); the codex reference must NOT hard-code
  model names — it tells the lead to read them from the user's Codex config.
- **Cross-skill consistency:** `leading-implementation` routes all delegation
  through `delegating-workstreams`, so anything declared delegable in one
  must appear in the other's suitable-objectives / tier lists. When editing
  delegation prose, grep both skills.
- Every skill degrades gracefully: if subagents, model selection, or
  worktrees are unavailable, the lead does the work sequentially with the
  same ownership, evidence, and review boundaries. Never add a step that
  hard-requires a harness facility.
- The skill files themselves are the source of truth for the stack's
  behavior; this CLAUDE.md records the intent behind them. When a skill edit
  changes design intent — not just wording — update the "Design intent"
  section above in the same change so the two never diverge.

## Testing

- Structural: `tests/validate-structure.sh` (fast, run always).
- Behavioral: `tests/scenarios/*.md` — eight baseline-vs-forward scenarios
  run *manually* against real harness sessions; they are prompts plus
  success criteria, not executable tests. If a skill change alters a
  behavior a scenario probes (execution-mode choice, tier selection,
  coupling recovery, replanning, completion evidence), update the matching
  scenario file.

## Packaging

- The repo is both a Claude Code plugin and its own single-plugin
  marketplace via `.claude-plugin/` (`plugin.json` holds the version — bump
  it when publishing skill changes). Skills install namespaced as
  `not-so-superpowers:<skill>`.
- Codex installs via `./install-codex.sh` (copy or `--link` symlink into
  `.agents/skills/`). New skill directories are picked up automatically by
  both mechanisms, but a new skill must also be added to `EXPECTED_SKILLS`
  in `tests/validate-structure.sh` and the README table.
- `cspell.json` holds the project vocabulary; add new coined terms there so
  spell-checking stays clean.
