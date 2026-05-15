# Library

The rule library. Consuming repos vendor selected modules from
here via `scripts/assemble.sh` and a per-repo manifest (see
`../starter/MANIFEST.example.yaml`).

Each module folder owns one topic and ships one or a few small
Markdown files. The structure mirrors the
[design doc's module taxonomy](../README.md#library-modules):
each entry below is one folder under `library/`.

## Module map

### `core/`

Universal session rules every agent loads on every session.

- [`pre-edit-gate.md`](core/pre-edit-gate.md) — clean
  worktree, branch hygiene, read before deciding shape,
  positive-value check, baseline validation, persistence-
  layer trust boundary for new writes.
- [`scope-and-stop.md`](core/scope-and-stop.md) — queue-not-
  license; named-target as boundary; behavior-preserving
  discipline; stop-and-report conditions grouped by scope,
  contract, quality, surface state.
- [`change-boundaries.md`](core/change-boundaries.md) —
  targeted-fix-over-speculative-refactor.
- [`anti-patterns.md`](core/anti-patterns.md) — regrouped
  anti-patterns by principle (don't defer validation; don't
  let supporting artifacts drift; don't bundle unrelated
  cleanup; don't name durable artifacts after the rollout
  cycle).

### `delegation/`

- [`sub-agent-delegation.md`](delegation/sub-agent-delegation.md)
  — sub-agents inherit only what's in their prompt; two-mode
  delegation (narrow vs. include-rules-verbatim); workflow
  gates stay in the orchestrator; orchestrator catches scope
  drift.

### `workflows/`

Per-session-type playbooks.

- [`implementation.md`](workflows/implementation.md) — light
  vs. full path qualification, the two paths, execution
  rules, refactor completion proof, feature-time cleanup,
  versioning and dependency discipline.
- [`debugging.md`](workflows/debugging.md) — action informed
  by actual error, read failure surface first, mark and undo
  speculative fixes, verify baseline parity.
- [`review-fixes.md`](workflows/review-fixes.md) — rigor
  equal to original implementation, audit siblings of same
  class, new-bug check, review-thread state discipline.
- [`ui-review.md`](workflows/ui-review.md) — real browser
  pass, viewport matching product target, before/after
  capture, reusable capture flow, screenshot non-commitment.

### `self-review/`

Catalog mechanism plus universal seed audits.

- [`mechanism.md`](self-review/mechanism.md) — catalog
  format (Trigger / Check / Example), recurrence-based
  lifecycle, commit-boundary execution. **Deep meta-rule.**
- [`how-to-use.md`](self-review/how-to-use.md) — general
  checklist grouped by correctness / drift / downstream
  impact / scope discipline; trust-boundary and
  testing/tooling additions.
- [`seed-audits/`](self-review/seed-audits/) — six
  universal seed audits (effect cleanup, error surfacing for
  user-initiated mutations, validation honesty, rename-aware
  diff classification, readiness-gate truthfulness, trigger-map
  currency).

### `validation/`

- [`philosophy.md`](validation/philosophy.md) — validation
  honesty; continuous validation cadence; PR readiness;
  regression discipline; **test boundary discipline** (primary
  home, cross-referenced from `testing/`); testing-tier
  discipline; no prod credentials on laptops.

### `pr-conventions/`

- [`commits.md`](pr-conventions/commits.md) — Conventional
  Commits.
- [`pr-body-shape.md`](pr-conventions/pr-body-shape.md) —
  section schema (Summary, Why, User Behavior, Contract and
  Scope, Target Shape Evidence, Documentation, Estimate
  Deviations, UX Review, Validation, Remaining Risk); never-
  blank Remaining Risk.
- [`examples/feature-pr.md`](pr-conventions/examples/feature-pr.md)
  and [`examples/refactor-pr.md`](pr-conventions/examples/refactor-pr.md)
  — illustrative filled-in change descriptions.

### `doc-currency/`

- [`currency.md`](doc-currency/currency.md) — docs as part of
  the execution loop, status-section updates in the same
  change, per-named-doc update triggers (pattern only), Doc
  Currency PR Gate.
- [`ephemeral-identifiers.md`](doc-currency/ephemeral-identifiers.md)
  — no PR numbers, commit IDs, or other ephemeral
  coordination identifiers in durable docs.

### `code-docs/`

- [`code-comments.md`](code-docs/code-comments.md) — types
  and names as first-layer docs; required comment targets;
  file-level header questions; no comment noise.

### `testing/`

- [`principles.md`](testing/principles.md) — test high-value
  seams; one strong test at the right layer over three weak
  ones at the wrong layer; mock external boundaries, not
  core business rules; CI determinism; cross-reference to
  validation/philosophy.md for test boundary discipline.

### `meta/`

Rules about how rules are organized.

- [`router-pattern.md`](meta/router-pattern.md) — entry-
  point as router; design rationale for the starter
  skeleton. **Deep meta-rule.**
- [`rule-additions.md`](meta/rule-additions.md) — rule
  additions name what they retire or state why nothing
  could be. **Deep meta-rule.**
- [`compound-noun-discipline.md`](meta/compound-noun-discipline.md)
  — disambiguate overloaded nouns in rule prose. **Shallow
  meta-rule.**
- [`light-vs-full-thresholds.md`](meta/light-vs-full-thresholds.md)
  — name each gate's threshold when a repo has multiple
  gating layers. **Shallow meta-rule.**
- [`reality-check-examples-as-footnotes.md`](meta/reality-check-examples-as-footnotes.md)
  — broader principle in rule body; specific incidents as
  illustrative footnotes consumers can replace. **Shallow
  meta-rule.**
- [`doc-ownership-table.md`](meta/doc-ownership-table.md) —
  recommended-but-optional convention; powers the trigger-
  driven form of the doc-currency rule.

## Versioning

The library ships as one version per release. See
[`../VERSIONING.md`](../VERSIONING.md) for the CalVer policy
and [`../CHANGELOG.md`](../CHANGELOG.md) for per-version
changes.
