# Delegation mechanics: Codex

How the intent-level operations in `delegating-workstreams` map onto Codex
primitives. Codex's delegation surface changes between releases — check
`codex --help` and the current Codex documentation before relying on a flag
named here. If a primitive is absent, fall back to the sequential-lead
behavior in the core skill.

## Start a bounded delegate

Two routes, in order of preference:

1. **Native subagent / collaboration features**, where the installed Codex
   version provides them. Use the harness's own facility so the delegate's
   progress and permissions are visible to the user.
2. **A non-interactive child run**: `codex exec "<brief>"` starts a fresh
   Codex context that executes the brief and exits. Pass the entire delegate
   brief as the prompt and reference durable artifacts (the spec, the
   execution map) by file path so the delegate reads them itself.

Useful flags for `codex exec`:

- `--cd <dir>` — scope the delegate to a directory;
- `--sandbox read-only` — mechanical enforcement for reconnaissance briefs
  (prefer this over merely instructing "do not edit");
- `--sandbox workspace-write` — for delegates allowed to edit within their
  ownership boundary;
- `-m` / `--model <model>` — capability-tier selection (below).

## Select a capability tier

`codex exec -m <model>` (or a model set in a `~/.codex/config.toml` profile,
selected with `--profile`) chooses the delegate's model. Map the core
skill's tiers to whatever models the user's Codex configuration exposes:

- lesser model → the smaller/faster model available in the configuration,
  for bounded low-ambiguity work;
- peer/frontier → the same model the lead runs on, for ambiguous, coupled,
  or consequential work. Omitting `-m` uses the configured default, which
  is the safe choice when unsure.

Do not hard-code model names in briefs; read them from the user's config or
ask once.

## Wait for results

`codex exec` is synchronous: its stdout is the delegate's report. For
parallel workstreams, launch multiple `codex exec` processes in the
background and collect their output — but only when their ownership does not
overlap and, for editing delegates, each runs in its own isolated worktree
(see below and the core skill's ownership rules). If the harness cannot run
processes concurrently, run delegates one at a time; the brief structure is
unchanged.

## Send a follow-up

`codex exec` child runs do not retain context between invocations unless the
installed version supports resuming a session (for example a
`codex exec resume`-style subcommand — check `codex exec --help`). If
resumption is unavailable, a follow-up is a new brief that includes the
delegate's previous report as context.

## Isolation for parallel edits

Codex has no built-in worktree isolation for delegates. When parallel
editing workstreams are justified, create git worktrees or branches manually
and point each `codex exec --cd` at its own copy — file partitioning in a
shared tree is not a substitute, per the core skill's ownership rules. If
worktrees cannot be created, run the editing delegates one at a time.
