# Agent Instructions

This file is the **router** for AI coding agents working in this repo.
It carries the universal rules every session needs (imported from the
shared library), the session-type routing table that names which files
an agent reads for the work at hand, and pointers to the
contributor-workflow source of truth.

Per-session-type playbooks and topic-organized constraint sets live
under [`docs/agents/`](docs/agents/); see
[`docs/agents/README.md`](docs/agents/README.md) for the directory
map.

## Repo orientation

<!--
  REPO-SPECIFIC. Fill in:
  - One-paragraph description of what this repo contains.
  - A short list of top-level directories and what each contains.
  - Links to the canonical README, architecture doc, contributor-
    workflow doc, and open-questions surface. See
    docs/agents/shared/doc-currency/ephemeral-identifiers.md before
    embedding any review-surface identifiers in this section.
-->

## Development workflow source of truth

[`docs/dev.md`](docs/dev.md) is the contributor-workflow source of
truth for this repo. It handles human contributor procedure (local
setup, validation commands, release flow); this AGENTS.md handles
agent decision discipline. The two are jointly authoritative — if
they conflict, stop and report rather than picking a side.

<!--
  REPO-SPECIFIC. The starter ships docs/dev.md as a recommended
  structure; fill it in before the first agent session lands real
  changes. If you rename or relocate the contributor-workflow doc,
  update the reference above accordingly.
-->

<!-- audit-coverage: R-02 (agent-rule vs contributor-doc conflict → stop and report) -->

## Session-type routing

Pick the row that best fits the work at hand and read the named
files. Universal rules below apply to every session and are not
enumerated in the table.

| If your session is… | Read these files |
|---|---|
| Implementation work without a plan doc to consume | [`docs/agents/shared/workflows/implementation.md`](docs/agents/shared/workflows/implementation.md) |
| Implementing a documented plan | [`docs/agents/shared/workflows/implementation.md`](docs/agents/shared/workflows/implementation.md) + the plan-implementation rules from `workstream-tracker/spec/planning/task-plan.md` + the plan's own `Cross-Cutting Invariants` and named self-review audits |
| Addressing review feedback | [`docs/agents/shared/workflows/review-fixes.md`](docs/agents/shared/workflows/review-fixes.md) |
| Debugging a failing validation | [`docs/agents/shared/workflows/debugging.md`](docs/agents/shared/workflows/debugging.md) |
| UI review / screenshot capture (if applicable) | [`docs/agents/shared/workflows/ui-review.md`](docs/agents/shared/workflows/ui-review.md) |

Reference files under [`docs/agents/local/reference/`](docs/agents/local/reference/)
are topic-organized constraint sets specific to this repo. They are
not optional lookups; the workflow files name when each fires.

## Mandatory pre-edit reads

<!--
  REPO-SPECIFIC. List path-triggered reads, applying the pattern
  from docs/agents/shared/core/pre-edit-gate.md.

  Example shape:
    - `docs/agents/local/reference/architecture-guardrails.md` is
      mandatory pre-edit reading for any session whose diff
      intersects `<paths>`.
    - `docs/agents/local/reference/styling-tokens.md` is mandatory
      pre-edit reading for any session whose diff intersects
      styling surfaces.

  Treat each listed file as binding, not optional.
-->

## Universal session rules

The universal rule set lives in vendored shared modules. Every
session loads them; they are not optional.

- [Pre-Edit Gate](docs/agents/shared/core/pre-edit-gate.md)
- [Scope Guardrails and Stop-And-Report](docs/agents/shared/core/scope-and-stop.md)
- [Change Boundaries](docs/agents/shared/core/change-boundaries.md)
- [Anti-Patterns](docs/agents/shared/core/anti-patterns.md)
- [Sub-Agent Delegation](docs/agents/shared/delegation/sub-agent-delegation.md)

## Self-review

Before finishing, run the audits from
[`docs/agents/local/self-review-catalog.md`](docs/agents/local/self-review-catalog.md)
that match the diff's surfaces. The catalog mechanism is documented
in [`docs/agents/shared/self-review/mechanism.md`](docs/agents/shared/self-review/mechanism.md);
the seed audits ship under
[`docs/agents/shared/self-review/seed-audits/`](docs/agents/shared/self-review/seed-audits/);
project-specific audits live in the local catalog.

Layer the general self-review checklist from
[`docs/agents/shared/self-review/how-to-use.md`](docs/agents/shared/self-review/how-to-use.md)
on top of the catalog walk.

## Adding to this rule set

Changes that add or modify rule content under
[`docs/agents/local/**`](docs/agents/local/) or this file must
follow
[`docs/agents/shared/meta/rule-additions.md`](docs/agents/shared/meta/rule-additions.md):
name a rule the new rule retires or merges into, or state why no
existing rule could be retired.

The shared modules under
[`docs/agents/shared/**`](docs/agents/shared/) are vendored
output; do not edit them directly. To change shared content,
file a proposal upstream (see
`shared-agent-rules/proposals/` in the shared repo).
