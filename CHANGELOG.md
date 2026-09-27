# Changelog

Consumer-visible changes per version. Versions use the CalVer
format `YYYY-MM-DD` (see [`VERSIONING.md`](VERSIONING.md)).

## Unreleased

- Review affected behaviors and invariants across relevant unchanged paths,
  including lifecycle composition and legitimate counterexamples.
- Consolidate review-fix sibling and new-bug checks into diagnosis, contract
  sweep, validation and evidence; distinguish original defects from correction
  regressions and keep external replies conditional on authorization.
- Preserve the existing audit lifecycle; no new permanent audit is added.

## v2026-05-15 — Initial release

The first shipped version. Library content derived from a
152-rule audit of an upstream codebase, restructured per the
design doc into 12 module folders.

### Library modules shipped

**core/**

- `pre-edit-gate.md` — mandatory pre-edit reads (Intent /
  Triggers / Read three-component form, with `{spec_root}` and
  drift handled by the trigger-map-currency audit at self-review
  time), worktree and branch hygiene, read-before-deciding,
  positive-value check, baseline validation, persistence-layer
  trust-boundary check, capture-uncertainty-rather-than-invent.
- `scope-and-stop.md` — queue-not-license, named-target as
  active boundary, behavior-preserving discipline, grouped
  stop-and-report conditions.
- `change-boundaries.md` — targeted-fix-over-speculative-
  refactor, favor maintainable incremental progress, shared
  source-of-truth for cross-surface correctness.
- `anti-patterns.md` — regrouped by organizing principle:
  don't defer validation; don't let supporting artifacts
  drift; don't bundle unrelated cleanup; don't name durable
  artifacts after the rollout cycle.

**delegation/**

- `sub-agent-delegation.md` — sub-agents inherit only what's
  in their prompt; two-mode delegation; workflow gates stay
  in the orchestrator; orchestrator catches scope drift.

**workflows/**

- `implementation.md` — lightweight-vs-full path qualification,
  the two paths, execution rules, refactor completion proof,
  feature-time cleanup, versioning and dependency discipline.
- `debugging.md` — action informed by actual error, mark and
  undo speculative fixes, verify baseline parity.
- `review-fixes.md` — rigor equal to original implementation,
  audit siblings of same class, new-bug check, review-thread
  state discipline.
- `ui-review.md` — real browser pass, viewport matching
  product target, before/after capture, reusable capture flow,
  screenshot non-commitment.

**self-review/**

- `mechanism.md` — catalog format, recurrence-based
  lifecycle, commit-boundary execution. (Deep meta-rule.)
- `how-to-use.md` — general checklist grouped by correctness
  / drift / downstream impact / scope discipline.
- `seed-audits/effect-cleanup.md`,
  `seed-audits/error-surfacing-user-mutations.md`,
  `seed-audits/validation-honesty.md`,
  `seed-audits/rename-aware-diff-classification.md`,
  `seed-audits/readiness-gate-truthfulness.md`,
  `seed-audits/trigger-map-currency.md` — six universal seed
  audits.

**validation/**

- `philosophy.md` — validation honesty, continuous validation,
  PR readiness, regression discipline, test boundary discipline
  (primary home), testing-tier discipline, no prod credentials
  on laptops.

**pr-conventions/**

- `commits.md` — Conventional Commits.
- `pr-body-shape.md` — section schema including Estimate
  Deviations (cross-referenced to
  `workstream-tracker/spec/`), never-blank Remaining Risk.
- `examples/feature-pr.md`, `examples/refactor-pr.md`.

**doc-currency/**

- `currency.md` — docs as part of the execution loop, status-
  section updates in the same change, per-named-doc update
  triggers (pattern only), Doc Currency PR Gate.
- `ephemeral-identifiers.md` — no PR numbers, commit IDs, or
  other ephemeral coordination identifiers in durable docs;
  cross-reference to the plan-Status-block-specific form in
  `workstream-tracker/spec/`.

**code-docs/**

- `code-comments.md` — types and names as first layer;
  required comment targets; file-level header questions; no
  comment noise.

**testing/**

- `principles.md` — high-value seams; right-layer testing;
  mock external boundaries not core rules; CI determinism;
  cross-reference to validation philosophy for test boundary
  discipline.

**meta/**

- `router-pattern.md` — entry-point as router. (Deep
  meta-rule.)
- `rule-additions.md` — rule additions name what they
  retire. (Deep meta-rule.)
- `compound-noun-discipline.md` — disambiguate overloaded
  nouns in rule prose. (Shallow meta-rule.)
- `light-vs-full-thresholds.md` — name each gate's threshold
  when a repo has multiple gating layers. (Shallow
  meta-rule.)
- `reality-check-examples-as-footnotes.md` — broader
  principle in rule body; specific incidents as illustrative
  footnotes. (Shallow meta-rule.)
- `doc-ownership-table.md` — recommended-but-optional
  convention.

### Starter

- `starter/AGENTS.md` — the router-pattern template a new
  repo copies on day one.
- `starter/docs/agents/README.md` — directory map.
- `starter/docs/agents/workflows/README.md` — placeholder
  guide for repo-specific workflow additions.
- `starter/docs/agents/reference/README.md` — placeholder
  guide for repo-specific reference constraint sets.
- `starter/docs/agents/self-review-catalog.md` — empty
  catalog seeded with imports from the shared seed audits.
- `starter/MANIFEST.example.yaml` — example consumption
  manifest with `shared_agent_rules`, `workstream_tracker_spec`,
  `spec_root_relpath`, modules list, and overlay root.
- `starter/docs/dev.md` — recommended contributor-workflow
  skeleton (Purpose / Tooling / Repo Shape / Local Workflow /
  Validation Commands / Self-Review Before Push / Release Flow /
  Troubleshooting, with optional UI Review / Fresh Deployment From
  A Fork / Next Engineering Phase). Project-specific sections as
  placeholders; shared-library cross-references pre-filled.

### Proposals

- `proposals/README.md` — channel description, including the
  lifecycle convention (active at root, accepted moved to
  `proposals/decisions/`, abandoned removed via `git rm` with
  rationale in the closing commit message).
- `proposals/template-new-audit.md`, `proposals/
  template-rule-change.md` — type-2 and type-3 templates.
- `proposals/decisions/` — design records for accepted
  proposals.

### Scripts

- `scripts/assemble.sh` — manifest-driven vendoring with
  overlay support, generated-file headers, and `{spec_root}`
  substitution so cross-references to `workstream-tracker/
  spec/` resolve correctly under any consumer layout.

### Genesis

- `genesis/audit-neighborly-rule-inventory.md`,
  `genesis/design-repo-design.md`,
  `genesis/verification-report.md` — the audit, design, and
  verification reports that produced this initial state,
  preserved for traceability of rule provenance.

### Out of scope (handled in workstream-tracker/spec/)

The audit flagged 33+ rules as plan-doc-aware; per the
design's repo boundary, these stay in
`workstream-tracker/spec/`:

- Plan-implementation cluster (read plan in full, walk
  cross-cutting invariants, rule-vs-estimate-deviation,
  Plan-to-PR Completion Gate, "fix the plan first").
- Planning cross-level core (R-78 to R-91): plans-describe-
  contracts, no-fenced-code-blocks, reviewer-fix discipline,
  Cross-Cutting Invariants section, `Verified by:`,
  anchor-preference, falsifiability check, options-into-
  shapes, "artifacts that only cite each other," `Deferred`
  semantics.
- Planning epic + milestone shapes (R-92 to R-99).
- Planning depth + promotion gates (R-100 to R-105),
  including the `In draft` / `Proposed` / `In progress` /
  `Validating` / `Landed` / `Deferred` lifecycle.
- Planning scoping-vs-plan (R-106 to R-109).
- Planning phase-plan specifics (R-110 to R-112).
