# Development Guide

This document is the contributor-workflow source of truth for this
repo. [`../AGENTS.md`](../AGENTS.md) handles agent decision
discipline (pre-edit gates, scope guardrails, stop-and-report
conditions); this doc handles human contributor procedure (local
setup, daily workflow, validation commands, release flow). The
two are jointly authoritative — when they conflict, stop and
report rather than picking a side.

<!--
  STARTER NOTE: this file ships with shared-agent-rules' starter
  template as a recommended section structure. Fill in the
  project-specific sections, drop any sections that don't apply
  to this repo, and add others as needed. Delete this STARTER
  NOTE comment once you've adapted the file.
-->

## Purpose

<!--
  REPO-SPECIFIC. One paragraph: what this doc covers and what it
  doesn't. Common framing:

  > How engineers work in this repository today — local setup,
  > validation, release flow, common troubleshooting. System
  > architecture lives in <architecture-doc>; UX intent in
  > <ux-doc>; agent decision discipline in `../AGENTS.md`.

  Naming the boundary against other docs avoids drift between
  this doc and the architecture/UX/agent-rule artifacts.
-->

## Current Tooling

<!--
  REPO-SPECIFIC. Inventory the tools that matter for daily work.
  Each entry: tool name + one-line role + version constraints if
  relevant. Examples:

  - **Go (1.21+)** — primary language for server and CLI binaries.
  - **SQLite** — embedded persistence; schema lives in `internal/db/`.
  - **Playwright** — end-to-end browser tests.

  Keep it short; do not duplicate canonical docs for each tool.
-->

## Repository Shape

<!--
  REPO-SPECIFIC. Top-level directories and what each contains. May
  overlap with README.md's layout section, but at finer granularity
  if useful. Each entry: directory + one-line description + link
  to area-specific README if one exists.
-->

## Local Workflow

<!--
  REPO-SPECIFIC. The clone-to-running sequence for a new
  contributor:

  1. Clone + install dependencies.
  2. Environment / secrets setup.
  3. Run dev server / build.
  4. Run tests.

  Include any quirks specific to this repo: locally-running
  Postgres, populated .env from a secrets store, docker daemon
  requirement, etc.
-->

## Validation Commands

The cadence and discipline behind validation live in
[`agents/shared/validation/philosophy.md`](agents/shared/validation/philosophy.md):
validation honesty, continuous validation, baseline failure
handling, test boundary discipline. This section names the
specific commands this repo uses to satisfy that discipline.

<!--
  REPO-SPECIFIC. Pair each command with what it checks and when
  it fires:

  - **Lint:** `<command>` — runs on every push, also in CI.
  - **Types:** `<command>` — runs before commit.
  - **Unit tests:** `<command>` — runs continuously during dev.
  - **Integration tests:** `<command>` — runs before push.
  - **E2E:** `<command>` — runs in CI; locally on demand.

  Include any baseline-validation command an agent should run
  before edits, per
  [`agents/shared/core/pre-edit-gate.md`](agents/shared/core/pre-edit-gate.md)
  "Run baseline validation."
-->

## Self-Review Before Push

Before pushing, walk the audits matching the diff's surfaces:

- **General checklist** (correctness / drift / downstream impact /
  scope discipline) —
  [`agents/shared/self-review/how-to-use.md`](agents/shared/self-review/how-to-use.md).
- **Seeded universal audits** —
  [`agents/shared/self-review/seed-audits/`](agents/shared/self-review/seed-audits/).
- **Project-specific audits** —
  [`agents/local/self-review-catalog.md`](agents/local/self-review-catalog.md);
  add audits as patterns surface (see
  [`agents/shared/self-review/mechanism.md`](agents/shared/self-review/mechanism.md)
  for the trigger-twice add / automated-coverage retire lifecycle).

## Release Flow

PR body shape and commit conventions live in
[`agents/shared/pr-conventions/`](agents/shared/pr-conventions/).
This section names the repo-specific gates and deployment trigger.

<!--
  REPO-SPECIFIC. How changes ship to production:

  1. Branch convention (main is protected? feature-branch naming?).
  2. Review requirements (CODEOWNERS, approval count).
  3. CI gates (which checks block merge).
  4. Deployment trigger (auto on merge, tag-based, manual).
  5. Post-deploy verification (smoke tests, dashboards, rollback
     procedure).
-->

## Troubleshooting

<!--
  REPO-SPECIFIC. Common integration problems and their fixes. Add
  entries as patterns recur; do not catalog every one-off bug.
  Format:

  ### <Symptom>

  **Cause:** <what is happening underneath>
  **Fix:** <what to do>
  **Example:** <link to a PR or incident if useful>

  Entries retire when an automated check or fix lands that
  prevents recurrence.
-->

## Optional sections

The sections below ship in the starter as suggestions. Keep, drop,
or rename based on this repo's needs.

### UI Review Workflow

<!--
  Only if this repo has UI. The universal pattern lives in
  [`agents/shared/workflows/ui-review.md`](agents/shared/workflows/ui-review.md);
  this section names the repo-specific viewports, browsers, capture
  flow, and any UI-testing tooling (Playwright config, screenshot
  conventions, etc.).
-->

### Fresh Deployment From A Fork

<!--
  Only if this repo supports forking with separate deployments.
  Document the bootstrap for someone setting up their own
  deployment: required env vars, secrets sources, project
  configuration on the hosting platform, DNS expectations.
-->

### Next Engineering Phase

<!--
  Forward-looking note about what is coming next. Often lives in
  a separate tracking/roadmap doc; include here only if there is
  no separate roadmap surface.
-->

---

_This file is the canonical contributor-workflow source of truth.
[`../AGENTS.md`](../AGENTS.md) references it as the "Development
workflow source of truth." When agent rules conflict with this
doc, stop and report the conflict — the two are jointly
authoritative._
