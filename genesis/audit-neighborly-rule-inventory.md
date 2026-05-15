# Neighborly Rule Inventory

Audit of the agent/dev rule surface in `/Users/kyle/workspace/neighborly-scavenger-game/` performed to identify what should migrate into a shared `shared-agent-rules` repo. Source order is preserved; rule IDs are sequential.

## 1. Overview

**Scale audited.** Roughly 7,400 lines across 14 rule-bearing files:
- `AGENTS.md` (root, 253 lines)
- `docs/agents/AGENTS.md` + `docs/agents/README.md` (router fragments)
- `docs/agents/workflows/{implementation,plan-implementation,debugging,review-fixes,ui-review}.md` (~600 lines)
- `docs/agents/planning/{shared,epic,milestone,plan}.md` (~1,500 lines)
- `docs/agents/reference/{architecture-guardrails,documentation-currency,pr-template,validation}.md` (~700 lines)
- `docs/plans/AGENTS.md` (router fragment)
- `docs/self-review-catalog.md` (650 lines, 19 audits)
- `docs/dev.md`, `README.md`, `docs/testing.md`, `docs/styling.md` (rule-bearing skim sources)

**Headline tag distribution (143 rules total):**
- Scope: ~36% universal, ~44% adaptable, ~20% project-specific.
- Action: 47 keep-as-is, 51 rewrite-or-generalize, 18 drop, 22 keep-local-only, 5 promote-to-meta.
- Type: 122 content-rule, 6 shallow-meta-rule, 5 deep-meta-rule, 10 human-process-doc.
- Flags: 18 friction-causing, 14 already-in-workstream-tracker-spec, 9 embeds-github-workflow, 7 laundry-list-style, 6 over-specific-could-generalize, 5 project-phase-superseded, 4 implicit-could-codify, 6 duplicates.

## 2. Notable findings

1. **The router/topic split is itself a deep meta-rule worth promoting.** Neighborly's structure — root `AGENTS.md` carries universal rules + a session-type routing table, with per-session workflow files routing into topic-organized constraint sets — is the most valuable artifact in the whole tree. The shared repo should ship this skeleton as a meta-pattern (with an empty template) rather than as rule content.

2. **Two distinct "Validation Gate" populations.** The validation reference is excellent and ~80% universal (validation honesty, continuous validation, regression discipline, PR readiness, test boundary discipline). The validation *commands* are project-specific. The current file conflates them; generalizing requires splitting "validation philosophy" (universal) from "validation surface" (per-project instantiation).

3. **PR template / Estimate Deviations / Review Stance are the GitHub-workflow embedding hotspots.** Roughly 9 rules assume a GitHub PR review workflow (Review Stance section, Estimate Deviations PR-body callout, "reply on that exact GitHub thread," PR-body Validation checkboxes). Each is a real rule wearing GitHub clothing. The kernel is "reviewer-stance signaling," "implementer-vs-plan reconciliation," and "human-readable thread state" — generalize by abstracting the carrier surface.

4. **Self-review catalog is mostly project-specific but the *catalog mechanism* is universal.** 18 of 19 audits cite specific PR numbers / commit SHAs / table names — none belong in a shared repo. But the "Trigger / Check / Example" entry format, the "add when a class of issue fires twice / drop when an automated check covers it" lifecycle rule, and the "self-review names audits at plan time, runs them at commit boundaries" pattern all generalize cleanly. Ship the harness, drop the contents.

5. **The planning rule set is mature but heavily over-fitted to GitHub PR + epic/milestone/phase hierarchy.** Most of `planning/shared.md` already overlaps with `workstream-tracker/spec/` (flagged below). The pieces that don't — `Verified by:`, falsifiability check, rules-vs-estimates, options-into-shapes, anti-pattern of artifacts that only cite each other — are genuinely universal and worth keeping. The PR-shaped scaffolding around them (status-flip rules, Plan-to-PR Completion Gate, Estimate Deviations callout) is where the friction lives.

6. **Compound-noun discipline + bare-"plan" prohibition is the rule system protecting its own readability.** This is a meta-rule about how rules in *this* system are written. Worth keeping as a shallow-meta-rule (any consuming repo can apply it) and promoting the pattern (rule-system terminology hygiene) in the shared repo's authoring guide.

7. **Sub-agent delegation rule is universal in concept but framework-coupled in detail.** "Sub-agents don't inherit AGENTS.md; include rules verbatim or keep scope mechanical" is universal advice. The specific mention of "delegation tools" and "workflow gates belong in the orchestrating session" presumes a framework with delegation primitives. Mark adaptable.

8. **Laundry-list anti-patterns appear in three places.** `AGENTS.md` "Anti-Patterns" (8 items), Self-Review Checklist (~12 items), and Doc Currency triggers (5+5 items) all read like grab-bags. Each item is individually defensible but the lists fire inconsistently in practice. Recommend regrouping by organizing principle (e.g., "don't defer validation," "don't let supporting artifacts drift") rather than preserving the bullet list as-is.

9. **Several rules are forensic — they exist because of a specific past incident.** "Read CI failure comment first" (debugging.md), the `vercel dev` reality-check trap, the `has_table_privilege` vacuous-pass, the M2 phase 2.3 cross-app navigation trap. These are valuable as *examples* of broader rules but should not become rules themselves. Refactor: keep the broader rule, demote the specific trap to an illustrative footnote that consumers can replace with their own war stories.

10. **Doc-currency rules have heavy project-specific noise.** The discipline is universal (update durable docs when their contracts change; ban ephemeral identifiers in durable docs) but ~half the rule body enumerates specific neighborly docs (`docs/product.md`, `docs/backlog.md`, `docs/architecture.md`). Generalize by separating the *trigger pattern* (status sections, command lists, ownership tables) from the *target list* (per-project).

## 3. Module clusters (preliminary)

Candidate groupings for the shared repo's module taxonomy. Numbers are rule IDs from section 5.

- **core / pre-edit-gate**: R-04, R-05, R-06, R-07, R-08, R-09
- **core / scope-and-stop**: R-10, R-11, R-12, R-13, R-14, R-15, R-16, R-17, R-18, R-19, R-30
- **core / anti-patterns** (needs rewrite into grouped form): R-20, R-21, R-22, R-23
- **delegation**: R-24, R-25, R-26, R-27
- **change-boundaries**: R-28, R-29
- **rule-authoring (meta)**: R-31, R-32, R-129
- **implementation / lightweight-vs-full**: R-33, R-34, R-35, R-36
- **implementation / execution-discipline**: R-37, R-38, R-39, R-40, R-41, R-42
- **implementation / refactor-completion-proof**: R-43, R-44, R-45, R-46, R-47, R-48
- **implementation / feature-time-cleanup**: R-49, R-50, R-51
- **versioning-and-deps**: R-52
- **self-review / general**: R-53, R-54, R-55, R-56, R-57
- **plan-implementation**: R-58, R-59, R-60, R-61, R-62
- **debugging**: R-63, R-64, R-65, R-66, R-67
- **review-fixes**: R-68, R-69, R-70, R-71
- **ui-review** (mostly adaptable): R-72, R-73, R-74, R-75, R-76, R-77
- **planning / cross-level core**: R-78, R-79, R-80, R-81, R-82, R-83, R-84, R-85, R-86
- **planning / status-and-lifecycle**: R-87, R-88, R-89, R-105
- **planning / scoping-vs-plan**: R-95, R-96, R-97, R-98, R-99
- **planning / epic + milestone shapes**: R-90, R-91, R-92, R-93, R-94
- **planning / depth-and-promotion-gates**: R-100, R-101, R-102, R-103, R-104
- **planning / phase-plan specifics**: R-106, R-107, R-108, R-109
- **architecture-guardrails (mostly project)**: R-110, R-111
- **styling-tokens (project)**: R-112
- **doc-currency** (split): R-113, R-114, R-115, R-116, R-117
- **pr-template / commit-conventions**: R-118, R-119, R-120, R-121
- **validation / philosophy**: R-122, R-123, R-124, R-125, R-126, R-127, R-128
- **self-review catalog (meta-only)**: R-130, R-131, R-132
- **dev-workflow project-specific** (drop or keep-local): R-133–R-143

## 4. Open questions for design

1. **Where does "Sub-Agent Delegation" live?** It's a universal concept but only meaningful in an agentic-framework-aware way. Standalone module, or appendix to core?

2. **Should the "router + topic-organized constraint sets" pattern be a deep meta-rule (about how rules are organized) or a template the shared repo *ships*?** Both. Clarify which.

3. **PR template granularity.** The verbatim PR-body template is project-specific (lists `npm run lint` etc.) but the *section schema* (Summary / Why / User Behavior / Contract / Target Shape / Documentation / Estimate Deviations / UX Review / Validation / Remaining Risk) is genuinely universal-adjacent. Ship the schema with placeholders? Drop the verbatim template?

4. **Estimate Deviations callout.** This rule presumes (a) a plan doc exists, (b) PRs have bodies, (c) plan-vs-implementation diff is the audit unit. Where in the kernel does this fit if a consuming repo doesn't use plan docs at all?

5. **Doc Ownership table reference.** Several rules (canonical-owner duplication, validation-command coupling, route topology coupling) lean on a "Doc Ownership table" that neighborly maintains. Is that pattern itself worth promoting as a recommended convention?

6. **Self-review catalog format vs. content.** Confirmed: the format (Trigger/Check/Example, recurrence-based lifecycle) is shippable, the contents are not. But should the shared repo ship *seed* audits (a small handful of universally-applicable ones like effect-cleanup, error-surfacing) or stay strictly empty?

7. **Compound-noun discipline at the meta layer.** Worth pulling out as a shallow-meta-rule the consuming repo applies to its own custom rules — but the rule body cites bare "plan" as the specific term. Generalize to "any overloaded noun in rule prose," with neighborly's "plan" / "task" as illustrative?

8. **`Deferred` status semantics.** The rule that deferred plans are non-prescriptive and must re-derive on resume is excellent — but it's framed entirely around `docs/plans/`. Does the shared repo carry it as planning rule, or as a more general "paused-artifact discipline"?

9. **Reality-check gate examples.** The "read actual migration files," "read function body," "check `vercel.json`" examples are concretely about supabase/Vercel/Next. The kernel ("verify each load-bearing claim against the actually-merged code, including config-dependent dev tools") is universal but loses force without examples. How to keep the punch while genericizing?

10. **Doc-currency Ephemeral Identifiers rule overlap with `workstream-tracker/spec/`.** Likely already covered there but flagged for explicit cross-check during design.

---

## 5. Per-source breakdown

### `AGENTS.md` (root)

The root is mostly a router but carries the universal rule set inline. Routing-table content is meta and not rule-extracted; the universal sections are.

#### R-01: AGENTS.md is the router; topic files live elsewhere
- **Source:** `AGENTS.md` opening
- **Quote:** "This file is the **router** for AI coding agents working in this repo. It carries the rules every session needs … and pointers to the contributor-workflow source of truth."
- **Scope:** adaptable
- **Action:** promote-to-meta
- **Type:** deep-meta-rule
- **Flags:** none
- **Notes:** This is structural — describes how the rule system is organized, not a rule about coding. Shared repo should ship this pattern as the recommended skeleton.

#### R-02: Treat AGENTS.md and dev.md as joint sources of truth; stop on conflict
- **Source:** `AGENTS.md` "Development workflow source of truth"
- **Quote:** "AGENTS.md defines agent behavior and decision discipline. docs/dev.md defines the current contributor workflow. Follow both. If they conflict, stop and report the conflict instead of guessing."
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** The two-source pattern is generalizable (agent-rules vs. contributor-workflow). Worth promoting.
- **Generalized form:** "When agent rules and human-contributor workflow docs conflict, stop and report rather than picking a side."

#### R-03: Capture uncertainty in open-questions rather than inventing answers
- **Source:** `AGENTS.md` "Repo orientation"
- **Quote:** "When the repo leaves a decision unresolved, capture that uncertainty in `docs/open-questions.md` instead of inventing an answer."
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Strong rule; the only project-specific bit is the filename.
- **Generalized form:** "When the codebase or docs leave a decision unresolved, record it in the designated open-questions surface; do not invent an answer."

#### R-04: Mandatory pre-edit reads route on diff surface
- **Source:** `AGENTS.md` "Mandatory pre-edit reads"
- **Quote:** "[architecture-guardrails.md] is a mandatory pre-edit read for any session whose diff surface intersects [listed paths]"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** over-specific-could-generalize
- **Notes:** The pattern (path-triggered pre-edit reads) is generalizable; the path list is project.
- **Generalized form:** "Designate path-triggered mandatory pre-edit reads; treat them as binding before the first edit, not as optional lookups."

#### R-05: Pre-Edit Gate — clean worktree, branch hygiene
- **Source:** `AGENTS.md` "Pre-Edit Gate"
- **Quote:** "make sure the worktree does not contain unrelated uncommitted changes … make sure you are not doing substantial implementation work on `main`; create or switch to an appropriately named feature branch first"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Classic and well-stated. May want to relax "main" to "the default/trunk branch" for generality.

#### R-06: Pre-Edit Gate — read before deciding target shape
- **Source:** `AGENTS.md` "Pre-Edit Gate"
- **Quote:** "read the relevant docs, tests, and neighboring implementation before deciding the target shape"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Core discipline.

#### R-07: Pre-Edit Gate — confirm positive value before editing
- **Source:** `AGENTS.md` "Pre-Edit Gate"
- **Quote:** "confirm the requested change is expected to be positive value for the codebase: it should reduce real risk, duplication, confusion, operational friction, or product/user pain enough to justify its diff and review cost"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent rule against churn. Worth keeping verbatim.

#### R-08: Pre-Edit Gate — run baseline validation; stop if it fails
- **Source:** `AGENTS.md` "Pre-Edit Gate"
- **Quote:** "run the task's specified baseline validation commands before editing when the prompt or checklist names them … if a required baseline validation fails before edits, stop and report the failure instead of changing files"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Universal.

#### R-09: Pre-Edit Gate — DB-level enforcement for new backend writes
- **Source:** `AGENTS.md` "Pre-Edit Gate"
- **Quote:** "for any change that adds or modifies a backend write reachable from a public or origin-gated endpoint, answer before writing code: what prevents a caller from writing arbitrary or nonexistent data? Prefer DB-level referential integrity and constraints over application-layer validation"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Universal kernel ("the persistence layer is the authoritative enforcement point") but DB-specific phrasing. Generalize to "trust boundaries enforced as close to the persistent store as possible."

#### R-10: Scope Guardrails — treat broad requests as a queue, not a license
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "Treat broad checklist, cleanup, or refactor requests as a queue of PR-sized tasks, not as permission to work through everything in one thread."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Universal.

#### R-11: Scope Guardrails — one slice per branch/handoff
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "prefer one checklist item, one feature slice, or one tightly related file family per branch and handoff"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-12: Scope Guardrails — combine items only when they share file + validation surface
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "combine multiple items only when they share the same files, the same validation surface, and still produce a small reviewable diff"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-13: Scope Guardrails — record sequence, execute first slice
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "if a user asks for many checklist items at once, record or confirm the sequence, then execute only the first bounded slice unless the user explicitly asks only for planning"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-14: Scope Guardrails — stop when slice grows beyond one clean PR
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "if the work grows beyond one clean PR, stop after updating the checklist or plan with smaller follow-up tasks"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** Uses "PR" as the unit; generalize to "one cohesive reviewable change."

#### R-15: Scope Guardrails — stop and report on scope expansion
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "stop and report instead of expanding scope when the task starts requiring behavior changes, unrelated production edits, mixed backend/frontend/UI work, or validation outside the originally relevant surface"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-16: Scope Guardrails — fresh thread for next slice
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "prefer a fresh thread or fresh branch for the next checklist item when the previous slice has been committed and handed off"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-17: Treat named target as active boundary
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "When a prompt identifies a specific checklist item, issue, file family, feature slice, or validation command, treat that as the active boundary. Do not work on adjacent cleanup, nearby checklist items, opportunistic dependency upgrades, or unrelated docs unless they are necessary to keep the requested change correct and validated."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-18: Keep behavior-preserving tasks behavior-preserving
- **Source:** `AGENTS.md` "Scope Guardrails"
- **Quote:** "If the requested task is behavior-preserving, keep it behavior-preserving. Stop and report instead of proceeding if the implementation appears to require changing product behavior, public contracts, persistence semantics, authorization rules, routing, generated artifacts, or unrelated production code."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Strong rule; worth keeping.

#### R-19: Stop-And-Report — clean worktree, identify partial state
- **Source:** `AGENTS.md` "Stop-And-Report Conditions"
- **Quote:** "When stopping, leave the worktree clean when practical. If stopping after partial edits, clearly identify the touched files, what remains incomplete, and whether any validation was run."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-20: Anti-pattern — large one-shot refactors with no plan
- **Source:** `AGENTS.md` "Anti-Patterns"
- **Quote:** "large one-shot refactors with no written plan or intermediate checkpoints"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** laundry-list-style
- **Notes:** Item 1 of an 8-item list. Worth keeping the principle; consider merging with R-37 (constraint-driven execution) into one cohesive anti-pattern.

#### R-21: Anti-pattern — tests lagging behind code; deferred validation; undocumented moves; combined cleanup; final-commit drift cleanup; skipping repo workflow
- **Source:** `AGENTS.md` "Anti-Patterns"
- **Quote:** [items 2–7 of the list]
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** laundry-list-style
- **Notes:** A genuine grab-bag. Each item is defensible but they read as enumerated don'ts. Recommend regrouping: "supporting artifacts don't drift" (tests, docs, ownership) and "validation cadence" themes.

#### R-22: Anti-pattern — phase-named test files
- **Source:** `AGENTS.md` "Anti-Patterns"
- **Quote:** "naming living test or code files after the rollout phase that produced them (for example `foo_phase3_bar.test.sql`); name by the feature or surface under test so the filename still makes sense after the phase ships"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** over-specific-could-generalize
- **Notes:** Universal kernel ("durable artifacts named by what they are, not by the rollout cycle that produced them"). The pgTAP-specific example is illustrative.

#### R-23: Change Boundaries — prefer targeted fixes over speculative refactors
- **Source:** `AGENTS.md` "Change Boundaries"
- **Quote:** "Prefer targeted fixes over speculative refactors. Do not introduce new frameworks, new backend services, or broad architecture rewrites unless the task clearly calls for that."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Strong, universal.

#### R-24: Sub-agents don't inherit AGENTS.md
- **Source:** `AGENTS.md` "Sub-Agent Delegation"
- **Quote:** "Sub-agents spawned via delegation tools do not inherit this file. They only know what is explicitly included in their prompt."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Universal principle, framework-specific carrier ("delegation tools").
- **Generalized form:** "Sub-agents inherit only what is explicitly in their prompt; do not assume they share the orchestrator's loaded rule set."

#### R-25: Two-mode delegation — narrow scope OR include rules verbatim
- **Source:** `AGENTS.md` "Sub-Agent Delegation"
- **Quote:** "choose one of two approaches and apply it strictly: Narrow scope … Broader scope — include the relevant rules directly. Do not write 'follow AGENTS.md' — the sub-agent cannot read it."
- **Scope:** adaptable
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent rule; keep with the framework-name placeholder.

#### R-26: Workflow gates stay in the orchestrator
- **Source:** `AGENTS.md` "Sub-Agent Delegation"
- **Quote:** "Workflow gates belong in the orchestrating session, not in sub-agents. Branch creation, committing, PR creation, doc updates, and self-review are high-risk steps that require the full process context."
- **Scope:** adaptable
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** PR creation specifically is GH-flavored, but principle generalizes.

#### R-27: Orchestrator catches sub-agent scope drift
- **Source:** `AGENTS.md` "Sub-Agent Delegation"
- **Quote:** "If a delegated task grew beyond its original scope during execution, the orchestrating session is responsible for catching the drift and applying the missing gates before treating the work as done."
- **Scope:** adaptable
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-28: Change Boundaries — MVP-favor clarity over premature platform expansion
- **Source:** `AGENTS.md` "Change Boundaries"
- **Quote:** "This repository is still in a focused MVP stage. Favor clarity, reliability, and maintainable incremental progress over premature platform expansion."
- **Scope:** project-specific
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** project-phase-superseded
- **Notes:** Project-phase-bound. Generalizable kernel: "favor maintainable incremental progress over speculative platform work." Worth keeping in a generalized form.

#### R-29: Stop-And-Report condition list (consolidated)
- **Source:** `AGENTS.md` "Stop-And-Report Conditions"
- **Quote:** List of 8 stop conditions (unrelated uncommitted, baseline failure, needless change, scope expansion, behavior-preserving violations, contract change, coverage weakening, larger than one PR, broader design needed)
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** laundry-list-style
- **Notes:** A long list but each item is genuinely a distinct stop signal. Less grab-bag-y than the anti-patterns list; keep it but consider sub-grouping (scope / contract / quality).

#### R-30: Sub-Agent Delegation entire section as a unit
- **Source:** `AGENTS.md` "Sub-Agent Delegation"
- **Notes:** Captured by R-24–R-27 individually.

#### R-31: PR adding rule must name a rule it deletes/merges (Rule Additions)
- **Source:** `AGENTS.md` "Rule additions in `docs/agents/`"
- **Quote:** "A PR that adds a new rule to `docs/agents/**` must either (a) name a rule it deletes or merges into the new one, or (b) state in the PR body why no existing rule could be retired."
- **Scope:** adaptable
- **Action:** promote-to-meta
- **Type:** deep-meta-rule
- **Flags:** embeds-github-workflow
- **Notes:** Excellent deep-meta-rule about the rule system itself. The carrier ("PR body") is GH-coupled but the discipline (forced trade-off articulation at addition time) is universal. Worth a dedicated meta-rule slot in the shared repo.

#### R-32: Roadmap-fit analysis for rule-doc PRs
- **Source:** `AGENTS.md` "Roadmap-fit analysis for rule-doc PRs"
- **Quote:** "A PR that modifies AGENTS.md or a rule-shaped doc under `docs/agents/**` carries a brief roadmap-fit analysis in the PR body: a verdict, the concrete delta on rule surface, and whether the change moves with or against the direction named in [tracking doc]."
- **Scope:** project-specific
- **Action:** drop
- **Type:** deep-meta-rule
- **Flags:** embeds-github-workflow, project-phase-superseded
- **Notes:** Specific to neighborly's agentic-practice roadmap. The pattern (rule-system-change PRs get a meta-review) is interesting but probably too heavyweight to ship by default. Note the pattern; don't ship the rule.

### `docs/agents/AGENTS.md`

Pure router/orientation fragment — no rules extracted.

### `docs/agents/README.md`

Pure directory map — no rules extracted.

### `docs/agents/workflows/implementation.md`

#### R-33: Lightweight path qualification (5 criteria)
- **Source:** `implementation.md` "Lightweight vs full structured"
- **Quote:** Five criteria: ≤5 files, single subsystem, no public-API contract change, no schema change, local test surface
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** The criteria set is largely universal but the thresholds and "subsystem" definition are project-flavored. Generalize the structure (5 binary qualifications), let consumers pick thresholds.

#### R-34: Light vs. full thresholds are stricter than planning's narrow-surface threshold
- **Source:** `implementation.md` "Lightweight vs full structured"
- **Quote:** "The thresholds here are deliberately stricter than the narrow-surface criteria … That rule governs whether a planned task or phase writes a scoping doc; this rule governs whether unplanned implementation work uses lightweight or full execution discipline."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** shallow-meta-rule
- **Flags:** none
- **Notes:** The principle (different thresholds for different gating decisions, named explicitly to avoid conflation) is a useful meta-rule for any consuming repo with multiple gating layers.

#### R-35: Lightweight Path 5-step checklist
- **Source:** `implementation.md` "Lightweight Path"
- **Quote:** Read, smallest coherent change, update tests/docs, review diff, run validation
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-36: Full Structured Path 11-step checklist
- **Source:** `implementation.md` "Full Structured Path"
- **Quote:** Ground in code, check branch, write down plan, define target structure, define commit boundaries, execute in small commits, validate continuously, automated code-review feedback loop, keep docs current, delete/convert temp planning docs, self-review
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent but long. Each step is its own micro-rule; consider splitting for granularity.

#### R-37: Execution Rules — constraint-driven over open-ended refactor
- **Source:** `implementation.md` "Execution Rules"
- **Quote:** "Prefer constraint-driven execution over open-ended refactoring. - decide the intended module boundaries before moving files around - prefer extracting one seam at a time …"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-38: Don't batch into one large transformation
- **Source:** `implementation.md` "Execution Rules"
- **Quote:** "For multi-step work, do not batch everything into one large uncommitted transformation."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-39: Local checklist hygiene for multi-step work
- **Source:** `implementation.md` "Execution Rules"
- **Quote:** "create or maintain a local checklist … update that checklist as steps are completed … remove or finalize that checklist before handoff so canonical docs, not stale running state, describe the implemented system"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-40: Don't leave implementation only on the working tree on main
- **Source:** `implementation.md` "Execution Rules"
- **Quote:** "if the work started from main, do not leave implementation only in the working tree on main; move it onto a feature branch before substantial edits accumulate"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-41: Multi-subsystem changes ship as multiple commits
- **Source:** `implementation.md` "Execution Rules"
- **Quote:** "if the change spans backend, frontend, tests, and docs, assume it should land as multiple commits unless there is a specific reason not to"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-42: Refactor Completion Proof — passing tests is necessary but not sufficient
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "For checklist, cleanup, split, extraction, or other behavior-preserving refactor tasks, passing tests is necessary but not sufficient. Before marking the task complete, prove that the requested target shape was actually achieved."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent. Among the best rules in the tree.

#### R-43: Define target shape before editing
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "define the target shape before editing, including what responsibilities should remain in the original file or module and what responsibilities should move"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-44: Verify final diff against every concrete clause, not just title
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "verify the final diff against every concrete clause in the checklist item or prompt, not just against the task title"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-45: Report responsibility split for split/extraction tasks
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "report the final responsibility split in the handoff for any split or extraction task"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-46: Include before/after evidence when size or ownership is the reason
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "include before/after size or ownership evidence when file size, reviewability, or local ownership is the reason for the task"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-47: Don't mark complete on partial extraction
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "do not mark a checklist item complete merely because some helper was extracted or some code moved; the remaining code must match the requested shape"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-48: Refactor stop-and-report when target not met or value unclear
- **Source:** `implementation.md` "Refactor Completion Proof"
- **Quote:** "if validation passes but the target shape is not met, treat the task as incomplete … if the refactor does not clearly improve reviewability, ownership, risk reduction, or future change cost, stop and report"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-49: Feature-Time Cleanup — leave touched code coherent but don't opportunistic-refactor
- **Source:** `implementation.md` "Feature-Time Cleanup And Refactor Debt Capture"
- **Quote:** "Feature work should leave the touched code coherent, but it should not expand into opportunistic refactors that are not required for the feature."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-50: Capture useful-but-not-required cleanup as bounded follow-up
- **Source:** `implementation.md` "Feature-Time Cleanup"
- **Quote:** "if the cleanup is useful but not necessary for the feature, record it as a bounded follow-up in [tracking doc]"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Filename is project-specific; principle is universal.

#### R-51: Post-implementation structure review
- **Source:** `implementation.md` "Feature-Time Cleanup"
- **Quote:** "Before handoff, run a post-implementation structure review: identify any touched file that grew large, mixed responsibilities, duplicated logic, or became harder to test because of the change …"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-52: Versioning And Dependency Discipline
- **Source:** `implementation.md` "Versioning And Dependency Discipline"
- **Quote:** "prefer current stable versions … do not use floating values such as `latest`, broad unpinned ranges, or moving tags when a reproducible pinned version is practical … update lockfiles and any version-carrying config in the same change …"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-53: Self-Review walks named audits from catalog
- **Source:** `implementation.md` "Self-Review Checklist"
- **Quote:** "Before finishing, walk the named audits from `docs/self-review-catalog.md` that match the diff's surfaces"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** The catalog pattern is universal; the filename is project-specific.

#### R-54: General self-review list (correctness, regressions, readability, dup logic, stale comments, missing validation, call-site coverage, a11y, positive-value check)
- **Source:** `implementation.md` "Self-Review Checklist"
- **Quote:** Bullet list
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** laundry-list-style
- **Notes:** Each item is genuine but the list lacks organizing principle. Consider regrouping by "correctness," "drift," "downstream impact."

#### R-55: For bounded tasks, confirm scope/mapping/target-shape/behavior-change/handoff
- **Source:** `implementation.md` "Self-Review Checklist"
- **Quote:** "For any bounded checklist or refactor task, also confirm: the final diff stays inside the requested scope … the handoff says whether behavior changed; for behavior-preserving tasks, the answer should be 'no' or should explain why the task stopped …"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-56: Backend/trust-related review additions
- **Source:** `implementation.md` "Self-Review Checklist"
- **Quote:** "For backend or trust-related changes, confirm: client input is still validated defensively … shared quiz logic is still the source of truth … every new DB write reachable from a public or origin-gated endpoint has referential integrity"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Kernel is universal (trust-boundary review); examples are project.

#### R-57: Testing/tooling change review additions; multi-commit review
- **Source:** `implementation.md` "Self-Review Checklist"
- **Quote:** "For testing and tooling changes, confirm: the new or changed commands work locally … For multi-commit work, also review: whether each commit would make sense to a reviewer on its own; whether a later commit silently fixed issues introduced by an earlier one"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

### `docs/agents/workflows/plan-implementation.md`

#### R-58: Read the plan in full before the first edit
- **Source:** `plan-implementation.md` "Read the plan in full before the first edit"
- **Quote:** "The plan-implementing session's first move is to read the plan end-to-end, even if the prompt only names a subset of work."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Likely overlaps with planning rules already in workstream-tracker.

#### R-59: Cross-cutting invariants walked at every call site, not just trigger site
- **Source:** `plan-implementation.md` "Read the plan in full before the first edit"
- **Quote:** "The plan's `Cross-Cutting Invariants` section binds rules that must hold simultaneously across multiple files. Walk every call site the diff touches against each invariant, not just the site the invariant was first triggered by."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent universal-quality rule for any implementer.

#### R-60: Distinguish rule deviations from estimate deviations
- **Source:** `plan-implementation.md` "Distinguish rule deviations from estimate deviations"
- **Quote:** "Rule-shaped sections … bind the implementation. Deviating from a rule means the rule is wrong; the plan must be revised in the same PR … Estimate-shaped sections … estimate the expected shape. Deviating from an estimate is normal."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Core planning concept; likely already extracted.

#### R-61: Plan-to-PR Completion Gate walk
- **Source:** `plan-implementation.md` "Plan-to-PR Completion Gate"
- **Quote:** "Walk every Goal, Test, Validation step, and Self-Review audit named in the plan; each is satisfied or explicitly deferred in the plan itself with written rationale. Flip the plan's Status line …"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow, already-in-workstream-tracker-spec

#### R-62: When the plan says X but reality is Y — fix the plan first
- **Source:** `plan-implementation.md` "When the plan says X but reality is Y"
- **Quote:** "If a reality-check during implementation finds that a plan rule is wrong … fix the plan in the same PR before the implementation deviation lands."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

### `docs/agents/workflows/debugging.md`

#### R-63: Failing-validation next action must be informed by actual error
- **Source:** `debugging.md` "Debugging Discipline"
- **Quote:** "When a validation step (CI, a local test, a runtime assertion) fails, the next action must be informed by the actual error, not by a hypothesis about what the error might be."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent universal debugging principle.

#### R-64: Read CI failure comment first / stop after one speculative attempt
- **Source:** `debugging.md` "Debugging Discipline"
- **Quote:** "If the failure-comment is genuinely missing or its content is not readable from the session for any reason, stop after at most one speculative attempt and ask the human for the log content before continuing."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Kernel is "don't stack guess-and-push attempts"; carrier ("CI failure comment") is project-flavored.

#### R-65: Mark speculative fixes as such in commit body
- **Source:** `debugging.md` "Debugging Discipline"
- **Quote:** "When you do push a fix whose connection to the observed failure is not directly traceable to a specific line of error output, say so in the commit body and flag that the commit may need to be reverted if the real cause turns out to be elsewhere."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-66: Undo speculative commits after finding the real cause
- **Source:** `debugging.md` "Debugging Discipline"
- **Quote:** "After finding the real cause, undo speculative commits from the same debugging session instead of leaving them in the tree. A clean final tree is more valuable than a clean history"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-67: Verify local environment matches CI baseline when local passes but CI fails
- **Source:** `debugging.md` "Debugging Discipline"
- **Quote:** "When a local test passes but CI fails, verify the local environment actually exercises the same baseline state CI does."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** The pgTAP-specific examples are illustrative; the principle (baseline-state divergence is a recurring source of green-local-red-CI) is universal.

### `docs/agents/workflows/review-fixes.md`

#### R-68: Review-fix rigor — same diligence as original
- **Source:** `review-fixes.md` "Review-Fix Rigor"
- **Quote:** "Review-fix commits do not get a lighter diligence standard than the original implementation."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-69: After fixing reviewer-surfaced defect, audit siblings of same class
- **Source:** `review-fixes.md` "Review-Fix Rigor"
- **Quote:** "after fixing a reviewer-surfaced defect, audit the rest of the plan or diff for siblings of the same class before committing the fix. Reviewer feedback usually surfaces one instance of a recurring mistake"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Genuinely excellent rule. Universal.

#### R-70: New bug check — "could this make a successful operation look failed?"
- **Source:** `review-fixes.md` "Review-Fix Rigor"
- **Quote:** "before committing a review fix, answer: 'What new bug could this fix create?' and 'Could this make a successful operation look failed?'"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-71: GitHub thread state discipline
- **Source:** `review-fixes.md` "GitHub thread state discipline"
- **Quote:** "after pushing a fix for a specific review thread, reply on that exact GitHub thread with a short summary of what changed and the commit SHA … do not resolve threads, submit a review, or mark conversations resolved unless the user explicitly asks for that write action"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** Universal kernel ("review-thread state stays readable; don't take write actions unbidden"), GitHub carrier.

### `docs/agents/workflows/ui-review.md`

#### R-72: Prefer real browser pass + Playwright over code-only visual guesses
- **Source:** `ui-review.md` "UI Review Runs"
- **Quote:** "use Playwright rather than code-only visual guesses whenever browser automation is feasible … prefer a real browser pass over code-only visual guesses"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none

#### R-73: Mobile-first viewport for mobile-first products; capture key states
- **Source:** `ui-review.md` "UI Review Runs"
- **Quote:** "use a mobile viewport first because the attendee flow is mobile-first … capture the key states you are reviewing, not just the landing page"
- **Scope:** project-specific
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** over-specific-could-generalize
- **Notes:** "Mobile-first" is a product property; generalize as "viewport matching the product's primary target."

#### R-74: Before/after screenshot capture for material UX changes
- **Source:** `ui-review.md` "UI Review Runs"
- **Quote:** "If a change modifies UX, layout, interaction flow, or user-facing copy in a meaningful way: capture relevant before screenshots before editing … capture matching after screenshots after the implementation is complete … include a before/after comparison in the pull request description"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** Universal practice with GH carrier.

#### R-75: Reusable capture script over one-off temp scripts
- **Source:** `ui-review.md` "UI Review Runs"
- **Quote:** "keep reusable automation logic in `scripts/ui-review/` … extend that script when future verification needs new routes, states, or capture scenarios instead of creating one-off temp scripts"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Universal kernel ("extend the canonical capture flow rather than reinventing"), path-specific.

#### R-76: Screenshot artifacts go in tmp/, not committed
- **Source:** `ui-review.md` "UI Review Runs"
- **Quote:** "write screenshots under `tmp/` … do not commit generated screenshots … make sure the output path is ignored by git before finishing"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-77: PR screenshots via external host, not committed images
- **Source:** `ui-review.md` "Pull Request Screenshot Process"
- **Quote:** "When a PR should show screenshots, do not satisfy that by committing image artifacts into the repository. Use this process instead: Capture into tmp/ … Upload only the selected PR images to an external image host …"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** The `catbox.moe` example is illustrative; principle is universal.

### `docs/agents/planning/shared.md`

NOTE: Many of these rules likely already exist in `workstream-tracker/spec/`. Flagged accordingly.

#### R-78: Plans describe contracts, not implementation
- **Source:** `planning/shared.md` "Plans describe contracts, not implementation"
- **Quote:** "A plan describes what the implementation must achieve — the conditions that must hold for the implementation to satisfy the plan."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-79: No fenced code blocks in plan/scoping docs
- **Source:** `planning/shared.md` "Structural surface"
- **Quote:** "No fenced code blocks of any kind in plan or scoping docs."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-80: Reviewer-fix discipline — shape-specific (structural vs altitude)
- **Source:** `planning/shared.md` "Reviewer-fix discipline"
- **Quote:** "Structural violation: remove or summarize the snippet. Do not fix the code in place … Altitude violation: loosen the prescription to contract altitude."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-81: Plan-doc review stance (PR-body section)
- **Source:** `planning/shared.md` "Plan-doc review stance"
- **Quote:** "A PR whose primary diff is in `docs/plans/**` carries a `## Review Stance` section in the PR body."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow, already-in-workstream-tracker-spec
- **Notes:** Explicitly flagged in user instructions as the github-workflow embedding archetype.

#### R-82: Cross-Cutting Invariants section requirement
- **Source:** `planning/shared.md` "Cross-Cutting Invariants section"
- **Quote:** "List the cross-cutting invariants that thread through multiple files in their own `## Cross-Cutting Invariants` subsection, distinct from per-file contracts."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-83: Header variance reporting
- **Source:** `planning/shared.md` "Header variance reporting"
- **Quote:** "When a particular doc legitimately diverges from that listed shape … the PR introducing the divergence calls it out in the PR body's Documentation section"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow, already-in-workstream-tracker-spec

#### R-84: Plan content is a mix of rules and estimates — label them
- **Source:** `planning/shared.md` "Plan content is a mix of rules and estimates"
- **Quote:** "A plan doc carries two kinds of content: rules that bind the implementation … and estimates of what the implementation will look like. Plan authors must structure the doc so the distinction is visible to both human reviewers and implementing agents"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-85: "Verified by:" annotations on load-bearing claims
- **Source:** `planning/shared.md` "`Verified by:` annotations on load-bearing claims"
- **Quote:** "Load-bearing claims in the plan about the codebase or supporting services … must carry an inline 'Verified by:' reference to the source that proves them."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Excellent rule.

#### R-86: Anchor preference — symbol over line-range
- **Source:** `planning/shared.md` "Anchor preference"
- **Quote:** "prefer symbol- or section-anchored references over `:N-M` line ranges when the cited target has a stable name."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-87: Quote labels whose enforcement depends on exact-match matching
- **Source:** `planning/shared.md` "Quote labels whose enforcement depends on exact-match matching"
- **Quote:** "When a plan references a label whose value is checked or queried by exact-string match … copy-paste from the source with a `path:line` citation rather than retyping."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-88: Falsifiability check on each load-bearing claim
- **Source:** `planning/shared.md` "Falsifiability check on each load-bearing claim"
- **Quote:** "For every claim the plan presents as load-bearing pre-merge proof … walk through the falsifier in your head: what observation would prove the claim wrong, and could the named procedure surface that observation?"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Excellent rule.

#### R-89: Decompose options into shapes before analyzing
- **Source:** `planning/shared.md` "Decompose options into shapes before analyzing"
- **Quote:** "When a Choose-One decision lays out the candidate set, the first step is enumeration, not analysis … are there sub-shapes — variants of how this option could be implemented — that would change the analysis?"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Excellent universal decision-making rule.

#### R-90: Anti-pattern — planning artifacts that only cite each other
- **Source:** `planning/shared.md` "Anti-pattern: planning artifacts that only cite each other"
- **Quote:** "If the plan, scoping doc, and milestone doc all cite each other for the same load-bearing claim, the claim is unverified. Fluent cross-doc citation is not verification."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-91: `Deferred` status for paused planning
- **Source:** `planning/shared.md` "`Deferred` status for paused planning"
- **Quote:** "Plans whose drafting is intentionally paused … carry Status `Deferred` (exact-match canonical token), optionally followed by an em-dash and freeform human-readable context … While Deferred, the doc's content is non-prescriptive"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** The non-prescriptive-on-resume framing is excellent and worth preserving.

### `docs/agents/planning/epic.md`

#### R-92: Epic scope — what an epic does and does not say
- **Source:** `epic.md` "Scope"
- **Quote:** "Epics scope the what and why of a multi-milestone arc: capability targets, cross-cutting invariants, milestone sequencing rationale, milestone-level risks, and the open questions the epic resolves or opens. Epics should not prescribe per-milestone phase counts, per-phase content, per-phase PR counts, validation-gate specifics …"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-93: Tag per-milestone details in epic as estimates
- **Source:** `epic.md` "Scope"
- **Quote:** "When an epic does name per-milestone details (during initial epic drafting, before the milestone planning sessions have run), tag them explicitly as estimates pending milestone planning, not as binding specs."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-94: Epic required/optional section set
- **Source:** `epic.md` "Required and optional sections"
- **Quote:** Lists required and optional sections
- **Scope:** project-specific
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** The principle (each plan doc type has a required/optional section set) generalizes; the specific list is project.

### `docs/agents/planning/milestone.md`

#### R-95: Milestone planning session — single doc as output, no per-phase scoping in this session
- **Source:** `milestone.md` "Anti-goal: do not scope any phase in this session"
- **Quote:** "Phase scoping and plan-drafting … belong to the phase planning session for each phase … Scoping any phase in the milestone session — even the first — risks recording assumptions that won't survive contact with merged code"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-96: Phase dependency graph via Mermaid flowchart
- **Source:** `milestone.md` "Phase dependency graph"
- **Quote:** "The milestone doc's `Sequencing` section opens with a Mermaid `flowchart LR` block: each phase is a node, 'blocks' relationships are arrows … makes parallelism visible at a glance instead of buried in prose"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-97: Verify before recording any cross-phase decision (read actual code, not subagent summaries)
- **Source:** `milestone.md` bullet
- **Quote:** "For each cross-phase decision, read the actual code that would be affected by each option, not summaries from a research subagent. A decision recorded with options/pros/cons but without code-grounded option generation is a guess dressed as rigor"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Excellent.

#### R-98: Defer rather than over-resolve cross-phase decisions
- **Source:** `milestone.md` bullet
- **Quote:** "If a cross-phase decision can be made later by the affected phase's planner without blocking earlier phases, mark it deferred with a clear 'decide when phase N drafts' note."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-99: PR-count predictions are not contracts
- **Source:** `milestone.md` bullet
- **Quote:** "Per-phase PR counts named in the milestone doc are estimates. The phase planning session re-derives the actual PR count …"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow, already-in-workstream-tracker-spec

### `docs/agents/planning/plan.md`

#### R-100: Picker discriminator — independent value vs sequence steps
- **Source:** `plan.md` "The picker discriminator"
- **Quote:** "Applied between adjacent levels: each milestone of an epic has independent stakeholder-facing value … phases of a task lack independent value — they are sequence steps toward the task's one outcome"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-101: Planning Depth — every execution gate as a separate step
- **Source:** `plan.md` "Planning Depth"
- **Quote:** "include every execution gate that materially affects quality, even if that makes the plan longer than five steps … do not merge steps just to keep the plan visually compact"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-102: Decision-completeness requirement
- **Source:** `plan.md` "Planning Depth"
- **Quote:** "for implementation plans, make the plan decision-complete enough that another engineer or agent can execute it without inventing missing gates, validation, or handoff work"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-103: Name self-review audits in the plan by surface
- **Source:** `plan.md` "Planning Depth"
- **Quote:** "name the self-review audits that apply to this PR's diff surfaces, drawn from `docs/self-review-catalog.md`. The plan should list audit names by surface … so the implementer runs them at commit boundaries rather than rediscovering review feedback at PR-review time"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-104: Just-in-time scoping; pending inputs cite concrete surface
- **Source:** `plan.md` "Just-in-time scoping and plan drafting"
- **Quote:** "A pending input is only valid if it cites the concrete surface where the decision is being made … Bare 'TBD,' 'pending,' or unattributed-prose entries do not count"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-105: Status lifecycle (In draft → Proposed → In progress → Landed)
- **Source:** `plan.md` "`In draft` → `Proposed` promotion gate" + "Plan-to-PR Completion Gate"
- **Quote:** "Plans in active multi-pass drafting may carry an interim `In draft` Status before `Proposed`; the `In draft` → `Proposed` flip is gated by the promotion-gate rule"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-106: Scoping owns / plan owns
- **Source:** `plan.md` "Scoping owns / plan owns"
- **Quote:** Splits ownership: scoping owns rejected alternatives, open decisions, handoff; plan owns durable record
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-107: Reality-check gate between scoping and plan
- **Source:** `plan.md` "Reality-check gate between scoping and plan"
- **Quote:** "Before promoting the scoping doc to plan-drafting, do a forced reality-check pass on every load-bearing claim about the codebase or supporting services."
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** The SQL/RPC/PostgreSQL examples are illustrative; the kernel ("verify against actually-merged code, not summaries") is universal.

#### R-108: Prefer existing wrapper scripts over lower-level CLI invocations
- **Source:** `plan.md` "Prefer existing wrapper scripts"
- **Quote:** "Before naming a validation command in a plan, search `package.json` `scripts` and `scripts/testing/` for an existing wrapper. If a wrapper exists, name it"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-109: Spike before plan for novel mechanisms
- **Source:** `plan.md` "Spike before plan for novel mechanisms"
- **Quote:** "When the plan introduces a new mechanism … build a 30-minute throwaway spike that exercises the mechanism end-to-end before writing the plan."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-110: PR-count predictions need a branch test (phase-plan)
- **Source:** `plan.md` "PR-count predictions need a branch test"
- **Quote:** "Before declaring '1 PR' in the plan's Status block, create the branch and sketch the file list. If the diff would touch >5 distinct subsystems or >300 LOC of substantive logic, split."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow, already-in-workstream-tracker-spec

#### R-111: Bans on surface require rendering the consequence
- **Source:** `plan.md` "Bans on surface require rendering the consequence"
- **Quote:** "When a plan writes 'no X' / 'minimum surface' / 'intentionally not done' for a user-visible or operationally-important surface, state in concrete terms what the absence looks like. For UX surfaces, render it"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec
- **Notes:** Excellent rule.

#### R-112: URL retarget re-audit (post-navigation component differs)
- **Source:** `plan.md` "When a URL retarget changes which component renders"
- **Quote:** "A test's locator inventory before and after a URL change can differ even when the URL is the only line edited."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** already-in-workstream-tracker-spec

#### R-113: Cross-app destinations need hard navigation
- **Source:** `plan.md` "Cross-app destinations need hard navigation"
- **Quote:** "Cross-app destinations need hard navigation (`window.location.replace` / `assign`) that exits the SPA and re-enters the routing layer."
- **Scope:** project-specific
- **Action:** keep-local-only
- **Type:** content-rule
- **Flags:** over-specific-could-generalize
- **Notes:** Very framework-specific (Next.js + Vercel + cross-app SPA). The broader concept ("client-side vs hard navigation matters when the upstream routing layer is part of the contract") is universal but rarely applicable.

#### R-114: Compound-noun discipline (rule-prose readability)
- **Source:** `plan.md` "Compound-noun discipline"
- **Quote:** "In rule prose under `docs/agents/planning/` and adjacent rule-bearing files, prefer compound forms ('task plan,' 'phase plan,' 'task-level,' 'phase-level') over bare 'plan' or bare 'task' wherever ambiguity could arise."
- **Scope:** adaptable
- **Action:** promote-to-meta
- **Type:** shallow-meta-rule
- **Flags:** none
- **Notes:** Worth promoting: the principle ("disambiguate overloaded nouns in rule prose") is universal; the specific compounds are not.

### `docs/agents/reference/architecture-guardrails.md`

#### R-115: Don't duplicate business rules across frontend and backend
- **Source:** `architecture-guardrails.md` "Architecture Guardrails"
- **Quote:** "Do not casually duplicate business rules across frontend and backend."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-116: Shared source-of-truth for correctness logic
- **Source:** `architecture-guardrails.md` "Architecture Guardrails"
- **Quote:** "If quiz correctness, scoring, or answer validation changes, make sure the shared source of truth still drives both the UI and the backend completion path."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Quiz-specific phrasing; generalize to "When correctness logic exists in a designated shared module, every consumer must continue to use it."

#### R-117: Don't treat development fallback as production behavior
- **Source:** `architecture-guardrails.md` "Architecture Guardrails"
- **Quote:** "Do not treat the local browser-only completion fallback as production backend behavior. Do not default to the local browser-only completion fallback when a remote Supabase integration run is feasible."
- **Scope:** project-specific
- **Action:** keep-local-only
- **Type:** content-rule
- **Flags:** none

#### R-118: Styling Token Discipline
- **Source:** `architecture-guardrails.md` "Styling Token Discipline"
- **Quote:** All rules about themable-vs-structural classification
- **Scope:** project-specific
- **Action:** keep-local-only
- **Type:** content-rule
- **Flags:** none
- **Notes:** Project-specific design system rules.

### `docs/agents/reference/documentation-currency.md`

#### R-119: Keep documentation synchronized with implementation
- **Source:** `documentation-currency.md` "Documentation Expectations"
- **Quote:** "Keep documentation synchronized with the implementation. For structural or multi-file work, documentation is part of the execution loop, not a final polish pass."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-120: Status-oriented sections updated in same change
- **Source:** `documentation-currency.md` "Documentation Expectations"
- **Quote:** "when a touched doc contains a status-oriented section (for example `Current State`, `Current status`, rollout status, or phase status), update that section in the same change so it reflects the implemented state"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-121: Per-named-doc update triggers
- **Source:** `documentation-currency.md` "Update [...] when:" sections
- **Quote:** Specific update triggers for README, architecture.md, dev.md, open-questions.md, etc.
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** over-specific-could-generalize
- **Notes:** The pattern (each canonical doc has a trigger list) generalizes; the specific lists do not.

#### R-122: Doc Currency Is a PR Gate
- **Source:** `documentation-currency.md` "Doc Currency Is a PR Gate"
- **Quote:** "Before opening or updating a PR, verify that every named doc that the branch should have touched actually reflects the implemented state, not the pre-implementation state."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** Universal kernel; GH carrier.

#### R-123: Ephemeral Identifiers In Durable Docs
- **Source:** `documentation-currency.md` "Ephemeral Identifiers In Durable Docs"
- **Quote:** "Durable docs … must not embed PR numbers, commit IDs, or other ephemeral coordination identifiers."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent universal rule.

### `docs/agents/reference/pr-template.md`

#### R-124: Use Conventional Commits
- **Source:** `pr-template.md` "Commit Message Expectations"
- **Quote:** "Use the Conventional Commits convention for commit messages in this repo."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-125: PR body section schema (Summary, Why, User Behavior, Contract And Scope, Target Shape Evidence, Documentation, Estimate Deviations, UX Review, Validation, Remaining Risk)
- **Source:** `pr-template.md` "PR Body Template"
- **Quote:** The verbatim template
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** embeds-github-workflow
- **Notes:** Section schema is universal-quality; the verbatim validation commands are project. Ship the schema, drop the commands.

#### R-126: Never leave Remaining Risk blank
- **Source:** `pr-template.md` "Section-specific rules"
- **Quote:** "Never leave this blank. Write 'None known.' if there are no residual risks."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-127: Validation section honesty (check off only what you ran)
- **Source:** `pr-template.md` "Section-specific rules"
- **Quote:** "Check off every item you actually ran. Add rows for any extra commands run. Explicitly list any named check that could not be run and why."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

### `docs/agents/reference/validation.md`

#### R-128: Run checks relevant to the area you changed
- **Source:** `validation.md` "Validation Expectations"
- **Quote:** "Run the checks relevant to the area you changed."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-129: If a check could not be run, say so explicitly
- **Source:** `validation.md` "Validation Expectations"
- **Quote:** "If you could not run a relevant check, say so explicitly and explain why."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-130: Validation Honesty list
- **Source:** `validation.md` "Validation Honesty"
- **Quote:** "Do not overstate what was validated. Run the validation commands named by the task or checklist before handoff. If you added a new test command, validation surface, or workflow step, prefer to run it locally before opening or updating a PR …"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent set.

#### R-131: Continuous Validation cadence
- **Source:** `validation.md` "Continuous Validation"
- **Quote:** "for multi-file or non-trivial work, run the relevant checks before each commit, not only before handoff"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-132: PR Readiness — not speculative drafts
- **Source:** `validation.md` "PR Readiness"
- **Quote:** "Treat pull requests as reviewable engineering work, not speculative drafts with known unverified edges hidden inside them."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** embeds-github-workflow

#### R-133: Regression Discipline (operational regressions in addition to product)
- **Source:** `validation.md` "Regression Discipline"
- **Quote:** "When a change touches testing infrastructure, validation commands, CI, or local setup, review it for operational regressions in addition to product regressions."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-134: Test Boundary Discipline
- **Source:** `validation.md` "Test Boundary Discipline"
- **Quote:** "A unit test should fail when the unit's contract is violated and pass otherwise. If unrelated data … requires editing the test, the test boundary is wrong"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Excellent universal-quality rule.

#### R-135: Testing Tiers Discipline — only gate on tiers executable pre-merge
- **Source:** `validation.md` "Testing Tiers Discipline"
- **Quote:** "Plans may gate merge only on tiers the implementer can actually execute against the pre-merge state of the code."
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none

#### R-136: Plans must not require contributors to configure production credentials locally
- **Source:** `validation.md` "Testing Tiers Discipline"
- **Quote:** "Plans must not require contributors to configure production credentials on local laptops."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

### `docs/plans/AGENTS.md`

Pure router fragment — no rules extracted.

### `docs/self-review-catalog.md`

The catalog is a list of 19 specific audits. Most are project-specific; the *catalog mechanism* and a few audits at the universal end are extractable.

#### R-137: Catalog purpose — named, reusable audits to run on a diff before push
- **Source:** `self-review-catalog.md` "Purpose"
- **Quote:** "Named, reusable audits to run on a diff before push. Each audit is a reviewer's lens — a specific class of issue that reviewers (human or AI) would otherwise flag."
- **Scope:** adaptable
- **Action:** promote-to-meta
- **Type:** deep-meta-rule
- **Flags:** none
- **Notes:** The catalog *mechanism* is universal. Worth shipping the harness.

#### R-138: Catalog lifecycle — add when 2+ PRs, drop when automated check covers it
- **Source:** `self-review-catalog.md` "Contributing"
- **Quote:** "Add a new audit when … A reviewer flags the same class of issue on two or more distinct PRs, or a single P1-severity finding has a root cause that clearly generalizes … Drop an audit when an automated check now enforces it. The pattern has not recurred in six months"
- **Scope:** adaptable
- **Action:** promote-to-meta
- **Type:** deep-meta-rule
- **Flags:** none
- **Notes:** Excellent lifecycle rule for any catalog of recurring-issue audits.

#### R-139: Audit entry format — Trigger / Check / Example
- **Source:** `self-review-catalog.md` "Contributing"
- **Quote:** "Every entry must have Trigger (one-sentence diff pattern, not a vibe), Check (concrete walk-through), and Example."
- **Scope:** universal
- **Action:** promote-to-meta
- **Type:** deep-meta-rule
- **Flags:** none

#### R-140: Short triggers beat elaborate ones
- **Source:** `self-review-catalog.md` "Contributing"
- **Quote:** "Short triggers beat elaborate ones. A trigger like 'any migration touches GRANT EXECUTE' is actionable; 'think about authorization' is not."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** shallow-meta-rule
- **Flags:** none

#### R-141: Audits run at every commit boundary, not just end
- **Source:** `self-review-catalog.md` "How to use"
- **Quote:** "For multi-commit branches, run the audits at each commit boundary, not only at the end. Small diffs are easier to audit honestly."
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-142: 19 specific audits (Grant/body contract, CHECK NULL, Privilege vacuous-pass, Legacy-data precheck, Replica-mode trigger suppression, Supabase FK fragility, pgTAP output stability, Dirty-state tracked-inputs, Post-save reconciliation, Unchanged-vs-explicit-write, Error-surfacing, Effect cleanup, CLI/tooling pinning, Rename-aware diff classification, Readiness-gate truthfulness, Psql meta-syntax, Silent-no-op on missing lookup, Platform-auth-gate config, Composed-predicate error-treatment, Route topology coupling, Validation-command coupling, Canonical-owner duplication, Phase-identifier and target-state-language)
- **Source:** `self-review-catalog.md` body
- **Quote:** Per-audit
- **Scope:** project-specific
- **Action:** drop
- **Type:** content-rule
- **Flags:** none
- **Notes:** All 19 are project-specific. A handful (Effect cleanup, Error-surfacing for user-initiated mutations, Readiness-gate truthfulness, Rename-aware diff classification) generalize cleanly and might seed a starter catalog in the shared repo — but defer that decision to the design phase. Counted as one inventory entry since the catalog is the rule, not each audit.

### `docs/dev.md` (skim)

Mostly setup and procedure; rules extracted where present.

#### R-143: Code documentation standard — required comment targets
- **Source:** `dev.md` "Code documentation standard"
- **Quote:** "Use TypeScript types, clear names, and small modules as the first layer of documentation. Add TSDoc/JSDoc or concise inline comments only where the code's contract, intent, or failure behavior is not obvious from the implementation."
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none

#### R-144: Required comment targets list
- **Source:** `dev.md` "Code documentation standard"
- **Quote:** List of targets (file-level headers for boundary modules, exported functions at shared domain boundaries, trust/persistence/auth boundaries, etc.)
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** laundry-list-style
- **Notes:** The kernel ("comment where the contract is non-obvious") is universal; specific targets are project.

#### R-145: Avoid comment noise (no restating code, no phase-tracking-in-comments)
- **Source:** `dev.md` "Code documentation standard" + `documentation-currency.md`
- **Quote:** "Do not add comments that merely restate the code. … do not use inline comments as phase tracking, release status, or TODO storage"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** duplicate-of-R-119
- **Notes:** Slight overlap with documentation-currency Doc Currency rule.

#### R-146: File-level headers answer "what is this file responsible for" + "what does it deliberately not own"
- **Source:** `dev.md` "Code documentation standard"
- **Quote:** "File-level headers should answer 'what is this file responsible for?' and, when useful, 'what does this file deliberately not own?'"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none
- **Notes:** Good universal rule.

#### R-147: Edge Function isolate lifecycle — await side-effect writes
- **Source:** `dev.md` "Edge Function isolate lifecycle"
- **Quote:** "Edge Function isolates terminate as soon as the response is sent … Await all side-effect writes (DB inserts, external calls) before returning the response."
- **Scope:** project-specific
- **Action:** keep-local-only
- **Type:** content-rule
- **Flags:** none

#### R-148: PR body content checklist (dev.md sibling of pr-template)
- **Source:** `dev.md` "Pull Request Notes"
- **Quote:** PR body should include: why merging, user-behavior delta, contract/scope, target-shape evidence, doc updates, UX review, validation, remaining risk
- **Scope:** adaptable
- **Action:** drop
- **Type:** content-rule
- **Flags:** duplicate-of-R-125, embeds-github-workflow
- **Notes:** Duplicates pr-template.md content.

### `README.md` (skim)

Mostly project overview. The only rule-bearing content is the deployment/quick-start convention, which is project-specific.

No additional rules extracted that aren't covered above (validation commands list is project-specific).

### `docs/testing.md` (skim)

#### R-149: Test the seams where bugs would actually hurt
- **Source:** `testing.md` "Testing Principles"
- **Quote:** "The highest-value seams in this repo are: shared answer validation and scoring; frontend game progression …"
- **Scope:** adaptable
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none
- **Notes:** Kernel (test high-value seams) universal; examples project.

#### R-150: Prefer one strong test at the right layer over three weak tests at the wrong layer
- **Source:** `testing.md` "Testing Principles"
- **Quote:** Title; "test `scoreAnswers` and `validateSubmittedAnswers` directly instead of only through UI clicks; test the completion RPC in a real database instead of mocking Postgres"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

#### R-151: Mock external boundaries, not core business rules
- **Source:** `testing.md` "Testing Principles"
- **Quote:** "Use mocks when isolating browser code from network behavior. Do not mock: the shared game domain logic when it is the thing being trusted; the SQL RPC when testing entitlement and idempotency behavior"
- **Scope:** universal
- **Action:** rewrite-or-generalize
- **Type:** content-rule
- **Flags:** none

#### R-152: Keep CI deterministic — no shared remote backends
- **Source:** `testing.md` "Testing Principles"
- **Quote:** "PR CI should not depend on: a shared remote Supabase project; manually managed event data; flaky visual diffs"
- **Scope:** universal
- **Action:** keep-as-is
- **Type:** content-rule
- **Flags:** none

### `docs/styling.md` (skim)

The doc carries the binding token classification (themable vs structural). It is referenced by R-118 above as project-specific. No additional rules extracted that aren't covered there.

---

## End of inventory

Total rule entries: **152** (R-01 through R-152; some IDs cover catalog mechanisms or related rule clusters).
