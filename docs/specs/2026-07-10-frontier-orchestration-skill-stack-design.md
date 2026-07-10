# Frontier Orchestration Skill Stack Design

## Goal

Create a portable collection of skills for Codex and Claude Code that preserves the strongest part of Superpowers—collaborative design—while replacing its mandatory detailed-plan and task-per-agent execution pipeline with adaptive orchestration suited to frontier models.

The stack must let one persistent lead agent retain architectural and implementation context. It must use delegation selectively, prefer less-capable or lower-cost models for bounded low-risk work when the harness permits model selection, and reserve peer or frontier models for ambiguity, coupling, risk, and consequential review.

## Design principles

1. Keep durable product and architecture decisions in an approved design spec.
2. Let repository evidence determine the execution topology.
3. Preserve the lead agent's context across tightly coupled work.
4. Define work packages by cohesive, independently verifiable outcomes rather than elapsed time.
5. Delegate independent workstreams, reconnaissance, and adversarial checks—not tiny sequential edits.
6. Match delegate capability and cost to ambiguity and risk while leaving accountability with the lead.
7. Review at meaningful boundaries and verify the aggregate result against the spec.
8. Keep core instructions platform-neutral and isolate harness mechanics in small references.

## Repository structure

```text
skills/
  brainstorming/
    SKILL.md
  mapping-work/
    SKILL.md
  leading-implementation/
    SKILL.md
  delegating-workstreams/
    SKILL.md
    references/
      codex.md
      claude-code.md
  reviewing-work/
    SKILL.md
tests/
  scenarios/
```

Each directory under `skills/` is independently installable. A user may copy the collection or individual skill directories into the skills location supported by Codex or Claude Code. The collection has no plugin manifest and no required harness-specific dependency.

## Skill responsibilities

### `brainstorming`

Start from the Superpowers brainstorming skill and preserve its useful design behavior:

- inspect the current project before proposing a solution;
- clarify purpose, constraints, non-goals, and success criteria one question at a time;
- compare two or three plausible approaches;
- present the design in appropriately sized sections and obtain approval;
- cover architecture, components, data flow, failure behavior, and testing;
- write and self-review a durable design spec;
- require the user to review the written spec.

Change the terminal handoff. An approved spec transitions to `mapping-work`; it does not automatically require an exhaustive implementation plan or a task-per-agent execution workflow. The skill may recommend decomposing an oversized design into multiple specs.

The portable version must not assume a specific visual companion, documentation style skill, commit policy, or platform tool. It may use available capabilities when they improve the collaboration, but absence of those capabilities must not block design work.

### `mapping-work`

Translate an approved design spec into a repository-grounded execution strategy. Before editing, inspect the relevant code and validate the spec's technical assumptions.

Choose one of three execution modes:

1. **Coherent change:** the persistent lead implements directly.
2. **Uncertain or broad change:** bounded delegates perform read-only reconnaissance; the lead synthesizes and implements.
3. **Naturally partitioned change:** delegates own separate workstreams; the lead owns shared interfaces and integration.

Produce a concise, living execution map, normally three to eight outcome-sized work packages. Each work package records:

- intended outcome;
- dependencies;
- likely repository scope;
- relevant architectural constraints;
- acceptance criteria;
- verification;
- risks, rollout, or rollback concerns when applicable.

Do not estimate package quality by duration. Do not decompose coherent work into mechanical two-to-five-minute actions. Update the map when implementation evidence contradicts it.

A separate detailed implementation plan is conditional. Recommend one only when it has independent coordination value, such as multi-session execution, multiple owners or repositories, sequenced rollout and rollback, pre-agreed interfaces, or security, compliance, and operations risk.

### `leading-implementation`

Give one persistent lead responsibility for the implementation end to end. The lead:

- treats the approved design spec as the product and architecture contract;
- treats the execution map as a living coordination aid;
- implements coherent vertical slices while retaining learned context;
- runs focused verification after meaningful slices;
- replans when evidence invalidates an assumption;
- delegates only through `delegating-workstreams` when the work genuinely branches or an independent judgment is valuable;
- invokes `reviewing-work` at risk-appropriate boundaries and before consequential completion;
- owns shared interfaces, integration, aggregate verification, and the final report.

Escalate orchestration when repeated attempts fail, repository impact is unexpectedly broad, tests invalidate the mental model, a security-sensitive question remains uncertain, or context loss makes an independent reconstruction valuable.

### `delegating-workstreams`

Use native subagent facilities only for bounded objectives that can benefit from a separate context. Suitable objectives include:

- read-only repository reconnaissance;
- investigation of a contained subsystem;
- implementation of an isolated package behind a stable interface;
- adversarial test derivation;
- independent diagnosis;
- review of a completed logical change.

Every delegate brief contains:

- one objective;
- only the necessary context or links to durable artifacts;
- explicit file or subsystem ownership;
- constraints and non-goals;
- acceptance criteria;
- verification expectations;
- required return format;
- whether edits are allowed.

Avoid parallel edits to overlapping files. If work becomes tightly coupled or integration-heavy, return ownership to the lead.

#### Capability-tier selection

Use the strongest available model for the persistent lead. When the harness exposes model selection, assign bounded low-ambiguity, low-risk tasks to less-capable, faster, or cheaper models.

Prefer lesser models for locating files and patterns, summarizing a contained subsystem, running prescribed commands, making isolated changes behind a defined interface, producing routine tests from explicit criteria, checking mechanical consistency, and collecting evidence.

Use a peer or frontier model for ambiguous requirements, shared-interface design, broadly coupled changes, security, concurrency, migrations, destructive operations, diagnosis that may change the architecture, adversarial review, and consequential final review.

Shape each brief so the assigned model can succeed safely. The lead inspects the returned evidence and integrates the result. Delegation transfers work, not accountability. If model selection is unavailable, retain the same task-shaping rules with the available model.

### `reviewing-work`

Review complete logical slices or the aggregate implementation rather than every microscopic step. The review brief contains the approved spec, relevant diff or artifacts, verification evidence, known tradeoffs, and an explicit request to search for missing requirements and failure modes.

Evaluate in this order:

1. acceptance-criteria and spec compliance;
2. correctness and failure behavior;
3. regressions and compatibility;
4. security, concurrency, migration, and operational risks where relevant;
5. maintainability and fit with repository conventions;
6. adequacy of verification.

Classify material findings clearly. Resolve and reverify blocking findings before completion. The lead then runs the relevant full validation, inspects the aggregate diff, checks each acceptance criterion, and reports changes, evidence, and remaining uncertainty.

## Workflow and artifacts

```text
idea or requested change
        |
        v
brainstorming
        |
        v
approved design spec (durable contract)
        |
        v
mapping-work
        |
        v
execution mode + living execution map
        |
        v
leading-implementation
   |                    |
   | conditional        | risk/completion boundary
   v                    v
delegating-workstreams  reviewing-work
   |                    |
   +---------> lead <---+
                 |
                 v
       aggregate verification and report
```

The design spec is authoritative about what must be built. The execution map is intentionally revisable and records the current implementation strategy. Delegate briefs are disposable task-local contracts. Verification output and the aggregate diff are evidence, not substitutes for checking the acceptance criteria.

## Failure behavior

- If repository evidence contradicts a material spec assumption, stop the affected implementation path and resolve the product or architecture conflict with the user.
- If evidence only changes implementation sequencing, update the execution map and continue.
- If a delegate returns weak, incomplete, or unverified work, tighten the brief, raise the model tier, take the work back, or change execution mode.
- If delegate edits overlap or integration becomes tightly coupled, stop parallel edits and return ownership to the lead.
- If review finds a material defect, fix it and rerun the relevant focused and aggregate verification.
- If verification cannot establish an acceptance criterion, report the uncertainty explicitly.
- Never infer success solely from a delegate's claim or a single passing command.

## Portability

Core skill language describes operations by intent, such as starting a bounded delegate, waiting for results, or sending a follow-up. `delegating-workstreams/references/codex.md` and `delegating-workstreams/references/claude-code.md` map those intentions to each harness's available primitives and model-selection capabilities.

The core workflow must remain useful when:

- subagents are unavailable;
- parallelism is unavailable;
- delegate model selection is unavailable;
- worktrees or isolated branches are unavailable.

In those cases, the lead executes sequentially and preserves the same ownership, evidence, and review boundaries.

## Validation strategy

Validate each skill independently before moving to the next skill, then validate the stack as a whole.

### Structural validation

- valid `SKILL.md` frontmatter and directory names;
- trigger descriptions focused on when the skill applies;
- no unresolved placeholders;
- all referenced files exist;
- no platform-specific command is required by a core skill;
- skill bodies remain concise enough to load selectively.

### Behavioral scenarios

Capture baseline behavior without the new skill, then forward-test with it. Scenarios must cover:

- a coherent change where delegation would add overhead;
- a broad uncertain change where read-only reconnaissance helps;
- naturally partitioned work with non-overlapping ownership;
- a low-risk bounded task suitable for a lesser model;
- a high-risk ambiguous task requiring a peer or frontier model;
- delegate work that becomes coupled and must return to the lead;
- a failed assumption that requires replanning;
- a consequential completed change requiring independent review and aggregate verification.

Success means the agent chooses a task-shaped topology, preserves lead accountability, produces outcome-sized work packages, selects model capability proportionally, and grounds completion in evidence against the approved spec.

## Non-goals

- Reproduce the full Superpowers plugin or its mandatory skill-discovery policy.
- Require a planner, fresh implementer, and multiple reviewers for every task.
- Prescribe exact model names, pricing, or platform-specific configuration in core skills.
- Replace domain-specific engineering practices such as test-driven development or systematic debugging.
- Guarantee parallel execution when the harness or repository cannot support it safely.
- Create a plugin, marketplace package, or automatic installer.

## Acceptance criteria

1. The repository contains five independently installable skills with the responsibilities defined above.
2. `brainstorming` hands an approved written spec to `mapping-work` without mandating a detailed implementation plan.
3. `mapping-work` selects an execution mode after repository inspection and produces outcome-sized work packages.
4. `leading-implementation` preserves one lead's context and adapts the execution map from evidence.
5. `delegating-workstreams` defines bounded briefs, ownership rules, and capability-tier selection, including explicit use of lesser models when safe and supported.
6. `reviewing-work` reviews logical outcomes and aggregate behavior against the spec and verification evidence.
7. Core instructions work in both Codex and Claude Code without requiring either harness.
8. Structural and behavioral validation covers the scenarios in this design.

