# Behavioral scenarios

Each scenario file probes one behavior the skill stack is supposed to change.
They are run manually (or with an eval harness) against Codex and Claude
Code, in two passes:

1. **Baseline** — run the scenario prompt in a session *without* the skills
   installed. Record what topology the agent chooses, what artifacts it
   produces, and how it declares completion.
2. **Forward test** — run the same prompt with the skills installed. Compare
   against the scenario's success criteria.

A scenario passes when the forward run meets every success criterion and the
baseline run demonstrably did not already meet them all (otherwise the
scenario measures nothing).

## Aggregate success

Across the suite, the agent must:

- choose a task-shaped topology (direct, reconnaissance, or partitioned)
  from repository evidence, not by default;
- preserve one lead's context and accountability;
- produce outcome-sized work packages, not time-sliced task lists;
- select delegate model capability proportional to ambiguity and risk;
- ground completion in evidence checked against the approved spec.

## Scenario index

| File | Probes |
|---|---|
| `01-coherent-change-no-delegation.md` | delegation overhead avoided on coupled work |
| `02-broad-uncertain-reconnaissance.md` | read-only recon delegates on unclear blast radius |
| `03-partitioned-workstreams.md` | parallel delegates with non-overlapping ownership |
| `04-low-risk-lesser-model.md` | lesser-model tier for bounded low-risk work |
| `05-high-risk-frontier-model.md` | peer/frontier tier for ambiguous high-risk work |
| `06-coupled-work-returns-to-lead.md` | parallel edits stopped when coupling emerges |
| `07-failed-assumption-replan.md` | execution map updated vs. spec conflict escalated |
| `08-consequential-completion-review.md` | independent review + aggregate verification before done |
| `09-bug-report-routes-to-diagnosis.md` | root cause confirmed via reproduction before any fix |

## Structural validation

Run `tests/validate-structure.sh` from the repository root. It checks
frontmatter, unresolved placeholders, referenced files, and platform-neutral
core-skill language. Behavioral scenarios assume structural validation
already passes.
