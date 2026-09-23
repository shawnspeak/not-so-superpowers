---
name: routing-work
description: Use when starting a piece of work under this stack — a feature, a change, a bug, or a batch of review findings — before brainstorming, diagnosing, triaging, or implementing. Classifies the work, sizes the process to it (direct, light, or full), and routes to the right skill. Also holds the spec rules every entry skill shares.
---

# Routing Work

Process is a cost. A one-line fix and a cross-service migration both deserve
rigor, but not the same ceremony. This skill decides how much process the
work gets; the other skills apply that decision. The tier sizes the
artifacts and approval gates, never the rigor of the method: diagnosis
still reproduces before theorizing and triage still verifies every finding,
at every tier.

## Look before sizing

Read enough of the code the request implicates to judge its real shape.
Size from that evidence, not from how the request is worded.

## Classify

- **Design-shaped** — a feature, or a problem with legitimate alternative
  solutions → `brainstorming`.
- **Defect with an unknown cause** — a bug, regression, or unexplained
  behavior → `diagnosing`. A cause is evident only when the mechanism from
  cause to symptom is already in view — not merely the line where the
  failure erupts; only then is the defect a change, not a diagnosis.
- **Batch of external findings** — a PR review, a scanner report, a pasted
  list → `triaging-findings`.
- **Clear change** — intent unambiguous, one approach obviously right —
  including a defect whose cause is evident. No entry skill is needed: at
  the direct tier it goes straight to `leading-implementation`; at the light
  or full tier this skill states the contract itself — goal, decisions,
  non-goals, acceptance criteria — under the spec rules below.

Classification picks the route; the tier comes from the sizing rules
below, never from the route.

## Size

Pick one tier: **full** if any full signal holds, **direct** if every
direct condition holds, **light** otherwise. A tier the user names
overrides the signals; it sizes the artifacts, never the route.

**Direct** — every one of these holds: the intent is unambiguous, one
approach is obviously right, the change is local — one module, or one
symbol and its uses inside the repository — it touches no public interface
(anything consumed outside the repository), schema, stored data, security,
or concurrency, and a test or command can verify it. No spec: state in a line or two what will change and
how it will be verified, then implement.

**Light** — everything between: typically the work needs a few decisions
from the user, approval of a confirmed cause and fix, or is non-local but
contained, and fits in the lead's session. Delegation does not change
that. The spec is a compact contract stated in the conversation and
approved once. No file.

**Full** — any one of these holds: the work will likely span sessions or be
handed to another session or model; it spans several subsystems or owners;
it touches a public interface, schema, data migration, authentication,
security, or a destructive operation; rollout must be sequenced; or the
user asks for a written spec. The spec is a file.

Tier changes are announced, never silent. Raise the tier the moment
evidence shows the work is bigger than sized — a hidden interface, a second
subsystem, a decision only the user can make. A light spec becomes a file
the moment the work must survive the conversation: it is ending mid-work,
it is long enough that context may be compacted before the work ends, or
implementation will run in another session or be led by a different model
than the one holding the conversation. The file records the approved
contract as approved, and the lead adds its Plan per
`leading-implementation`; it needs fresh approval only if the contract
changes.

## Spec rules (every entry skill)

A spec is a contract, not a transcript: every sentence binds the
implementation or carries evidence the next reader needs. Each entry skill
lists what its contract records; every contract ends in acceptance
criteria.

At the full tier the spec lives in the project's documentation location
(for example `docs/specs/YYYY-MM-DD-<topic>.md`) with two sections:

- **Contract** — written by the entry skill, approved by the user. It
  changes only with the user's approval.
- **Plan** — written by the implementation lead before the first change,
  per `leading-implementation`, and revised freely with a note of why. The
  entry skill leaves it for the lead.

The file must let a different session or model pick the work up cold.

Before asking for approval, self-review the contract against the
conversation or investigation: anything agreed but omitted, anything
included but never agreed or evidenced, internal contradictions. Cut prose
that neither binds nor carries evidence. Then the user approves the written
contract itself — the stated contract at the light tier, the file at the
full tier. Agreement with a discussion is not approval of a contract.

## Handoff

An approved contract goes to `leading-implementation` — directly, with no
separate planning step. A contract too large to be one coherent unit of
work is split into several, each approved on its own, with the split
agreed with the user.
