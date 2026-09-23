# Behavioral evals

Twelve `claude plugin eval` cases. Each one probes a behavior the stack is
meant to change. Every case scaffolds a small fixture git repository, sends
one prompt, and scores the run with graders. By default each case also runs
without the plugin, so the score is a delta over baseline: a case measures
something only if the baseline does not already pass it.

## Running

From the repository root:

```sh
claude plugin eval . --scaffold --allow-tools Bash Write Edit --no-publish
```

- `--scaffold` runs each case's `fixture.sh` to build its repository. The
  scripts are authored here; read them before trusting a changed one.
- `--allow-tools Bash Write Edit` lets the agent run tests, edit, and commit
  inside the fixture. Cases are useless without it.
- `--no-publish` keeps the HTML report local.
- Useful for iterating: `--case '<glob>'`, `--tag <tag>`, `--runs 1`,
  `--ablation none` (skip the baseline arm), `-j 4` (concurrency).
  Implementation cases take several minutes each; a full run costs real
  money.

Results land in `evals/results/`, which is git-ignored.

## What the evals can't cover

- **No simulated user.** A run is one prompt. Cases that reach an approval
  gate (brainstorming, diagnosis, triage) are graded on the state at the
  gate: what was asked, drafted, verified, or left unchanged. Cases that
  need an approved contract start from one written in the fixture.
- **Mid-flight events are staged in the prompt.** Case 08 describes the
  delegates' reports rather than producing them.
- **Fixtures are small.** The topology cases (04, 05) accept a justified
  single-lead choice where the repository really is too small to be worth
  partitioning. What they grade strictly is the ownership and isolation
  rules applied to whatever topology is chosen.

## Cases

| Case | Probes | Tags |
|---|---|---|
| `01-direct-clear-change` | clear change done directly: no spec or interview, verified, committed off the default branch | routing, tiers |
| `02-brainstorm-batches-and-drafts` | design grounded in code; independent questions batched with recommendations, or an early draft | routing, brainstorming |
| `03-coherent-change-no-delegation` | coupled work planned as a coherent change into the spec's Plan section; no editing delegates | leading, topology |
| `04-broad-uncertain-reconnaissance` | unverified blast radius scoped by read-only recon; plan scope corrected | leading, delegation, topology |
| `05-partitioned-workstreams` | seams behind a fixed interface: isolated, non-overlapping delegates; lead integrates and commits | leading, delegation, topology |
| `06-low-risk-lesser-model` | bounded evidence collection never sent up-tier; results checked | delegation, tiers |
| `07-high-risk-frontier-model` | destructive-migration review goes to a peer/frontier reviewer with the full brief | delegation, tiers, review |
| `08-coupled-work-returns-to-lead` | hidden coupling stops parallel edits; lead takes over; plan records why | leading, delegation, replanning |
| `09-failed-assumption-replan` | sequencing fixed in the plan; false material assumption goes to the user | leading, replanning |
| `10-consequential-completion-review` | independent review catches an aggregate defect; fix reverified and committed; user files untouched | leading, review, completion |
| `11-bug-report-routes-to-diagnosis` | reproduction before theory; upstream root cause, not the crash site; no code changed before approval | routing, diagnosing |
| `12-invalid-finding-refuted-not-fixed` | findings verified before fixing; invalid one refuted; sibling instances swept; nothing posted | routing, triage |

## Writing a case

A case directory holds `case.yaml` (with `context.scaffold_script`),
`fixture.sh`, `prompt.md`, and `graders/*.md`. Prefer the free graders
(`tool_used`, `tool_order`, `file_exists`, `regex`) for mechanical facts
and `llm` graders for judgment, with explicit PASS and FAIL conditions.
Inside eval runs the subagent tool is named `Task`. End each prompt with
the line that invokes the stack, since invoking it is what grants its
authority to commit and delegate.
