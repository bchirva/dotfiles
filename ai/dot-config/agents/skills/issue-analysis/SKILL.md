---
name: issue-analysis
description: Use before implementing a non-trivial or ambiguous task to clarify missing requirements, evaluate solution options, understand the problem, and produce an implementation plan. Skip precise mechanical tasks.
---

# Issue Analysis

Understand the task before implementing it.

## Process

1. Inspect the relevant project context, files, documentation and recent changes before asking questions
2. Decompose the task into independently executable and verifiable parts if it contains independent concerns
3. Identify missing or ambiguous requirements that materially affect the solution
4. Ask focused questions one at a time until those ambiguities are resolved
5. If multiple reasonable technical solutions exist, present their relevant trade-offs and recommend one
6. Summarize the understood goal, constraints, and expected outcome
7. Produce a concise implementation plan

## Rules

1. Do not implement until material ambiguities are resolved and the user has approved the proposed solution.
2. Use reasonable assumptions for inconsequential details. Explicitly state assumptions that affect the solution.
3. Follow existing project structure and patterns. 
4. Include targeted improvements only when they directly support the task.
5. Avoid unrelated refactoring.
6. Do not ask about information that can be determined from the project context.
7. Do not invent alternatives when one solution is clearly preferable.

## Plan

The plan should describe:
- Required changes
- Relevant files or components
- Important implementation constraints
- Chosen technical approach and important constraints
- Verification steps

Keep the plan proportional to the task. Do not create design documents or other permanent planning artifacts.

If a plan is written to a file then treat it as temporary working state and NEVER commit it

