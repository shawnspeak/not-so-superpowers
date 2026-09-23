---
type: llm
focus: trace
---
PASS if all hold: the agent chose a coherent-change (single-thread) execution mode and cited the coupling between `compute_total` and its callers as the reason; the lead made the edits itself rather than handing them to subagents; the plan was written into the spec file's Plan section and is outcome-sized (a few packages at most, not a step-by-step task list); the test suite passes at the end; work was committed on a branch other than `main`; and the final report checks each acceptance criterion against evidence.
FAIL if edits were split across subagents, the plan is a micro-step list, commits landed on `main`, or completion was claimed without verification evidence.
