# Behavioral evals

Twelve `claude plugin eval` cases. Each one probes a behavior the stack is
meant to change. Every case scaffolds a small fixture git repository, sends
one prompt, and scores the run with graders. By default each case also runs
without the plugin, so the score is a delta over baseline: a case measures
something only if the baseline does not already pass it.

## Running

From the repository root:

```sh
claude plugin eval . --scaffold --allow-tools Bash Write Edit --judge-model sonnet --no-publish
```

- `--scaffold` runs each case's `fixture.sh` to build its repository. The
  scripts are authored here; read them before trusting a changed one.
- `--allow-tools Bash Write Edit` lets the agent run tests, edit, and commit
  inside the fixture. Cases are useless without it.
- `--judge-model sonnet` replaces the default `haiku` judge, which is too
  weak for multi-condition rubrics such as those in cases 10–12.
- `--no-publish` keeps the HTML report local.
- `--trust-plugin` answers the first-run trust prompt; pass it only for
  non-interactive runs such as CI.
- Useful for iterating: `--case '<glob>'`, `--tag <tag>`, `--runs 1`,
  `--ablation none` (skip the baseline arm), `-j 4` (concurrency).
  Implementation cases take several minutes each; a full run costs real
  money.

Results land in `evals/results/`, which is git-ignored.

## Limits and grading choices

- **No simulated user.** A run is one prompt. Cases that reach an approval
  gate (brainstorming, diagnosis, triage) are graded on the state at the
  gate: what was asked, drafted, verified, or left unchanged. Cases that
  need an approved contract start from one written in the fixture.
- **Mid-flight events are staged in the prompt.** Case 08 describes the
  delegates' reports rather than producing them.
- **Fixtures are small.** The topology cases (04, 05) accept a justified
  single-lead choice where the repository really is too small to be worth
  partitioning. What they grade strictly is the ownership and isolation
  rules applied to whatever topology is chosen. Case 06 likewise passes a
  baseline that simply searches the files itself; its signal is the tier of
  any delegate the plugin arm starts.
- **Judges see only the ends of a run.** An `llm` grader on `trace` sees
  the first 12 and last 12 messages, so no case uses it. Process facts are
  graded mechanically over the full run (`tool_used`, `tool_order`, file
  regexes, and one `regex` on `trace` in case 06); judgments read the final
  message or a file the run produced, such as the spec's Plan section. What
  a delegate did inside its own context is invisible to graders; cases
  grade the brief, the lead's report of it, and the tree it left.
- **Skill graders are indicators.** In a two-arm run every `tool_used`
  grader on `Skill` is reported but not scored, unless it sets `arm: both`
  — as case 01's must-not-invoke check does.
- **Unchanged code is proven from the tree.** Cases 02, 11, and 12 check
  the files after the run, not the tool calls, so a shell write or a
  delegate's edit counts and diagnosis's temporary instrumentation, once
  removed, does not. Each `app-unchanged-*` pattern is its fixture file
  verbatim; regenerate it whenever that file changes in `fixture.sh`.
- **The lead's tier is pinned where graders assume it.** Cases 06 and 07
  set `model: opus`, since their tier graders assume a peer-tier lead;
  `--model` overrides that for every case.
- **Some harness paths are out of reach.** `SendMessage` and `ListAgents`
  are not grantable in an eval, so a delegate follow-up is a fresh `Agent`
  call. The sandbox confines writes to the workspace, so a `git worktree
  add` outside it fails; `isolation: "worktree"` is expected to work but
  is unverified until the suite runs.
- **Triggering is not measured.** Every prompt names the stack, so no case
  tests whether a skill's description fires on natural phrasing.
- **The light tier is not yet covered.** No case exercises a contract
  stated in the conversation, or its promotion to a file mid-work.

## Cases

| Case | Probes | Tags |
|---|---|---|
| `01-direct-clear-change` | clear change done directly: no spec or interview, verified, committed off the default branch | routing, tiers |
| `02-brainstorm-batches-and-drafts` | design grounded in code; independent questions batched with recommendations, or an early draft | routing, brainstorming |
| `03-coherent-change-no-delegation` | coupled work planned as a coherent change into the spec's Plan section and implemented by the lead; no editing delegates | leading, topology |
| `04-broad-uncertain-reconnaissance` | blast radius the spec understates scoped by read-only recon; plan scope corrected | leading, delegation, topology |
| `05-partitioned-workstreams` | seams behind a fixed interface: editing briefs state ownership, criteria, and no commits; isolated, non-overlapping delegates; lead integrates and commits; feature delivered | leading, delegation, topology |
| `06-low-risk-lesser-model` | bounded evidence collection never sent up-tier; returned evidence checked; call sites reported correctly | delegation, tiers |
| `07-high-risk-frontier-model` | a destructive-migration review, asked for without naming how, goes to a peer/frontier reviewer with the full brief | delegation, tiers, review |
| `08-coupled-work-returns-to-lead` | hidden coupling stops parallel edits; lead takes over; plan records why | leading, delegation, replanning |
| `09-failed-assumption-replan` | sequencing fixed in the plan; false material assumption goes to the user | leading, replanning |
| `10-consequential-completion-review` | independent review, briefed with the spec and failure modes, catches an aggregate defect; fix reverified and committed; user files untouched | leading, review, completion |
| `11-bug-report-routes-to-diagnosis` | reproduction run; upstream root cause, not the crash site; no code changed before approval | routing, diagnosing |
| `12-invalid-finding-refuted-not-fixed` | findings verified before fixing; invalid one refuted; sibling instances swept; security fixes put the contract in a file; nothing posted | routing, triage |

## Writing a case

A case directory holds `case.yaml` (with `context.scaffold_script`),
`fixture.sh`, `prompt.md`, and `graders/*.md`. Prefer the free graders
(`tool_used`, `tool_order`, `file_exists`, `regex`) for mechanical facts
and `llm` graders for judgment, with explicit PASS and FAIL conditions.
An `input_match` sees the whole JSON-encoded input, file contents included,
so anchor it on the field it means (`"file_path":\s*"[^"]*app/`). Prove
that code is unchanged from the files after the run, not from the calls
that could have changed them. The subagent tool is named `Agent`. Never point an `llm` grader at
`trace`: the judge sees only the first and last 12 messages. End each prompt with
the line that invokes the stack, since invoking it is what grants its
authority to commit and delegate.
