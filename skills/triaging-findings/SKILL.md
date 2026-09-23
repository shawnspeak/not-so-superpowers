---
name: triaging-findings
description: Use when a batch of findings about existing work arrives from outside — a PR review, a scanner or bot report, a pasted list of issues — and must be verified and dispositioned before anything is fixed. Guides evidence-driven triage to per-finding verdicts, drafted replies, and an approved triage contract.
---

# Triaging Findings

Turn an incoming batch of findings into verified verdicts and an approved
triage contract. Inbound findings are testimony, not truth: reviewers —
human, bot, or model — report real defects, plausible non-problems, and
single instances of patterns that live elsewhere too.

## Boundary

This skill is for findings that arrive from outside the session. Findings
that `reviewing-work` produces inside an active implementation stay with
the lead. A single problem with an unknown cause brought as the task is
`diagnosing`. Triage passes verdicts on claims: it root-causes no further
than confirming or refuting the claim in front of it, and deeper work
routes out rather than being absorbed.

## Normalize before judging

Read the reviewed work first — the diff or artifacts the findings are about,
and the contract behind them if one exists. A finding can only be judged
against what the work was contracted to do. Then inventory every finding,
dropping nothing silently:

- restate each as claim, location, and concrete failure scenario;
- label each with `reviewing-work`'s classes — blocking, material, minor —
  and label one that arrives without a failure scenario or evidence an
  **opinion**, a label that travels with it through disposition;
- group coupled findings — same code, one change resolving several, fixes
  that would collide;
- order the triage by consequence, not by comment order.

## Verify each finding

Verification is a bounded investigation with the reviewer's claim as the
starting hypothesis: construct the failing input or trace the mechanism to
confirm it, or refute it with evidence. Every finding gets a verdict, with
evidence cited:

- **confirmed** — the failure scenario is real;
- **refuted** — the claimed failure cannot occur;
- **unverifiable** — what is missing to decide is named, and the finding is
  dispositioned on that honest footing.

Agreement is not a shortcut: a finding fixed without verification is how an
invalid finding becomes a real bug, and evidence-backed refutation is as
legitimate an outcome as confirmation. The codebase stays unchanged during
triage. If confirming a claim needs genuine root-cause work — the symptom is
real but its mechanism unknown — route that finding to `diagnosing`.

Individual verifications may be delegated per `delegating-workstreams` —
down-tier when the failure scenario is mechanically checkable, up-tier for
security-flavored claims. Without delegation, verify sequentially to the
same evidence bar.

## Assess impact and sweep the class

For each confirmed finding, record the impact: what breaks, for whom, and
how expensive it is once shipped. The reviewer's severity is a claim like
any other.

A finding is a sample, not an enumeration. Before dispositioning, search the
codebase for other instances of each confirmed finding's pattern. What the
sweep surfaces joins the triage as findings in their own right, attributed
to the sweep and verified like the rest.

## Disposition every finding

Recommend exactly one disposition per finding, with its rationale:

- **Fix** — with acceptance criteria; when they are crisp and testable,
  name the test that encodes the failure scenario, failing before the fix
  and passing after, written during implementation.
- **Decline** — with the refuting evidence or the reasoned tradeoff,
  drafted as the reply the reviewer will read.
- **Defer** — with a concrete tracking action (an issue filed, a follow-up
  contract proposed). Deferral without one is a silent drop.
- **Escalate** — a real symptom with an unknown cause to `diagnosing`; a
  design objection with legitimate alternatives to `brainstorming`; a
  finding that would change what the work is contracted to do to the user.

Dispositions are recommendations; the user approves them with the verdicts
and labels in view, including every decline.

## The triage contract

Size it per `routing-work`: a handful of findings with local fixes is
usually light — the register stated in the conversation — while a large
batch, fixes that span sessions, or any fix on a full-tier surface
such as security makes it full. The contract records:

- the source and the full inventory count, so a reader can confirm nothing
  was dropped;
- per finding: claim, label, verdict with evidence, impact, disposition
  with rationale, and the drafted reply;
- the sweep — the patterns searched for and what surfaced;
- for the fixes: acceptance criteria, and regression risk where a fix could
  plausibly break something;
- escalations — which findings left for their own contracts.

Entries are register rows, not essays: a verdict's evidence is a citation
that closes the question. Beyond the spec rules in `routing-work`,
self-review against the inventory: every inbound finding has an entry,
every verdict cites evidence, no disposition contradicts its verdict.

## Replies

Each drafted reply is part of the contract — confirmations briefly,
declines with their full evidence-backed rationale. Approving the contract
approves what the replies say, not their publication: posting to a shared
channel is outward-facing, so confirm delivery with the user first unless
they already said to post on approval. Deliver through the channel the
review arrived on, or hand the replies to the user. Replies for fixes may
wait to reference the landed change; replies held for delivery after this
conversation make the contract one that must survive it, so it goes to a
file per `routing-work`.

## Handoff

The approved contract's fixes go to `leading-implementation`. Escalated
findings proceed through their own entry skills to their own contracts.

## Portability

Assume no specific review platform, scanner, or harness facility. Findings
arrive as a thread, a file, or a paste; replies leave the same way. The
absence of delegation or any given tool never blocks a triage.
