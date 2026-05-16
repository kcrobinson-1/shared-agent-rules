# Agent Instructions

This file is the **router** for AI coding agents working in this
repo. `shared-agent-rules` is the canonical source of the rule
modules that consumers vendor — so this repo is its own first
consumer. The rules below apply to authoring and editing the
rules themselves, not to authoring code that uses them.

The shape follows
[`library/meta/router-pattern.md`](library/meta/router-pattern.md):
universal session rules, a session-type routing table, mandatory
pre-edit reads, self-review. Because this repo is the source,
references point at `library/` directly rather than the
`docs/agents/shared/` paths a vendored consumer sees.

## Repo orientation

- [`library/`](library/) — the canonical rule modules. Every
  file here is vendored into consumers via `scripts/assemble.sh`.
  Edits ship to every consuming repo at the next CalVer tag.
- [`starter/`](starter/) — the day-one scaffolding consumers
  copy verbatim. Edits land in consumer repos at copy time, not
  re-runnable via `assemble.sh`.
- [`scripts/`](scripts/) — `assemble.sh` (vendors modules into
  consumers) and `check-vendored-links.sh` (validates the
  assembled tree end-to-end against the current working tree).
- [`proposals/`](proposals/) — type-2 (new audit) and type-3
  (rule change) proposal channel for changes that originated as
  self-review findings in consumer repos.
- [`genesis/`](genesis/) — historical audit / design /
  verification artifacts from the v0.0 build. Not living docs;
  do not edit.

## Development workflow source of truth

[`README.md`](README.md), [`VERSIONING.md`](VERSIONING.md), and
[`CHANGELOG.md`](CHANGELOG.md) jointly carry the contributor
procedure (what this repo ships, the CalVer pin scheme, what
changed at each tag). This `AGENTS.md` handles agent decision
discipline. If the two conflict, stop and report rather than
picking a side.

<!-- audit-coverage: R-02 (agent-rule vs contributor-doc conflict → stop and report) -->

## Session-type routing

Pick the row that best fits the work at hand and read the named
files. Universal rules below apply to every session and are not
enumerated in the table.

| If your session is… | Read these files |
|---|---|
| Authoring or editing a library module | [`library/workflows/implementation.md`](library/workflows/implementation.md) + [`library/meta/rule-additions.md`](library/meta/rule-additions.md) + [`library/meta/light-vs-full-thresholds.md`](library/meta/light-vs-full-thresholds.md) + [`library/meta/compound-noun-discipline.md`](library/meta/compound-noun-discipline.md) |
| Editing `starter/` scaffolding | [`library/workflows/implementation.md`](library/workflows/implementation.md) + [`library/meta/router-pattern.md`](library/meta/router-pattern.md) + run `scripts/check-vendored-links.sh` before push |
| Editing `scripts/` | [`library/workflows/implementation.md`](library/workflows/implementation.md) + [`library/validation/philosophy.md`](library/validation/philosophy.md) + [`library/self-review/seed-audits/validation-honesty.md`](library/self-review/seed-audits/validation-honesty.md) |
| Drafting a proposal in `proposals/` | [`library/meta/rule-additions.md`](library/meta/rule-additions.md) + the templates in [`proposals/`](proposals/) |
| Addressing review feedback | [`library/workflows/review-fixes.md`](library/workflows/review-fixes.md) |
| Debugging the assemble or link-check pipeline | [`library/workflows/debugging.md`](library/workflows/debugging.md) |
| Cutting a CalVer release | [`VERSIONING.md`](VERSIONING.md) + [`CHANGELOG.md`](CHANGELOG.md) |

## Mandatory pre-edit reads

Three-component form per
[`library/core/pre-edit-gate.md`](library/core/pre-edit-gate.md):
Intent describes why the trigger fires, Triggers names the paths
that fire it, Read names binding files to load before the first
edit.

### library-edit

**Intent:** Library edits ripple to every consuming repo at the
next CalVer tag. Rule additions, prose drift, and cross-reference
changes all need rule-addition discipline applied before the edit
lands.
**Triggers:** `library/**/*.md`
**Read:** [`library/meta/rule-additions.md`](library/meta/rule-additions.md), [`library/meta/compound-noun-discipline.md`](library/meta/compound-noun-discipline.md), [`library/doc-currency/currency.md`](library/doc-currency/currency.md)

### starter-edit

**Intent:** Starter content is copied verbatim into consumers
and is not re-runnable via `assemble.sh`. Edits must keep
relative links resolvable in the post-assemble layout and avoid
embedding rules-repo-specific paths.
**Triggers:** `starter/**`
**Read:** [`library/meta/router-pattern.md`](library/meta/router-pattern.md), [`library/doc-currency/ephemeral-identifiers.md`](library/doc-currency/ephemeral-identifiers.md). After edit: run `scripts/check-vendored-links.sh`.

### script-edit

**Intent:** The scripts validate library / starter content; bugs
in them mask bugs in the rules. Validation-honesty and
readiness-gate-truthfulness apply directly to the checker's own
claims.
**Triggers:** `scripts/**`
**Read:** [`library/validation/philosophy.md`](library/validation/philosophy.md), [`library/self-review/seed-audits/validation-honesty.md`](library/self-review/seed-audits/validation-honesty.md), [`library/self-review/seed-audits/readiness-gate-truthfulness.md`](library/self-review/seed-audits/readiness-gate-truthfulness.md)

## Universal session rules

Every session loads these regardless of routing-table row:

- [Pre-Edit Gate](library/core/pre-edit-gate.md)
- [Scope Guardrails and Stop-And-Report](library/core/scope-and-stop.md)
- [Change Boundaries](library/core/change-boundaries.md)
- [Anti-Patterns](library/core/anti-patterns.md)
- [Sub-Agent Delegation](library/delegation/sub-agent-delegation.md)
- [The Router Pattern](library/meta/router-pattern.md) — because every session here authors the rule system
- [Rule Additions](library/meta/rule-additions.md) — because every rule edit must pass the forced-trade-off discipline

## Self-review

Before finishing, run the audits from
[`library/self-review/seed-audits/`](library/self-review/seed-audits/)
that match the diff's surfaces. The catalog mechanism is in
[`library/self-review/mechanism.md`](library/self-review/mechanism.md);
layer the general checklist from
[`library/self-review/how-to-use.md`](library/self-review/how-to-use.md)
on top.

No separate `docs/agents/local/self-review-catalog.md` exists in
this repo — the seed audits are the catalog here. Repo-specific
audits would live in a new file at `library/self-review/audits/`,
governed by the same rule-additions discipline as any other
library change.

## PR conventions

[`library/pr-conventions/commits.md`](library/pr-conventions/commits.md)
and
[`library/pr-conventions/pr-body-shape.md`](library/pr-conventions/pr-body-shape.md)
apply — including the why-over-what discipline for PR summaries.
This repo dogfoods its own conventions; reviewers will flag PR
bodies that skip the rationale.

## Adding to this rule set

Edits to this file or any rule under `library/**` follow
[`library/meta/rule-additions.md`](library/meta/rule-additions.md):
name a rule the new rule retires or merges into, or state why no
existing rule could be retired. The forced trade-off lives in the
PR body, not in the diff.

The `proposals/` channel is where consumer-side findings get
filed before becoming `library/` content. See
[`proposals/README.md`](proposals/README.md) for the proposal
templates and lifecycle.
