# Delegation mechanics: Claude Code

How the intent-level operations in `delegating-workstreams` map onto Claude
Code primitives. Capabilities vary by version; if a primitive named here is
absent, fall back to the sequential-lead behavior in the core skill. Some
tools named here may be deferred — listed by name only until their schema
is loaded through the harness's tool-search facility; load one before
calling it.

## Start a bounded delegate

Use the **Agent** tool. Put the entire delegate brief in the `prompt`
parameter — a fresh subagent sees nothing of the lead's conversation. Link
durable artifacts by file path (the spec file, when one exists) so the
delegate reads them itself. Launch independent delegates in one message so
they run concurrently.

Relevant parameters:

- `subagent_type` — pick the narrowest type that fits:
  - `Explore` for locating: files, symbols, patterns. It reads excerpts
    rather than whole files, so it finds code but does not review or audit
    it — never use it for review, finding verification, or diagnosis;
  - `Plan` for read-only analysis that needs full reading — verifying a
    review finding, investigating a contained subsystem, independent
    review;
  - `general-purpose` (or the default agent) for delegates that implement;
  - project-defined agents from `.claude/agents/*.md` when one matches;
  - installed plugin agent types that run a different model family, where
    available — the strongest independence for adversarial review.
- `isolation: "worktree"` — gives an editing delegate its own git worktree.
  Required for concurrent editing delegates, per the core skill's ownership
  rules; unnecessary for read-only delegates. See "Integrate worktree
  results" below.

### Forks are not delegates in this stack's sense

`subagent_type: "fork"` starts a subagent that inherits the lead's full
conversation and always runs on the lead's model — it ignores `model`. A
fork is therefore never a down-tier delegate and never an independent
reviewer: it shares the author's context and blind spots. Use a fork only
for a side investigation that genuinely needs the lead's context, when the
point is keeping its tool output out of the lead's window.

## Select a capability tier

The Agent tool accepts a `model` parameter (`haiku`, `sonnet`, `opus`,
`fable`). It overrides any model pinned by the agent type. Map the core
skill's tiers:

- lesser model → match how far down-tier to the work's shape: `haiku` (or
  the smallest available) for locating, summarizing, and high-volume
  mechanical sweeps; `sonnet` for bounded implementation — an isolated
  package behind a defined interface, or making a pre-written failing test
  suite pass — where the smallest tier tends to underdeliver;
- peer → `opus` or the session's own model for ambiguous, coupled, or
  consequential work; omitting `model` typically inherits the lead's model,
  which is the safe default when unsure;
- frontier → a top-tier model such as `fable`, where available, when the
  lead itself runs below the frontier and needs to delegate up — adversarial
  final review, architecture-changing diagnosis, security judgment.

Project agents can also pin `model` in their `.claude/agents/*.md`
frontmatter.

## Wait for results

Subagents run in the background; the harness notifies the lead when one
completes, and its final message arrives as the result. Do not poll, and do
not predict or fabricate a pending result — if the lead cannot proceed
without it, wait for the notification. The result is not shown to the user,
so the lead must relay anything that matters.

## Send a follow-up

Use **SendMessage** with the agent's ID or name to continue a previously
spawned delegate with its context intact — right for "your report is missing
the verification output" follow-ups. **ListAgents** shows which delegates
are addressable. A new Agent call starts a fresh context and must carry the
full brief again.

## Integrate worktree results

A worktree delegate's result names its worktree path and branch when it
made changes (a worktree with no changes is cleaned up automatically).
State in the brief that the delegate leaves its changes uncommitted and
reports the worktree path. The lead then inspects the diff in that
worktree, brings the changes into the implementation workspace (for
example by applying the worktree's diff), verifies them there, commits
path-scoped, and removes the worktree and its branch.

## Enforce read-only

Prefer structural enforcement over instructions: use the `Explore` or
`Plan` agent types, or a project agent whose `tools` frontmatter excludes
Edit/Write. These exclude the file-editing tools but may still expose a
shell, so state "do not modify files" in the brief as well — the agent type
is the primary guard, the brief the backstop.

## Multi-agent orchestration

The Workflow tool scripts many agents at once. The stack never directs it:
the persistent lead delegates bounded objectives through the Agent tool.
Use Workflow only when the user has asked for multi-agent orchestration in
their own words.
