# CLAUDE.md

Portable seven-skill orchestration stack for Claude Code and Codex:
`routing-work` sizes and routes the work → `brainstorming` (design),
`diagnosing` (root-cause investigation), or `triaging-findings` (external
review triage) → `leading-implementation`, with `delegating-workstreams` and
`reviewing-work` as support skills. A clear change routes straight to
`leading-implementation`. The product
of this repo is skill *prose* — there is no application code. Editing here
means editing instructions that a frontier model will follow, so precision of
language is the engineering.

## Design intent (why the prose says what it says)

- **Process is sized to the work.** `routing-work` picks a tier from
  repository evidence — **direct** (clear, local, low-risk: no spec, state
  the change and its verification, implement), **light** (a contract stated
  in the conversation and approved once, no file), or **full** (a spec file,
  for work that spans sessions or models, crosses subsystems, or touches
  interfaces, data, security, or destructive operations). The tier sizes
  artifacts and approval gates, never the rigor of the method: diagnosis
  still reproduces first and triage still verifies every finding at every
  tier. Tier changes are announced; a light contract becomes a file the
  moment the work must survive the session. Never add prose that forces
  full-tier ceremony onto work the sizing rules call direct or light.
- **Three entry points, one downstream contract.** Features and design-shaped
  problems enter through `brainstorming`; defects with an unknown cause
  enter through `diagnosing`; batches of external review findings — a PR
  review, a scanner report, a pasted list — enter through
  `triaging-findings`. All end in an approved contract that `leading-implementation`
  consumes identically — the pipeline downstream of the contract never
  forks. Diagnosis is evidence-driven and leaves the codebase unchanged:
  reproduction before theory, one hypothesis at a time, cause confirmed by
  mechanism/prediction/history before any fix is designed. Its acceptance
  criteria name a test encoding the reproduction, which the lead writes
  during implementation — dovetailing with the failing-tests-first
  delegation contract below. Triage is likewise evidence-driven and leaves
  the codebase unchanged: inbound findings are testimony, not truth, so
  every finding is verified — confirmed, refuted, or unverifiable — before
  it is dispositioned, evidence-backed refutation is a first-class outcome,
  and confirmed findings are treated as samples of a class and swept for
  siblings. Findings needing root-cause work, design comparison, or a
  contract change escalate to `diagnosing`, `brainstorming`, or the user.
  Never let the entry skills blur: design compares legitimate alternatives;
  diagnosis converges on one truth; triage passes verdicts on claims.
- **One persistent lead, selective delegation.** The stack deliberately
  rejects Superpowers-style task-per-agent pipelines. Context retained by a
  single lead is treated as the most valuable asset; never add prose that
  encourages fragmenting coupled work across fresh contexts.
- **Durable artifacts at every cross-session handoff.** A full-tier spec
  file (`docs/specs/YYYY-MM-DD-<topic>.md`) holds a **Contract** section,
  written by the entry skill, and a **Plan** section, written by the lead
  before the first change; together they must let a *different session or
  model* pick up the work cold. Any handoff that crosses a session or model
  boundary — or may be lost to context compaction — must travel via a
  file, not conversation; a light contract is promoted to a file — the lead
  adding its Plan — the moment that applies. The lead commits the spec file
  as the workspace's first commit, or as the next commit when promoted
  mid-work, and recommits it with the next package whenever the Plan is
  reshaped, so the committed spec never lags the plan in use. This
  includes where the work lives: the Plan records the workspace (branch or
  worktree) so a resumed session finds the work in progress without
  repo-state archaeology — the skills follow project branching convention
  rather than imposing one, and absent a convention package commits never
  land on the default branch. The history is a durable
  artifact too: the lead commits each work package as its verification
  passes (in the project's commit style, read from its history), staging
  only the package's own paths, so verified work is never stranded in an
  uncommitted tree and completion leaves the implementation's changes fully
  committed. Pre-existing uncommitted changes are checked at workspace
  confirmation — overlaps resolved with the user up front, the rest
  preserved untouched — and workspace state is never journaled into the
  Plan, which stays a coordination artifact. Delegates return changes and
  evidence; only the lead writes history on the implementation workspace,
  and delegates that edit concurrently work in isolated worktrees, leaving
  changes uncommitted for the lead to bring over, verify, and commit.
- **Invoking the stack grants bounded authority, stated explicitly.**
  Harness defaults (e.g. "commit only when asked", "use subagents only when
  asked") would otherwise stall the stack, so the skills say outright what
  invocation authorizes: bounded delegates and package commits on the
  implementation workspace. When a skill engaged on its own and the user
  neither invoked the stack nor approved a contract, the lead asks once
  before the first commit and once before the first delegate. It never authorizes scripted multi-agent
  orchestration runs, pushing, merging, history rewrites, or publishing to
  a shared channel — triage replies are approved as content with the contract,
  and posting them needs its own confirmation. Keep new grants explicit and
  this narrow.
- **Tiered model economics.** Intended usage: a frontier model (e.g. Fable)
  runs brainstorming, diagnosing, and triage; a strong-but-cheaper model
  (e.g. Opus) runs the lead, including planning against the repository —
  the lead that owns and reshapes the plan also writes it; bounded low-ambiguity and high-volume mechanical work goes
  down-tier (e.g. Haiku); the lead delegates *up*-tier for adversarial
  review, architecture-changing diagnosis, and security calls. When
  acceptance criteria are crisp and testable, failing tests written before
  implementation are the preferred down-tier contract — "make these pass
  without modifying them" makes done machine-checkable. The brief demands a
  general solution rather than code fitted to the tests, and the lead
  inspects returned diffs for test-tailored shortcuts — down-tier delegates
  are the population most prone to overfitting the contract. Keep new prose
  compatible with this split.
- **Independent review gates consequential completion.** The lead's own
  re-read may cover routine boundaries, but the review before consequential
  completion must come from a reviewer that did not write the changes — a
  delegate or peer model, up-tier where warranted, in a fresh context (a
  delegate that inherits the lead's conversation, such as a fork, shares
  the author's blind spots and is not independent). When the harness offers
  no independent reviewer, the lead's fallback self-review must be declared
  in the completion report; degraded independence is reported, never silent.
  Reviewers report every finding, labeled — filtering is the
  lead's call, made with the labels in view, never the reviewer's applied
  silently. The completion close-out checklist lives in
  `leading-implementation` (review can be skipped for low-risk work;
  completion cannot) and runs once — review feeds it, never replaces it.
- **Contract binds, plan coordinates.** Skills must never let the contract
  change silently; plan reshaping is free but recorded. The contract
  bounds ambition as well as scope: the lead builds the simplest
  implementation that satisfies the acceptance criteria — abstractions or
  defenses the spec does not demand are scope creep, not diligence.
- **Each rule has one home.** A rule lives in exactly one skill; others
  point to it by skill name rather than restating it — sizing and spec rules
  in `routing-work`, workspace and commit rules in `leading-implementation`,
  briefs, tiers, and tests-as-contract in `delegating-workstreams`,
  reviewer independence and finding labels in `reviewing-work`. Restated
  rules drift apart and every extra clause competes for the model's
  attention; prefer stating the rule over enumerating its cases.

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
- Every backticked bare lowercase token in a SKILL.md body is read as a
  skill name and must be one of `EXPECTED_SKILLS` — so a reference to a
  removed or renamed skill fails validation.

Run `bash tests/validate-structure.sh` after **every** skill edit.

## Soft conventions (not machine-checked — keep them by hand)

- Harness-specific mechanics live only in `delegating-workstreams/references/`
  (`claude-code.md`, `codex.md`). The claude-code reference may name model
  tiers (`haiku`/`opus`/`fable`); the codex reference must NOT hard-code
  model names — it tells the lead to read them from the user's Codex config.
- **Cross-skill consistency:** `leading-implementation`,
  `triaging-findings`, `diagnosing`, and `reviewing-work` route all
  delegation through `delegating-workstreams`, so anything declared
  delegable in one must appear in its tier lists. When editing
  delegation prose, grep all of them.
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
- Behavioral: `evals/` — twelve `claude plugin eval` cases, each a
  scaffolded fixture repo, a prompt, and graders, run with and without the
  plugin so each score is a delta over baseline. See `evals/README.md` for
  the run command. A skill edit that changes behavior — not just wording —
  ships with an eval run of the affected cases (tags: `routing`, `tiers`,
  `topology`, `delegation`, `replanning`, `review`, `completion`,
  `diagnosing`, `triage`, `brainstorming`, `leading`) and, if the behavior
  a case probes changed, an updated case. Unmeasured prose changes are how
  clauses accumulate.

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
