# shared-agent-rules — Repo Design

Design doc for the structure of the `shared-agent-rules` repo. Input
to phase 3 (creating files and populating with rules). Primary
upstream input: the 152-rule audit of `neighborly-scavenger-game`
at `audit/neighborly-rule-inventory.md`.

Rule IDs in this doc are audit IDs (`R-NN`) unless otherwise marked.

---

## 1. Overview

`shared-agent-rules` is a vendor-and-consume library of agent/dev
rules that new repositories adopt on day one so they start with a
worked-through set of universal session disciplines, workflow
playbooks, and rule-authoring meta-conventions, instead of growing
each one from scratch.

The repo ships three layers:

1. **A library of rule modules** — one folder per topic
   (`pre-edit-gate`, `scope-and-stop`, `delegation`, `debugging`,
   etc.). Each module is one or a few small markdown files.
2. **A starter `AGENTS.md` template** — the per-repo entry point a
   new repo copies and fills in. It includes a routing table, a
   universal-rules section that imports from the library, and
   placeholder sections for repo-specific content (repo
   orientation, validation commands, doc inventory).
3. **A small set of meta-conventions** — rule-authoring rules, the
   self-review catalog mechanism, the proposal-channels surface,
   and the per-repo consumption flow (vendor + small build
   script).

The boundary with `workstream-tracker/spec/` is **load-bearing**.
`spec/` owns everything plan-doc-aware: plan-tree taxonomy, the
canonical `Status` lifecycle (`In draft` → `Proposed` → `In
progress` → `Validating` → `Landed` / `Deferred`), the
`In draft` → `Proposed` promotion gate, the Plan-to-PR Completion
Gate, `Verified by:` annotations, `Cross-Cutting Invariants`
sections, the scoping-vs-plan split, the Estimate Deviations
callout, `Deferred` semantics — every rule whose body references
plan docs, plan status, or workstream-tracker vocabulary.
`shared-agent-rules` owns everything else.

Goal: a new repo's day-one `AGENTS.md` plus a small
`docs/agents/` tree is a `cp -r` plus a 10-minute fill-in, not a
weekend.

---

## 2. Repo boundary principle

**Formal statement.**

> A rule belongs to `shared-agent-rules` if its content is about
> session discipline, workflow playbooks, code-level conventions,
> PR shape, or rule-authoring meta. A rule belongs to
> `workstream-tracker/spec/` if its content is about authoring or
> maintaining plan docs — the plan-tree taxonomy, the
> `In draft` / `Proposed` / `In progress` / `Validating` /
> `Landed` / `Deferred` lifecycle, plan promotion gates, the
> Plan-to-PR Completion Gate, the Estimate Deviations PR callout,
> `Cross-Cutting Invariants` sections, `Verified by:` annotations,
> scoping-vs-plan splits, or any other workstream-tracker
> vocabulary.
>
> The boundary is about content ownership, not isolation:
> `shared-agent-rules` may reference `workstream-tracker` concepts
> freely. See section 2.5 (assumed deployment shape) for the
> underlying assumption.

Cross-referencing across the boundary is encouraged. When a
`shared-agent-rules` rule references a workstream-tracker concept,
it does so directly — no "if the consumer uses plans" hedge —
because every consumer is assumed to have both libraries vendored.
The self-review catalog hooks into plan-time audit naming
directly; the PR body shape includes the Estimate Deviations
section directly; the implementation workflow routes to
plan-implementation rules when a plan exists.

### Rules the boundary moves to `workstream-tracker/spec/`

The audit flagged 33+ rules as `already-in-workstream-tracker-spec`.
The boundary routes the following audit rules (cluster + IDs) to
`workstream-tracker/spec/` and **out** of `shared-agent-rules`:

- **Plan-implementation cluster (R-58 to R-62).** Reading the plan
  in full; walking cross-cutting invariants at every call site;
  rule-vs-estimate-deviation distinction; Plan-to-PR Completion
  Gate; "when the plan says X but reality is Y, fix the plan first."
- **Planning cross-level core (R-78 to R-91).** Plans-describe-
  contracts altitude rule; no-fenced-code-blocks; reviewer-fix
  discipline; plan-doc review stance; Cross-Cutting Invariants
  section; section variance disclosure; rules-vs-estimates
  labeling; `Verified by:` annotations; symbol-vs-line-range
  anchor preference; exact-match label discipline; falsifiability
  check; options-into-shapes decomposition; "artifacts that only
  cite each other" anti-pattern; `Deferred` status semantics.
- **Planning epic + milestone shapes (R-92 to R-99).** Epic scope;
  per-milestone-detail tagging; epic required/optional sections;
  milestone session anti-goal; phase dependency graph (Mermaid
  flowchart); read-actual-code for cross-phase decisions;
  defer-rather-than-over-resolve; PR-count predictions are not
  contracts.
- **Planning depth + promotion gates (R-100 to R-105).** Picker
  discriminator (independent value vs sequence steps); Planning
  Depth; decision-completeness; name self-review audits in the
  plan; just-in-time scoping with cited pending inputs; the
  `In draft` → `Proposed` flip and full lifecycle.
- **Planning scoping-vs-plan (R-106 to R-109).** Scoping owns /
  plan owns split; reality-check pass; prefer wrapper scripts
  when naming validation in plans; spike-before-plan.
- **Planning phase-plan specifics (R-110 to R-112).** PR-count
  branch test; "bans on surface require rendering the
  consequence"; URL retarget re-audit.

These are flagged in the audit either as
`already-in-workstream-tracker-spec` or as planning-layer rules
whose body presumes a plan-doc system. None enter
`shared-agent-rules`. Their phase-3 disposition is "out of scope;
already covered (or to be covered) by `workstream-tracker/spec/`."

The `Estimate Deviations` rule (R-60-adjacent) and the
`Deferred` status semantics (R-91) are explicitly out of scope per
the locked-in decisions; both move to `workstream-tracker/spec/`.

---

## 2.5 Assumed deployment shape

For the foreseeable future, every consumer of `shared-agent-rules`
also adopts `workstream-tracker/spec/`. The two repos are designed
to be vendored together as a single coherent agent-rule layer.

This assumption simplifies the design:

- `shared-agent-rules` may freely reference `workstream-tracker`
  concepts (plan docs, Status lifecycle, scoping docs).
- The starter template is unconditional: plan-implementation rows
  ship in the routing table without an "if this repo uses plans"
  qualifier.
- Cross-cutting rules (e.g., PR body shape including an Estimate
  Deviations section) can live in `shared-agent-rules` with
  cross-references to `spec/` for plan-doc-specific logic.

**Revisit trigger.** If a consumer surfaces with
`shared-agent-rules` adoption but no `workstream-tracker/spec/`
(or vice versa), the strict-boundary version of the principle
above is the fallback. Until then, the perfect-circle assumption
is the operating mode.

---

## 3. Directory structure

```
shared-agent-rules/
├── README.md                       # what this repo is, who uses it, quick-start
├── VERSIONING.md                   # version policy (single CalVer-shaped tag)
├── CHANGELOG.md                    # consumer-visible changes
│
├── library/                        # the rule library; consumers vendor from here
│   ├── README.md                   # module map
│   │
│   ├── core/                       # universal session rules
│   │   ├── pre-edit-gate.md        # R-04 to R-09
│   │   ├── scope-and-stop.md       # R-10 to R-19, R-29, R-30
│   │   ├── change-boundaries.md    # R-23, R-28
│   │   └── anti-patterns.md        # R-20, R-21, R-22 (regrouped)
│   │
│   ├── delegation/                 # sub-agent delegation
│   │   └── sub-agent-delegation.md # R-24, R-25, R-26, R-27
│   │
│   ├── workflows/                  # per-session-type playbooks
│   │   ├── implementation.md       # R-33 to R-52 (light + full + execution + refactor + cleanup)
│   │   ├── debugging.md            # R-63 to R-67
│   │   ├── review-fixes.md         # R-68 to R-71
│   │   └── ui-review.md            # R-72 to R-77
│   │
│   ├── self-review/                # the catalog mechanism + seed audits
│   │   ├── mechanism.md            # R-137 to R-141 (deep meta)
│   │   ├── how-to-use.md           # R-53, R-54, R-55, R-56, R-57 (general checklist)
│   │   └── seed-audits/            # 3-5 universal seed audits
│   │       ├── effect-cleanup.md
│   │       ├── error-surfacing-user-mutations.md
│   │       ├── validation-honesty.md
│   │       ├── rename-aware-diff-classification.md
│   │       └── readiness-gate-truthfulness.md
│   │
│   ├── validation/                 # validation philosophy (commands stay per-repo)
│   │   └── philosophy.md           # R-122 (kernel), R-127, R-128, R-129, R-130, R-131, R-132, R-133, R-134, R-135, R-136
│   │
│   ├── pr-conventions/             # PR shape, commit conventions
│   │   ├── commits.md              # R-124
│   │   ├── pr-body-shape.md        # R-125 (schema, not template), R-126, R-127
│   │   └── examples/
│   │       ├── feature-pr.md       # one filled illustration
│   │       └── refactor-pr.md      # one filled illustration
│   │
│   ├── doc-currency/               # documentation drift discipline
│   │   ├── currency.md             # R-119, R-120, R-121, R-122 (currency gate)
│   │   └── ephemeral-identifiers.md # R-123
│   │
│   ├── code-docs/                  # in-code documentation
│   │   └── code-comments.md        # R-143, R-144, R-145, R-146
│   │
│   ├── testing/                    # test-design discipline (not commands)
│   │   └── principles.md           # R-149, R-150, R-151, R-152, R-134 (test boundary)
│   │
│   └── meta/                       # rules about how rules are organized
│       ├── router-pattern.md       # R-01 (deep meta): AGENTS.md as router
│       ├── rule-additions.md       # R-31 (deep meta): name what's retired
│       ├── compound-noun-discipline.md # R-114 (shallow meta, generalized)
│       ├── light-vs-full-thresholds.md # R-34 (shallow meta)
│       ├── reality-check-examples-as-footnotes.md # the audit's "forensic rules become footnotes" pattern
│       └── doc-ownership-table.md  # optional convention; R-121 carrier
│
├── starter/                        # the day-one template a new repo copies
│   ├── AGENTS.md                   # the entry-point template (see §8)
│   ├── docs/
│   │   └── agents/
│   │       ├── README.md           # directory map (template)
│   │       ├── workflows/          # placeholder files that import library
│   │       ├── reference/          # placeholder for repo-specific constraints
│   │       └── self-review-catalog.md # empty catalog seeded with library audits
│   └── MANIFEST.example.yaml       # example consumption manifest (see §6)
│
├── proposals/                      # incoming proposal channel (see §7)
│   ├── README.md                   # what proposals look like
│   ├── template-new-audit.md       # type-2 proposal template
│   └── template-rule-change.md     # type-3 proposal template
│
└── scripts/
    └── assemble.sh                 # tiny script: read MANIFEST, vendor selected modules
```

**Notes on layout choices.**

- `library/` vs `starter/` split is deliberate: `library/` is what
  consumers reference; `starter/` is what they copy. Keeping them
  separate prevents the template from being mistaken for the
  authoritative rule source and prevents starter-template churn
  from polluting library version history.
- `library/meta/` is the deep-meta-rule home. It has its own
  authority structure: changes here are rare and reviewed against
  the rule-additions discipline (R-31 promoted to deep meta).
- `proposals/` is a directory rather than an issue tracker because
  the simplest viable channel is a PR-with-label against this
  repo. See §7.

---

## 4. Module taxonomy

Twelve modules. Each gets a sentence of purpose, a list of audit
rule IDs assigned to it, and a one-line note on relationships to
other modules.

### 4.1 `core/pre-edit-gate.md`
- **Purpose.** The discipline an agent runs before the first edit
  of any non-trivial change: clean worktree, branch hygiene, read
  before deciding, confirm positive value, run baseline
  validation, trust-boundary check for new persistent writes.
- **Assigned rules.** R-04 (path-triggered pre-edit reads —
  generalize the *pattern*; consuming repo names its own paths),
  R-05 (clean worktree, branch hygiene; "main" generalized to
  "trunk/default branch"), R-06 (read before deciding shape),
  R-07 (positive-value check), R-08 (baseline validation; stop
  on failure), R-09 (DB-level enforcement generalized to
  "persistence-layer trust boundary").
- **Relations.** R-04 references the per-repo "mandatory pre-edit
  reads" surface, which the starter template's
  `docs/agents/reference/` placeholder owns. R-08 hooks into
  `validation/philosophy.md` for the "baseline" concept.

### 4.2 `core/scope-and-stop.md`
- **Purpose.** Scope guardrails, named-target-as-boundary,
  behavior-preserving discipline, and stop-and-report conditions
  — the load-bearing "don't expand, stop and report" rule set.
- **Assigned rules.** R-10 (queue, not license), R-11 (one slice
  per branch), R-12 (combine only on shared surface), R-13
  (record sequence; execute first slice), R-14 (stop when slice
  grows beyond one "cohesive reviewable change"; "PR" replaced
  with the generalized term), R-15 (stop on scope expansion),
  R-16 (fresh thread for next slice), R-17 (named target as
  active boundary), R-18 (behavior-preserving), R-19 (clean
  worktree on stop; identify partial state), R-29
  (consolidated stop-and-report list; the audit's flag of
  "laundry-list-style" handled by sub-grouping into scope /
  contract / quality / surface).
- **Relations.** R-29's regrouping (per audit note 8) is the
  one structural rewrite in this module. Cross-references
  `delegation/` for the "orchestrator catches sub-agent drift"
  case.

### 4.3 `core/change-boundaries.md`
- **Purpose.** Prefer targeted fixes over speculative refactors;
  generalized statement of "favor maintainable incremental
  progress."
- **Assigned rules.** R-23 (targeted fixes; no new
  frameworks/services unless task calls for it), R-28
  (generalized form of "favor clarity, reliability,
  maintainable incremental progress"; project-phase-superseded
  framing dropped).
- **Relations.** Lightweight module; intentionally short.

### 4.4 `core/anti-patterns.md`
- **Purpose.** Regrouped anti-patterns. The audit's note 8
  observation — that the laundry list fires inconsistently —
  drives the rewrite. Groups: *don't defer validation*, *don't
  let supporting artifacts drift*, *don't bundle unrelated
  cleanup*, *don't name durable artifacts after the rollout
  cycle that produced them*.
- **Assigned rules.** R-20 (one-shot refactors with no plan),
  R-21 (tests-lag / deferred-validation / undocumented-moves
  / combined-cleanup / final-commit-drift-cleanup /
  skipped-workflow grab-bag, regrouped per the audit's
  recommendation), R-22 (phase-named files; generalized to
  "durable artifacts named by what they are, not by the rollout
  cycle"; the pgTAP example is demoted to an illustrative
  footnote per the locked-in "forensic rules become footnotes"
  pattern).
- **Relations.** Cross-references `core/scope-and-stop.md` for
  the "don't bundle" item.

### 4.5 `delegation/sub-agent-delegation.md`
- **Purpose.** Standalone module per the locked-in decision —
  not appendix to core. Covers when to delegate (narrow scope
  vs. broader scope), what counts as narrow, what to include
  in delegated prompts, and where workflow gates belong.
- **Assigned rules.** R-24 (sub-agents don't inherit AGENTS.md;
  generalized to "sub-agents inherit only what's explicitly in
  their prompt"), R-25 (two-mode delegation: narrow OR include
  rules verbatim; "do not write 'follow AGENTS.md'"), R-26
  (workflow gates stay in the orchestrator; PR creation
  generalized to "change-landing actions"), R-27 (orchestrator
  catches scope drift).
- **Relations.** Workflow gates (commit, branch creation,
  validation runs, self-review) all reference modules under
  `workflows/` and `self-review/`.

### 4.6 `workflows/implementation.md`
- **Purpose.** The light-vs-full execution playbook for
  implementation sessions. Three sub-sections: lightweight path
  qualification + checklist; full structured path; execution
  rules (constraint-driven, multi-step hygiene); refactor
  completion proof; feature-time cleanup.
- **Assigned rules.** R-33 (lightweight qualification; the
  5-criteria *structure* is shipped, the specific thresholds
  noted as repo-tunable), R-34 (light-vs-full thresholds
  stricter than narrow-surface — but this is moved to
  `meta/light-vs-full-thresholds.md` since the meta-rule is
  about *naming* multiple gating layers explicitly), R-35
  (lightweight 5-step checklist), R-36 (full structured
  11-step checklist; the "delete/convert temp planning docs"
  step relaxed to "delete/convert any local checklist or notes"
  since `temp planning docs` is plan-system vocabulary), R-37
  (constraint-driven over open-ended refactor), R-38 (don't
  batch into one large transformation), R-39 (local checklist
  hygiene; "remove or finalize before handoff"), R-40 (don't
  leave implementation only on the working tree on main), R-41
  (multi-subsystem changes ship as multiple commits), R-42 to
  R-48 (refactor completion proof block — keep as-is), R-49 to
  R-51 (feature-time cleanup; R-50's project-specific filename
  replaced with "the repo's designated follow-up tracking
  surface"), R-52 (versioning and dependency discipline).
- **Relations.** Cross-references `validation/philosophy.md`
  for continuous validation cadence and `self-review/` for the
  self-review step.

### 4.7 `workflows/debugging.md`
- **Purpose.** Debugging discipline for failing validations.
  Action informed by actual error, not hypothesis. Stop after
  one speculative attempt; mark speculative fixes as such;
  undo speculative commits after finding the real cause;
  verify local-vs-CI baseline divergence.
- **Assigned rules.** R-63 (action informed by actual error),
  R-64 (read the failure-comment first; stop after one
  speculative attempt; the "CI failure comment" carrier
  generalized to "the failure surface the validation produced
  — log, comment, summary, stack trace"), R-65 (mark
  speculative fixes in commit body), R-66 (undo speculative
  commits after finding cause), R-67 (verify local environment
  matches CI baseline; the pgTAP examples demoted to
  footnotes).
- **Relations.** Cross-references `core/pre-edit-gate.md`
  R-08 for the "baseline validation failed" entry condition.

### 4.8 `workflows/review-fixes.md`
- **Purpose.** Discipline applied when responding to PR review
  feedback. Same diligence as original; audit for siblings of
  the surfaced class; new-bug check; thread-state hygiene.
- **Assigned rules.** R-68 (review-fix rigor), R-69 (after
  fixing, audit siblings of same class), R-70 ("what new bug
  could this create? could this make a successful op look
  failed?"), R-71 (review-thread state discipline;
  GitHub-specific phrasings generalized — "the review
  surface" — with GitHub as illustrative example).
- **Relations.** Cross-references `self-review/` because most
  audit categories that the catalog would have caught will
  also surface review feedback.

### 4.9 `workflows/ui-review.md`
- **Purpose.** UI review discipline: real-browser pass over
  visual guesses, viewport matching product target, before/
  after capture, reusable capture flow, screenshot
  non-commitment.
- **Assigned rules.** R-72 (prefer real browser pass +
  Playwright over code-only guesses; Playwright cited as
  recommended-but-not-mandatory), R-73 (viewport matching
  product's primary target; the "mobile-first" framing
  generalized), R-74 (before/after capture for material UX
  changes), R-75 (reusable capture script over one-offs;
  paths repo-specific), R-76 (screenshots not committed),
  R-77 (PR screenshots via external host; the catbox.moe
  example demoted to footnote).
- **Relations.** Standalone.

### 4.10 `self-review/` (mechanism + seed audits)
- **Purpose.** The catalog *mechanism* (Trigger / Check /
  Example entry format, recurrence-based lifecycle, run at
  every commit boundary), the general self-review checklist
  every session runs, and a small seed catalog of universal
  audits. Wires into the proposal channels (see §7) for
  type-2 and type-3 outputs.
- **Assigned rules.**
  - `mechanism.md` (deep meta): R-137 (catalog purpose), R-138
    (lifecycle: add at 2+ recurrences; drop when automated check
    covers it), R-139 (entry format: Trigger/Check/Example),
    R-140 (short triggers beat elaborate ones), R-141 (run at
    every commit boundary).
  - `how-to-use.md`: R-53 (walk named audits matching diff
    surface; the catalog-filename carrier generalized), R-54
    (general self-review list, regrouped by correctness /
    drift / downstream impact per audit note 8), R-55 (bounded-
    task confirms: scope, target shape, behavior change,
    handoff), R-56 (trust-boundary additions; quiz-specific
    examples removed), R-57 (testing/tooling additions,
    multi-commit review).
  - `seed-audits/`: five seed audits drawn from the universal
    end of neighborly's catalog:
    - **effect-cleanup** (any effect that subscribes / opens /
      schedules / installs a listener has a matching cleanup
      on every exit path).
    - **error-surfacing-user-mutations** (user-initiated
      mutations surface errors back to the user; silent failure
      is the trap).
    - **validation-honesty** (R-130 lifted into audit form: the
      claim a check ran is only valid if the check ran).
    - **rename-aware-diff-classification** (renames that
      tooling treats as add+delete need a hand-classification
      pass before "no behavior changed" claims).
    - **readiness-gate-truthfulness** (a gate that announces
      readiness must actually verify the named conditions, not
      announce on best-effort).
- **Relations.** Hooks into `proposals/` for outputs that
  produce a proposal. Hooks (optionally) into a plan-doc
  system via the "if the repo uses plan docs, name catalog
  audits at plan time" optional integration.

### 4.11 `validation/philosophy.md`
- **Purpose.** The universal validation discipline — honest
  about what ran, continuous cadence, regression discipline,
  PR readiness, test boundary, testing tiers, no-prod-creds-
  on-laptops. **Commands stay in the consuming repo**; the
  audit's split of "validation philosophy" vs. "validation
  surface" is honored.
- **Assigned rules.** R-122 (doc-currency-is-a-PR-gate kernel —
  but the *currency* part is in `doc-currency/`; this module
  takes the gate-cadence kernel), R-127 (validation-section
  honesty), R-128 (run checks relevant to area), R-129 (if
  check can't be run, say so), R-130 (validation honesty list),
  R-131 (continuous validation cadence), R-132 (PR readiness:
  not speculative drafts), R-133 (regression discipline; ops
  + product), R-134 (test boundary), R-135 (gate only on
  pre-merge-executable tiers), R-136 (no prod credentials on
  laptops).
- **Relations.** Cross-references `core/pre-edit-gate.md` and
  `workflows/implementation.md`.

### 4.12 `pr-conventions/`
- **Purpose.** PR shape (section schema, not verbatim
  template), commit conventions, illustrative example PR
  bodies. Per locked-in decision: ship the schema, drop the
  template; ship 1-2 example PR bodies.
- **Assigned rules.**
  - `commits.md`: R-124 (Conventional Commits).
  - `pr-body-shape.md`: R-125 (section schema — Summary, Why,
    Contract / Scope, Target Shape Evidence, Documentation,
    Validation, Remaining Risk; **the Estimate Deviations
    section is excluded** — it's plan-system-aware and lives
    in `workstream-tracker/spec/`); R-126 (never leave
    Remaining Risk blank); R-127 (validation honesty in PR
    body; the same rule as in `validation/philosophy.md` —
    cross-reference rather than restate).
  - `examples/feature-pr.md` and `examples/refactor-pr.md`:
    two illustrative filled-in bodies. Genericized.
- **Relations.** Cross-references `validation/philosophy.md`.

### 4.13 `doc-currency/`
- **Purpose.** Two split files. `currency.md` carries the
  durable-docs-stay-synchronized-with-implementation
  discipline. `ephemeral-identifiers.md` carries the
  PR-numbers-and-commit-IDs-do-not-belong-in-durable-docs rule.
- **Assigned rules.**
  - `currency.md`: R-119 (keep docs synchronized; multi-file
    work makes docs part of the execution loop), R-120
    (status-oriented sections updated in same change), R-121
    (per-named-doc update triggers — the *pattern* is shipped;
    the doc list lives per-repo; this module depends on the
    optional Doc Ownership table convention in
    `meta/doc-ownership-table.md`), R-122 (doc-currency-is-a-
    PR-gate, currency aspect).
  - `ephemeral-identifiers.md`: R-123 (ephemeral identifiers
    in durable docs).
- **Relations.** `currency.md` depends on the optional Doc
  Ownership table convention; repos that skip adopting it
  can't use the trigger-driven version, only the general
  principle. The dependency is stated explicitly.

### 4.14 `code-docs/code-comments.md`
- **Purpose.** In-code documentation discipline: first layer is
  types and names, comments where contract / intent / failure
  behavior is non-obvious, file-level headers answer "what is
  this responsible for / not own," no comment noise.
- **Assigned rules.** R-143 (code documentation standard), R-144
  (required comment targets; the trust/persistence/auth
  boundaries kept, project-specific layers regrouped), R-145
  (no comment noise; no phase-tracking-in-comments — the
  duplicate-of-R-119 flag handled by cross-reference), R-146
  (file-level header questions).
- **Relations.** Cross-references `doc-currency/`.

### 4.15 `testing/principles.md`
- **Purpose.** Test design discipline: test the seams where
  bugs would actually hurt; prefer strong tests at the right
  layer over weak tests at the wrong layer; mock external
  boundaries, not business rules; CI determinism.
- **Assigned rules.** R-149 (test high-value seams; quiz
  examples replaced with one-line guidance on identifying
  seams), R-150 (one strong test at the right layer over
  three weak ones at the wrong layer), R-151 (mock external
  boundaries, not core business rules), R-152 (CI
  determinism; specific Supabase example demoted to footnote),
  cross-ref R-134 (test boundary discipline lives in
  `validation/philosophy.md`; testing principles
  cross-references it).
- **Relations.** Cross-references `validation/philosophy.md`.

### 4.16 `meta/` (deep + shallow meta-rules)
- **Purpose.** Rules about how rules are organized. Separate
  authority structure: changes here are rare. Holds the
  router pattern, rule-addition discipline, compound-noun
  discipline, light-vs-full-thresholds meta, the
  forensic-rules-as-footnotes pattern, and the optional Doc
  Ownership table convention.
- **Assigned rules.**
  - `router-pattern.md` (deep meta): R-01 (AGENTS.md is the
    router; topic files live elsewhere). Generalized to "every
    consuming repo has one entry point that names universal
    rules + routes to per-session-type playbooks + names
    constraint sets to load at the right session moment."
  - `rule-additions.md` (deep meta): R-31 (a PR that adds a
    rule must name what it replaces or state why nothing
    could be retired). The "PR body" carrier generalized to
    "the change description." Excludes R-32 (roadmap-fit
    analysis) per audit recommendation — too project-flavored
    to ship by default.
  - `compound-noun-discipline.md` (shallow meta): R-114
    generalized per locked-in decision: "any noun in rule
    prose with both narrow and broad meanings needs explicit
    disambiguation." Neighborly's plan/task examples shipped
    as illustrative footnotes; consumers apply the principle
    to their own overloaded nouns.
  - `light-vs-full-thresholds.md` (shallow meta): R-34
    generalized: "when a repo has multiple gating layers, name
    each gate's threshold and call out where the thresholds
    differ — conflation across layers is the recurring
    failure mode."
  - `reality-check-examples-as-footnotes.md` (shallow meta):
    formalizes the audit's pattern (per audit note 9). Rule
    bodies state the broader principle; specific incidents
    that birthed the rule live as illustrative footnotes
    consumers can replace with their own war stories. Cites
    the demoted examples in this design as the canonical
    application of the pattern.
  - `doc-ownership-table.md` (optional convention): the
    recommended-but-optional Doc Ownership table pattern
    (per-doc canonical owner with update-trigger column).
    `doc-currency/currency.md` (R-121) names this as a
    dependency: repos that skip it can use the general
    currency rule but not the trigger-driven application.
- **Relations.** `router-pattern.md` is the design rationale
  for `starter/AGENTS.md`. `compound-noun-discipline.md`
  applies to all rule prose written in this repo and in
  consuming repos.

**Module count.** 16 files across 12 top-level module folders.
The taxonomy above describes the 12 folders + the meta module
breakdown.

---

## 5. Deep vs shallow meta-rules

**Deep meta-rules** are rules about how the rule system itself
is organized — they govern the authoring of rules, the
maintenance of the catalog, the structure of the router. Changes
to deep meta-rules ripple across every consumer. They live in
`library/meta/` (alongside the router-pattern and rule-additions
rules) and `library/self-review/mechanism.md` (the catalog
mechanism itself). Authority: changes need stronger justification
than changes to a content rule; the proposal channel for them
(type-3 in §7) attaches firing context.

**Shallow meta-rules** are rules about how rule prose is written
or how a consuming repo applies the framework — they're
content-level rules that any consumer can apply to its own
custom rules. They live in `library/meta/` too but are
**applicable per-repo**: a consumer adds rules to its own
`docs/agents/` and applies the shallow meta-rules
(compound-noun discipline, light-vs-full thresholds naming,
forensic-examples-as-footnotes) when authoring them.

Concrete proposal for each:

- **Deep meta examples.** `meta/router-pattern.md` (the
  AGENTS.md-as-router structural pattern itself);
  `meta/rule-additions.md` (forcing trade-off articulation at
  rule-addition time); `self-review/mechanism.md` (the catalog
  format and lifecycle).

- **Shallow meta examples.**
  `meta/compound-noun-discipline.md` (apply to any overloaded
  noun in rule prose); `meta/light-vs-full-thresholds.md`
  (apply when a repo has multiple gating layers); 
  `meta/reality-check-examples-as-footnotes.md` (apply to
  forensic rules).

The split matters at consumption time: deep meta-rules are
imported wholesale; shallow meta-rules are referenced when the
consumer writes its own rules. The starter template imports the
deep set and points at the shallow set as "read these when you
add rules of your own."

---

## 6. Consumption mechanism

**Recommendation: vendoring + a small assemble script.**

Each consuming repo holds a copy of the modules it consumes,
under its own `docs/agents/shared/` directory, regenerated by
running `scripts/assemble.sh` against a manifest.

This is the simplest viable approach. Bias toward simplicity is
explicit per the locked-in working notes: vendoring + small
build script beats a package-manager scheme until there are 4+
consumers. At that point, revisit.

### 6.1 Manifest format (YAML)

A consuming repo carries a `docs/agents/shared.manifest.yaml`
file naming which modules to vendor and the upstream version
they were vendored from.

```yaml
# docs/agents/shared.manifest.yaml in a consuming repo
shared_agent_rules:
  source: github.com/<org>/shared-agent-rules
  version: 2026-05-15            # CalVer-shaped tag from the shared repo

workstream_tracker_spec:
  source: github.com/<org>/workstream-tracker
  version: 2026-05-15            # spec/ tracked at the workstream-tracker repo tag

modules:
  # Core (recommended, but each opt-in)
  - core/pre-edit-gate
  - core/scope-and-stop
  - core/change-boundaries
  - core/anti-patterns

  # Delegation
  - delegation/sub-agent-delegation

  # Workflows — opt in only what the repo uses
  - workflows/implementation
  - workflows/debugging
  - workflows/review-fixes
  # - workflows/ui-review     # opt out; repo has no UI

  # Self-review (catalog mechanism + seed audits)
  - self-review/mechanism
  - self-review/how-to-use
  - self-review/seed-audits/effect-cleanup
  - self-review/seed-audits/error-surfacing-user-mutations
  - self-review/seed-audits/validation-honesty
  # - self-review/seed-audits/rename-aware-diff-classification   # opt out
  # - self-review/seed-audits/readiness-gate-truthfulness        # opt out

  # Validation, PR, doc-currency, code-docs, testing
  - validation/philosophy
  - pr-conventions/commits
  - pr-conventions/pr-body-shape
  - doc-currency/currency
  - doc-currency/ephemeral-identifiers
  - code-docs/code-comments
  - testing/principles

  # Meta
  - meta/router-pattern
  - meta/rule-additions
  - meta/compound-noun-discipline
  - meta/light-vs-full-thresholds
  - meta/reality-check-examples-as-footnotes
  # - meta/doc-ownership-table   # opt in only if repo uses the convention

# Per-repo overlay: appended after the assembled shared content
# in each generated file. Overlay path is repo-local.
overlay_root: docs/agents/local/
```

### 6.2 What `scripts/assemble.sh` does

1. Reads the manifest.
2. Clones (or `git -C` fetches) the shared repo at the named
   version.
3. Copies each named module into the consuming repo's
   `docs/agents/shared/<module-path>.md`.
4. For each shared file, appends the corresponding overlay file
   (if it exists in `docs/agents/local/<module-path>.md`)
   below a fenced delimiter so the per-repo additions are
   visually distinct.
5. Writes a header to each generated file: "Generated from
   `shared-agent-rules` v<version>. Edit the upstream module
   or the local overlay; do not edit this file directly."

### 6.3 Selective consumption

Per-module opt-in via the manifest's `modules:` list. The
starter template ships a recommended-default manifest with all
modules included; consumers comment out anything that doesn't
apply.

### 6.4 Versioning

CalVer-shaped tags (`YYYY-MM-DD`) on the shared repo.
Pinning is exact: the manifest names a specific version. Bumps
are a deliberate `assemble.sh` re-run; never automatic.

A `CHANGELOG.md` at the shared repo's root lists every version
and the per-module changes. The expectation is that consumers
read it before bumping.

### 6.5 Per-repo overlay

Each shared file can carry a corresponding local overlay file
in the consuming repo at `docs/agents/local/<module-path>.md`.
The assemble script appends overlay content below the shared
content under a clear delimiter. This is how a repo adds local
constraints to an otherwise-shared rule (e.g., adding a
project-specific "mandatory pre-edit read" path on top of the
shared pre-edit-gate rule).

### 6.6 Promotion path (local → shared library)

A repo that wants to promote a local rule into the shared
library files a type-2 proposal (see §7). The repo's local
overlay holds the rule until promotion completes; on
acceptance, the rule is added to the appropriate shared
module and the local overlay can be deleted on next bump.

---

## 7. Proposal channels architecture

**Three output types from a self-review, two of which become
proposals against this repo.**

- **Type 1: fix the work.** Local to the firing session. No
  escalation; the agent fixes the issue and continues. No
  proposal artifact.

- **Type 2: propose a new audit.** When the firing pattern is
  one the catalog should have caught. Routing decision:
  - If the audit's trigger is universal (applies to any
    consuming repo), the proposal targets the shared catalog
    (`library/self-review/seed-audits/`).
  - If the audit's trigger is project-specific, the proposal
    targets the local catalog in the consuming repo (no
    proposal against shared-agent-rules; handled locally).

- **Type 3: propose a rule change.** When existing rules
  should have prevented the finding but didn't. Always
  targets the shared library. The proposal attaches the
  firing context.

### 7.1 Receiving surface

A `proposals/` directory at the shared repo's root, plus a
labeled-PR convention. Two channels:

1. **Issue, optional.** A consumer can file a GitHub issue with
   label `proposal:audit` or `proposal:rule-change`. Lightweight
   for early-stage proposals.

2. **PR with label, primary.** A consumer opens a PR against
   `shared-agent-rules` that adds a file under `proposals/`
   following the appropriate template (`template-new-audit.md`
   or `template-rule-change.md`). The label
   (`proposal:audit` / `proposal:rule-change`) gates triage.
   If the proposal is accepted, the maintainer moves content
   from `proposals/` into the appropriate module (`library/
   self-review/seed-audits/` or the relevant `library/` rule
   file) and closes the proposal in the same PR or a follow-up.

### 7.2 Required content of a proposal

Both proposal templates require:

- **Firing context.** What concretely happened in the session
  that surfaced the gap. (Link / SHA / diff snippet is fine —
  this is not a durable doc.)
- **Why existing rules didn't prevent it.** Walk through
  what the existing rule set said, and where the gap was.
- **Candidate rule text** (for rule-change proposals) **or
  candidate audit body** (Trigger / Check / Example) for new
  audits.
- **Universality check.** A paragraph confirming the
  rule/audit applies beyond the proposing repo. For audits,
  this is the test that decides shared vs local catalog.
- **What this proposes to retire or merge** (mirrors the
  rule-additions rule in `meta/rule-additions.md` — applies
  to the shared library too).

### 7.3 Who decides

The maintainer of `shared-agent-rules` (initially the user)
accepts or rejects via PR merge or close. Multiple consumers
seeing the same gap is signal but not a vote: the maintainer
weighs universality and the rule-system effect (adding a rule
is also adding rule-system mass).

This is intentionally not over-engineered. If the shared repo
later has 4+ consumers, the channel may need a triage cadence
or a stronger acceptance contract; for v0.0, the receiving
surface is the PR + label and the deciding mechanism is the
maintainer.

---

## 8. Router pattern + starter skeleton

The starter template is the per-repo `AGENTS.md` a new repo
copies on day one. Its content is rough and intentionally
sparse where the repo must fill in; the goal is that filling it
in is a 10-minute task, not a writing exercise.

### 8.1 `starter/AGENTS.md` (rough content)

```markdown
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
  - one-paragraph description of what this repo contains
  - a short list of top-level directories and what each contains
  - links to README.md, architecture doc, dev workflow doc, and
    open-questions surface (see doc-currency/ephemeral-identifiers
    rule before linking out)
-->

## Development workflow source of truth

<!--
  REPO-SPECIFIC. Name the canonical contributor workflow doc.
  The "stop on conflict between agent rules and contributor doc"
  rule is universal; instantiate it here against your specific
  docs.
-->

## Session-type routing

| If your session is… | Read these files |
|---|---|
| Implementation work without a planning doc | [`docs/agents/shared/workflows/implementation.md`](docs/agents/shared/workflows/implementation.md) |
| Implementing a documented plan | [`docs/agents/shared/workflows/implementation.md`](docs/agents/shared/workflows/implementation.md) + the plan-implementation rules from `docs/spec/planning/task-plan.md` |
| Addressing PR review feedback | [`docs/agents/shared/workflows/review-fixes.md`](docs/agents/shared/workflows/review-fixes.md) |
| Debugging a failing validation | [`docs/agents/shared/workflows/debugging.md`](docs/agents/shared/workflows/debugging.md) |
| UI review / screenshot capture (if applicable) | [`docs/agents/shared/workflows/ui-review.md`](docs/agents/shared/workflows/ui-review.md) |

Reference files under [`docs/agents/local/reference/`](docs/agents/local/reference/)
are topic-organized constraint sets specific to this repo. They are
not optional lookups; the workflow files name when each fires.

## Mandatory pre-edit reads

<!--
  REPO-SPECIFIC. List path-triggered reads, applying the pattern
  from shared/core/pre-edit-gate.md (R-04 generalized).
  Example shape:
    - docs/agents/local/reference/<topic>.md is mandatory pre-edit
      reading for any session whose diff intersects <paths>.
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
the seed audits ship under `docs/agents/shared/self-review/seed-audits/`;
project-specific audits live in the local catalog.

## Adding to this rule set

PRs that add or change rule content under `docs/agents/local/**` or
this file must follow [`docs/agents/shared/meta/rule-additions.md`](docs/agents/shared/meta/rule-additions.md).
The shared modules under `docs/agents/shared/**` are vendored
output; do not edit them directly. To change shared content, file
a proposal upstream (see [`docs/agents/shared/proposals.md`](docs/agents/shared/proposals.md)).
```

### 8.2 `starter/docs/agents/README.md` (rough)

```markdown
# Agent Guidance

Map of `docs/agents/`:

- [`shared/`](shared/) — vendored from `shared-agent-rules`.
  Do not edit directly; edit the upstream module or the matching
  local overlay.
- [`local/`](local/) — repo-specific content.
  - `local/reference/` — repo-specific constraint sets (architecture
    guardrails, styling tokens, framework conventions).
  - `local/workflows/` — repo-specific workflow additions, or
    extensions to a shared workflow.
  - `local/self-review-catalog.md` — repo-specific audits (the
    seed audits live under `shared/self-review/seed-audits/`).

Universal session rules live in [`/AGENTS.md`](/AGENTS.md) at the
repo root and the linked shared modules.
```

### 8.3 Routing table semantics

The routing table is short by design. It names *only* the entries
that apply to this repo. New session types get added by the repo
maintainer; rows that don't apply get deleted at adoption time.

---

## 9. Self-review catalog within the proposal framework

End-to-end walk-through.

**Setup.** A new repo adopts `shared-agent-rules` v2026-05-15.
Its manifest opts into `self-review/mechanism`,
`self-review/how-to-use`, and three seed audits:
`effect-cleanup`, `error-surfacing-user-mutations`, and
`validation-honesty`. The local catalog at
`docs/agents/local/self-review-catalog.md` starts empty and lists
the seed audits at the top under "seeded from shared library."

**Concrete scenario.** An agent finishes a PR that wires up a new
modal dialog. Before pushing, the agent walks the self-review
checklist (`shared/self-review/how-to-use.md`).

Step 1 — match audits to surfaces. The diff touches:
- a React component file → general checklist applies.
- a `useEffect` that subscribes to a global event → the
  **effect-cleanup** audit applies.
- a form submit handler with backend write → the
  **error-surfacing-user-mutations** audit applies.

Step 2 — run effect-cleanup. The audit's Trigger fires
("`useEffect` that subscribes / opens / schedules"). The Check
walks the component on every exit path. The agent finds a
listener that's set up on mount but is never torn down on
unmount.

Step 3 — decide output type.
- The fix itself is **Type 1**: add the cleanup. No proposal;
  local change.
- The agent asks the type-2 question: "should an audit have
  caught this?" → yes, the effect-cleanup audit caught it. No
  type-2 proposal needed.
- The agent asks the type-3 question: "should existing rules
  have prevented this?" → the existing
  effect-cleanup audit *did* prevent it from shipping, but the
  agent only ran self-review because the local checklist
  reminded them. The shared rules already cover the discipline.
  No type-3 proposal.

**Alternate scenario for type-2.** Same PR, but the modal's
focus-trap implementation has a subtle bug: when the user
dismisses the modal via the Escape key, focus is not restored
to the trigger element. The general checklist doesn't catch it.
The reviewer flags it.

After the fix, the agent runs through the type-2 / type-3
questions:
- type-2: "should an audit have caught this?" → yes. A new
  audit `focus-restoration-on-dialog-close` would catch it.
- universality check: dialog focus-restoration is a universal
  a11y concern, not project-specific. Targets the shared
  catalog.
- Routing: the agent (or the human maintainer) opens a PR
  against `shared-agent-rules` adding
  `proposals/focus-restoration-on-dialog-close.md` using the
  `template-new-audit.md` template. The PR body includes the
  firing context (the missed bug, the reviewer thread that
  surfaced it), the proposed Trigger / Check / Example, the
  universality argument, and what (if anything) this proposes
  to retire.
- The maintainer accepts → moves the file to
  `library/self-review/seed-audits/focus-restoration-on-
  dialog-close.md`, bumps the version, closes the proposal.
- Consumers pick it up on the next assemble.

**Alternate scenario for type-3.** Same PR, but the agent ran
the validation suite locally, saw one failure that wasn't
related to the change, and committed anyway. The reviewer
catches it. The agent runs through type-2 / type-3:
- type-2: no specific audit class fits — the issue is broader
  ("don't commit with a known failing baseline that you
  ignored").
- type-3: existing rules — `shared/core/pre-edit-gate.md` R-08
  ("if required baseline validation fails before edits, stop
  and report") covers the *pre-edit* case. The shared rules
  do **not** explicitly cover the *post-edit, pre-commit*
  case where validation fails mid-session.
- The agent files a type-3 proposal:
  `proposals/baseline-fails-mid-session.md` with firing
  context (the missed gap), the proposed rule text (an
  extension to `validation/philosophy.md` clarifying the
  mid-session baseline-failure case), and an analysis of
  why the existing pre-edit framing didn't extend.
- Maintainer accepts → edits `validation/philosophy.md`,
  bumps the version, closes the proposal.

The catalog mechanism + the proposal channel together close
the loop: every session-level finding either fixes itself,
strengthens the local catalog, strengthens the shared catalog,
or strengthens the shared rules.

---

## 10. Cross-check on Doc-currency Ephemeral Identifiers

**Question.** Does the rule "durable docs must not embed PR
numbers, commit IDs, or other ephemeral coordination
identifiers" (R-123) already exist in
`workstream-tracker/spec/`?

**Method.** Grepped all files under
`/Users/kyle/workspace/workstream-tracker/spec/` for
`ephemeral`, `PR number`, `commit ID`, `coordination
identifier`, and `durable doc`. Read the relevant matched
sections.

**Findings.**

- `spec/planning/task-plan.md` lines 509-514 carries a narrow
  variant: "**Do not record commit SHAs in the Status block** —
  `git log` and `git blame` are authoritative for navigating
  from plan to history, and recording SHAs creates a chicken-
  and-egg problem." This rule is specific to the **Plan-doc
  Status block** and is framed entirely around plan-doc
  lifecycle.
- `spec/planning/task-plan.md` line 93 uses "PR number" as an
  *acceptable* surface for citing a pending-input source — the
  opposite shape from a prohibition.
- No file in `spec/` carries the general rule that durable
  docs must not embed ephemeral coordination identifiers.

**Disposition.** **Keep R-123 in `shared-agent-rules`** under
`library/doc-currency/ephemeral-identifiers.md`. The
workstream-tracker variant is narrower (specifically about
the Plan-doc Status block) and lives in a plan-system context.
The general rule about durable docs not embedding ephemeral
identifiers applies in every consuming repo regardless of
whether it adopts a plan-doc system. The two rules coexist
without conflict: a consuming repo that also adopts
`workstream-tracker/spec/` gets the general rule from
`shared-agent-rules` and the plan-specific clarification from
`spec/`. Cross-reference between the two is worth adding to
the rule body in `ephemeral-identifiers.md`: "See
`workstream-tracker/spec/planning/task-plan.md` for the
plan-doc-specific application of this principle to Status
blocks."

---

## 11. Open questions for build phase

1. **Where does the test boundary rule live?** R-134 ("test
   boundary discipline") is assigned to
   `validation/philosophy.md` above, but `testing/principles.md`
   also references it. The build phase needs to decide:
   primary home in `validation/philosophy.md` with cross-ref
   from `testing/principles.md`, or vice versa? The audit puts
   it under validation; the principle reads more naturally
   alongside other testing principles. Leaning toward keeping
   it in `validation/philosophy.md` since "the unit's
   contract" framing is validation-centric — but flagging for
   build phase to confirm.

2. **What goes in the example PR bodies?** `pr-conventions/
   examples/feature-pr.md` and `refactor-pr.md` need
   genericized content. Build phase needs to either invent a
   neutral example (e.g., "a fictional CLI tool's `--quiet`
   flag") or carry over a neighborly example with
   identifiers stripped. Recommendation: invent neutral.

3. **Does `pr-body-shape.md` ship the Estimate Deviations
   section header at all?** **RESOLVED (assumed deployment
   shape, §2.5).** Every consumer also adopts
   `workstream-tracker/spec/`, so the Estimate Deviations section
   ships in `pr-body-shape.md` as a normal element of the PR
   schema, with a cross-reference to `workstream-tracker/spec/`
   for the plan-comparison logic that determines its content.

4. **How are the seed audits versioned vs. the rest of the
   library?** A consumer may want `effect-cleanup` v1 but not
   the latest `validation-honesty` revision. Initial proposal:
   a single library version pins everything; consumers manage
   drift via the manifest's opt-out. The build phase may want
   to revisit if seed audits churn faster than the rest.

5. **Per-repo overlay format.** §6.5 sketches "append after a
   delimiter" but doesn't specify the delimiter precisely.
   Candidate: a `## Local additions` header followed by the
   overlay content, with `assemble.sh` enforcing that the
   shared content doesn't already contain that header. Build
   phase to finalize.

6. **The `meta/light-vs-full-thresholds.md` shallow meta-rule
   needs at least one concrete example.** **RESOLVED (assumed
   deployment shape, §2.5).** Neighborly's "narrow-surface plan
   carve-out (planning layer) vs. lightweight-path criteria
   (implementation layer)" example ships as the canonical
   illustration. Plan-aware examples are acceptable because every
   consumer also adopts `workstream-tracker/spec/`.

7. **`meta/doc-ownership-table.md` content.** The convention is
   "recommended-but-optional"; the build phase needs to write
   the table shape concretely (columns: doc, canonical owner,
   update triggers, where ownership shifts at what
   lifecycle moment) and decide whether to ship a starter
   template alongside the rule body. Recommendation: ship a
   3-row example template in the rule file.

8. **Pre-edit gate's R-04 generalization.** The "path-triggered
   pre-edit reads" rule generalizes cleanly, but the rule body
   needs a concrete carrier surface in the consuming repo
   (where the path-list lives). Recommendation: the rule body
   names `docs/agents/local/reference/` as the conventional
   location and the starter template's `AGENTS.md` mandatory-
   pre-edit-reads section as the binding declaration.

9. **R-32 (roadmap-fit analysis) — sanity check the drop.**
   The audit recommends dropping it; the design follows that.
   But there's a kernel worth flagging: PRs that change the
   rule system get a meta-review. Worth a one-paragraph note
   in `meta/rule-additions.md` ("consumers may extend this
   rule to require a roadmap-fit analysis when the repo
   maintains a rule-system roadmap; the shared rule does not
   prescribe this"). Build phase to decide whether to include.

10. **The general self-review checklist (R-54) regrouping.**
    The audit recommends regrouping by correctness / drift /
    downstream impact, but doesn't prescribe the exact split.
    The build phase has discretion. Recommendation:
    correctness (the diff is correct and complete) / drift
    (supporting artifacts are current) / downstream impact
    (consumers of changed code or contracts are accounted for)
    / scope discipline (the diff stayed inside the requested
    boundary). Four-group split.
