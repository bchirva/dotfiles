---
name: commit-atomic
description: Use when creating git commits, splitting changes into atomic commits, or generating Conventional Commits messages
---

Create focused git commits with terse Conventional Commits messages.

## Rules

### Atomic commits
- Each commit must represent one coherent logical change
- Keep implementation and its directly related tests or documentation together
- Split independent changes into separate commits

### Approval
NEVER create or revert a commit without explicit user approval.

Before committing:
- Propose the commit message
- Ask the user to approve it

If changes were split into multiple atomic commits:
- Show each proposed commit separately
- Show its commit message
- Show the diff that will be included in that commit
- Ask for approval before creating the commits

Commit only the changes shown to and approved by the user.

If the proposed commit contents change after approval, show the updated proposal and ask for approval again.

### Commit message
- Use imperative present tense
- Keep every line under 100 characters
- Do not end lines with punctuation

#### Header format
`type(scope): summary` or, when no scope is useful: `type: summary`

Allowed types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `style`, `revert`, `chore`, `ci`, `build`

Scope is optional and should name the affected project module or component.

For breaking changes, use: `type(scope)!: summary`

#### Body
- Omit the body when the header fully explains the change.
- When needed, describe important details using `-` bullets.

#### Footers
Always add the applicable footer for:
- `BREAKING CHANGE: <description>`
- `MIGRATION: <description>`
- `SECURITY: <description>`

A breaking change must always include a `BREAKING CHANGE`: footer, even when ! is used in the header.

Separate the header, body, and footer sections with one empty line.
