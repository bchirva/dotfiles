---
name: task-execution
description: Use to execute a persisted action plan in the current context or through fresh subagents.
---

# Task Execution

Execute a persisted plan while keeping the plan file as the source of truth.

## Execution Mode

If the user has not already chosen a mode and subagents are available, ask once:

1. **Current context** — execute the plan here
2. **Subagent** — delegate each plan step to a fresh subagent

If subagents are unavailable, use the current context.

Keep the chosen mode for the entire plan.

## Process

1. Read the plan and identify the next unchecked step
2. Execute that step using the chosen mode
3. Verify its checkable result
4. Mark it `[x]` only after successful verification
5. Continue until no unchecked steps remain
6. Perform the plan's final verification

Do not rely on previous verification runs or success reports when fresh verification is required.

The plan file is the persistent execution state. Keep it if execution is interrupted or unsuccessful.

## Plan Authority

Follow the plan's goal, constraints, decisions, and ordered steps.

Resolve local implementation details when they do not change the agreed behavior or scope.

If execution reveals a material ambiguity, conflict, or required change to the plan's decisions or scope, stop and ask the user before continuing.

Do not silently skip, add, or materially redefine plan steps.

## Subagent Mode

The current agent remains responsible for the plan, execution order, and verification.

For each step:
- Delegate execution to a fresh subagent
- Provide only the step and the context, constraints, and prior results required to complete it
- Review the subagent's result before continuing

Do not delegate ownership of the whole plan or its execution state to a subagent.
