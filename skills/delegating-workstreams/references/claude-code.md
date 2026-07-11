# Delegation mechanics: Claude Code

How the intent-level operations in `delegating-workstreams` map onto Claude
Code primitives. Capabilities vary by version; if a primitive named here is
absent, fall back to the sequential-lead behavior in the core skill.

## Start a bounded delegate

Use the **Agent** (Task) tool. Put the entire delegate brief in the `prompt`
parameter — the subagent starts with a fresh context and sees nothing of the
lead's conversation. Link durable artifacts by file path (the spec, the
execution map) so the delegate reads them itself.

Relevant parameters:

- `subagent_type` — pick the narrowest type that fits:
  - `Explore` for read-only reconnaissance (it cannot edit files, which
    enforces the brief's edit permission mechanically);
  - `general-purpose` (or the default agent) for delegates that implement;
  - project-defined agents from `.claude/agents/*.md` when one matches.
- `run_in_background` — background is the default in recent versions; use a
  synchronous run (`run_in_background: false`) when the lead cannot proceed
  without the result. Launch independent delegates in one message so they
  run concurrently.
- `isolation: "worktree"` — gives an editing delegate its own git worktree.
  Required for concurrent editing delegates, so partial work never shares a
  tree with the lead's commits or another delegate's edits; unnecessary for
  read-only delegates.

## Select a capability tier

The Agent tool accepts a `model` parameter (for example `haiku`, `sonnet`,
`opus`). Map the core skill's tiers:

- lesser model → `haiku` (or the smallest available) for bounded
  low-ambiguity work;
- peer → `opus` or the session's own model for ambiguous, coupled, or
  consequential work; omitting `model` typically inherits the lead's model,
  which is the safe default when unsure;
- frontier → a top-tier model such as `fable`, where available, when the
  lead itself runs below the frontier and needs to delegate up — adversarial
  final review, architecture-changing diagnosis, security judgment.

Project agents can also pin `model` in their `.claude/agents/*.md`
frontmatter.

## Wait for results

The agent's final message returns as the tool result — it is not shown to
the user, so the lead must relay anything that matters. Background agents
notify on completion; do not poll for them.

## Send a follow-up

Use **SendMessage** with the agent's ID or name to continue a previously
spawned delegate with its context intact — right for "your report is missing
the verification output" follow-ups. A new Agent call starts a fresh context
and must carry the full brief again.

## Enforce read-only

Prefer structural enforcement over instructions: use the `Explore` agent
type, or a project agent whose `tools` frontmatter excludes Edit/Write.
Stating "do not edit" in the brief is the fallback, not the mechanism.

## When facilities are missing

Restricted environments may lack the Agent tool, background execution, or
worktrees. The core skill's fallback applies: the lead does the work
sequentially with the same ownership and evidence boundaries.
