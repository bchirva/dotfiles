---
name: plan-fixture
description: Use to persist an implementation or action plan for later execution, context recovery, or handoff to another agent.
---

# Plan Fixture

Persist an action plan as temporary working state for reliable execution and recovery.

## Process

1. Make the provided plan self-contained without changing its intent, scope, or decisions
2. Normalize it to the plan format below
3. Ensure it is consistent and contains no unresolved placeholders
4. Save it to a temporary project-local file `.ai-docs/YYYY-MM-DD-<taskname>.md`
5. Pass the exact file path to `task-execution`

Do not re-analyze the task or introduce new requirements.

## Plan Format

The plan must contain:

- **Goal** — expected outcome
- **Context** — relevant constraints and decisions execution must not have to infer from prior conversation
- **Steps** — ordered execution steps as Markdown checkboxes
- **Verification** — how successful completion is established

Each execution step must describe one concrete action with a checkable result:

```markdown
- [ ] Implement ...
- [ ] Update ...
- [ ] Verify ...
```

Each step must be independently actionable and specific enough to execute without relying on prior conversation context.

Include relevant files, components, commands, names, values, or interfaces when they are known and materially constrain execution.

Avoid both vague placeholders and implementation transcripts. Include only the detail needed to make execution unambiguous.

Checkboxes are persistent execution state:

- `[ ]` — pending
- `[x]` — completed and verified

## Lifecycle

The plan file is temporary working state.

Never commit or intentionally stage it.

Keep it available until execution is successfully completed. `task-execution` owns progress updates and final cleanup.
