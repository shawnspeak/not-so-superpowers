---
name: triaging-findings
description: Use when a batch of findings about existing work arrives from outside — a PR review, a scanner or bot report, a pasted list of issues — and must be verified and dispositioned before anything is fixed. Guides evidence-driven triage to per-finding verdicts, drafted replies, and an approved triage spec.
---

# Triaging Findings

Turn an incoming batch of findings about existing work into verified
verdicts and an approved triage spec. Inbound findings are testimony, not
truth: reviewers — human, bot, or model — report real defects, non-problems
that sound plausible, and single instances of patterns that live elsewhere
too. The output is a durable written contract for how every finding will be
answered — it is not the fixes themselves.

## Boundary

This skill is for findings that arrive from outside the session: a pull
request review, an automated scanner, a peer model's review, a list the
user pastes in. Findings produced inside an active implementation by
`reviewing-work` stay with the lead, who filters them with the labels in
view. A single problem brought as the task with an unknown cause is
`diagnosing`. Triage passes verdicts on claims; it does not explore design
spaces, and it root-causes no further than confirming or refuting the claim
in front of it — deeper work routes out (below) rather than being absorbed.

## Normalize before judging

Read the reviewed work first — the diff or artifacts the findings are
about, and the spec behind them if one exists. A finding can only be judged
against what the work was contracted to do.

Then inventory every finding, dropping nothing silently:

- restate each as claim, location, and concrete failure scenario;
- classify each with `reviewing-work`'s labels — blocking, material,
  minor — and record a finding that arrives without a failure scenario or
  evidence as an **opinion**, a label that travels with it through
  disposition;
- group findings that are coupled — same code, one change resolving
  several, fixes that would collide;
- order the triage by consequence. Comment order is the reviewer's
  narrative, not a priority ranking.

## Verify each finding

Verification is a bounded investigation with the reviewer's claim as the
starting hypothesis: confirm the failure scenario against the actual code —
construct the failing input, trace the mechanism — or refute it with
evidence. Cite the evidence either way. Every finding gets a verdict:

- **confirmed** — the failure scenario is real, with the evidence;
- **refuted** — the claimed failure cannot occur, with the evidence that
  closes it;
- **unverifiable** — what is missing to decide is named, and the finding is
  dispositioned on that honest footing.

Agreement is not a shortcut. A finding fixed without verification is how an
invalid finding becomes a real bug; evidence-backed refutation is as
legitimate an outcome as confirmation. The codebase stays unchanged during
triage — no fixing, refactoring, or cleanup while verifying.

If confirming a claim requires genuine root-cause work — the symptom is
real but its mechanism is unknown — stop verifying and route that finding
to `diagnosing` as its own investigation rather than diagnosing inside the
triage.

If the harness offers delegation, individual verifications are bounded
objectives per `delegating-workstreams` — down-tier when the failure
scenario is mechanically checkable, up-tier for security-flavored claims.
Its absence never blocks: verify sequentially with the same evidence bar.

## Assess impact and sweep the class

For each confirmed finding, record impact: what actually breaks, for whom,
and how expensive it is once shipped. The reviewer's severity is a claim
like any other.

A finding is a sample, not an enumeration. A reviewer who caught one
instance of a pattern rarely caught them all: before dispositioning, search
the codebase for other instances of each confirmed finding's pattern. What
the sweep surfaces joins the triage as findings in their own right,
attributed to the sweep and verified like the rest.

## Disposition every finding

Recommend exactly one disposition per finding, each with its rationale:

- **Fix** — with acceptance criteria. When the criteria are crisp and
  testable, name the test that encodes the finding's failure scenario —
  failing before the fix, passing after — written during implementation,
  per the failing-tests-first delegation contract.
- **Decline** — with the refuting evidence or the reasoned tradeoff,
  drafted as the reply the reviewer will read.
- **Defer** — with the concrete tracking action (an issue filed, a
  follow-up spec proposed). Deferral without a tracking action is a silent
  drop.
- **Escalate** — routed by kind: a real symptom with an unknown cause to
  `diagnosing`; a design objection where legitimate alternatives exist to
  `brainstorming`; a finding that would change what the work is contracted
  to do back to the user, because the spec never changes silently.

Dispositions are recommendations. The user approves them with the verdicts
and labels in view — including every decline.

## Write the triage spec

Write a durable triage spec to the project's documentation location (for
example `docs/specs/YYYY-MM-DD-<topic>.md` — the same convention as design
and fix specs). It records:

- the source of the findings and the full inventory count, so any reader
  can confirm nothing was dropped;
- per finding: claim, classification, verdict with evidence, impact,
  disposition with rationale, and the drafted reply;
- the sweep — what patterns were searched for and what surfaced;
- for the fixes: acceptance criteria, and regression risk where a fix could
  plausibly break something;
- non-goals — the declined and deferred findings, in brief;
- escalations — which findings left for their own specs, and where.

Per-finding entries are register rows, not essays: a verdict's evidence is
a citation that closes the question, not a replay of the verification. The
spec's completeness lives in covering every finding, not in the length of
each entry.

Self-review the spec against the inventory: every inbound finding has an
entry, every verdict cites evidence, no disposition contradicts its
verdict. Then require the user to review the written document itself.
Conversational agreement is not approval; the file is the contract.

## Replies travel with the spec

Each finding's drafted reply is part of the artifact — confirmations
briefly, declines with their full evidence-backed rationale. After
approval, deliver the replies through the channel the review arrived on,
with whatever tooling the project offers, or hand them to the user to
deliver. Replies for fixes may wait to reference the landed change;
declines and deferrals can go out on approval.

## Handoff

An approved triage spec transitions to `mapping-work`, exactly as a design
or fix spec does. Most triages will map to a coherent-change mode with few
packages — but that is mapping-work's decision, made against repository
evidence. Escalated findings proceed through their own entry skills to
their own approved specs, each on its own.

## Portability

Assume no specific review platform, scanner, or harness facility. Findings
may arrive as a thread, a file, or a paste; replies leave the same way. The
method is tool-independent — inventory, verdict, evidence, disposition —
and the absence of delegation or any given tool never blocks a triage.
