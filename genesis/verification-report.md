# shared-agent-rules — Verification Report

Independent verification of the build output (phase 3) against the
audit (phase 1) and design (phase 2) contracts.

- Build: `repo/` — 44 files (one short of 45 claimed; not material).
- Audit: 152 rules (R-01 through R-152).
- Design: 12 module folders / 16 library files + starter + scripts +
  proposals.
- Method: enumerated every audit rule's disposition, scraped audit-ID
  footers from every library file, scanned every relative link with a
  walker, read each load-bearing module against the design's section
  4 description, and spot-checked five rules against the neighborly
  source.

---

## 1. Summary

- **Rules checked:** 152 of 152 (all audit IDs).
- **Build coverage:** 102 of an expected 103 placements clean. 1
  audit rule (R-03) is materially unplaced; R-02 is placed but
  inline-in-starter rather than library, which is a judgment call I
  side with the build agent on (see §5).
- **Cross-references checked:** 60 internal `../`-style links resolve
  cleanly; 3 cross-references to `workstream-tracker/spec/` use a
  wrong path that breaks after vendoring; one starter-layout link
  set that "breaks" in the source tree is intentional.
- **Locked-in decisions:** 8 of 8 verified present.
- **Module taxonomy:** holds; intentional R-127, R-134, R-122, R-121,
  R-34 duplications are by design (cross-references and split rules)
  but R-127's footer pair could be cleaner.
- **assemble.sh:** functional, uses `## Local additions` delimiter,
  emits the generated-file header, handles missing-source-module
  gracefully. Does NOT consume the `workstream_tracker_spec:` block;
  judgment call.

**Overall verdict: ship after small fixes.** The three workstream-
tracker cross-reference paths are the only must-fix item that breaks
in the load-bearing case (consumer vendoring); everything else is
small-cleanup or judgment.

---

## 2. Rule coverage results

Verified each audit rule's disposition against the build:

- **Routed to workstream-tracker/spec/ (R-58 through R-62, R-78
  through R-112 minus exceptions):** confirmed not in any library
  footer. Only CHANGELOG references them, listing them as routed.
  Clean.
- **Dropped (R-32 roadmap-fit, R-142 catalog content, R-148 dup of
  R-125):** confirmed absent from library. R-32's kernel paragraph
  is preserved in `library/meta/rule-additions.md` per resolved Q9
  (verified — "Optional extension: roadmap-fit analysis" section).
- **Keep-local-only (R-113 cross-app, R-117 dev-fallback, R-118
  styling, R-147 edge-function isolate):** confirmed absent from
  library. Clean.

### Issues

- **R-03 (capture uncertainty in open-questions surface) is
  unplaced.** The audit marked it `rewrite-or-generalize`, universal
  scope. The build only mentions "open-questions surface" obliquely
  in a starter/AGENTS.md comment about Repo orientation (line 21).
  The rule itself ("When the codebase or docs leave a decision
  unresolved, record it in the designated open-questions surface;
  do not invent an answer") is not actually stated anywhere.
  **Severity: must-fix.** Suggested home:
  `library/core/pre-edit-gate.md` as a new section, or a short
  module under `library/core/` named `decision-discipline.md`.
  Lightweight enough that a paragraph in pre-edit-gate.md is fine.
- **R-02 (joint sources of truth; stop on conflict) is in
  starter/AGENTS.md only, with no audit-ID footer.** The build
  agent flagged this as a judgment call; I agree with the placement.
  The rule's content is repo-specific ("AGENTS.md vs dev.md
  conflict"), so it doesn't fit cleanly in any library module; the
  starter is the right carrier. **Severity: nice-to-have** — add a
  sentence in `library/meta/router-pattern.md` describing the
  joint-source-of-truth pattern with cross-reference to the
  starter, and add an audit-ID comment in the starter file marking
  R-02.

### Duplications (intentional by design — none material)

| ID    | Files                                             | Verdict |
|-------|---------------------------------------------------|---------|
| R-34  | workflows/implementation, meta/light-vs-full-thresholds | Design 4.6 explicit: thresholds *meta*-rule moved to meta; the implementation file still uses the threshold structure. Both footers cite. Acceptable but cleaner to drop R-34 from implementation footer and leave a body-level note. |
| R-121 | doc-currency/currency, meta/doc-ownership-table   | meta footer says "convention that supports R-121"; clean. |
| R-122 | doc-currency/currency, validation/philosophy      | Design 4.11 / 4.13 split (currency vs gate-cadence kernel); clean. |
| R-127 | pr-conventions/pr-body-shape, validation/philosophy | Design 4.12 said "cross-reference rather than restate." Both footers cite R-127 without distinguishing primary vs cross-ref. Cleaner: drop R-127 from pr-body-shape footer; it's already cross-referenced in the body. |
| R-134 | testing/principles, validation/philosophy         | testing/principles footer notes "R-134 cross-referenced from validation/philosophy.md"; clean. |

No misplaced rules.

---

## 3. Cross-reference issues

### The workstream-tracker/spec/ path bug (must-fix)

Three files contain the relative path
`../../../workstream-tracker/spec/planning/task-plan.md`:

- `library/pr-conventions/pr-body-shape.md` line 67
- `library/doc-currency/ephemeral-identifiers.md` line 98
- `library/meta/light-vs-full-thresholds.md` line 37

Resolution check, per design §2.5 assumed deployment shape:

- Vendored shared file lives at
  `<consumer>/docs/agents/shared/<topic>/<file>.md`.
- Spec is vendored at `<consumer>/docs/spec/...` (the design
  prompt's verification spec is explicit about this).
- From `docs/agents/shared/pr-conventions/pr-body-shape.md`, the
  three `..` segments climb to `docs/`. Adding
  `workstream-tracker/spec/planning/task-plan.md` produces
  `docs/workstream-tracker/spec/planning/task-plan.md` — which is
  not where spec lives. Broken in the load-bearing case.
- The correct path is `../../../spec/planning/task-plan.md`.

The path also "resolves" in the shared-repo's own filesystem only by
coincidence — to a sibling-repo location `../workstream-tracker/spec/`
that exists if a developer has both repos checked out side-by-side.
That's a dev-time accident, not a contract.

**Recommended global fix:** in all three files, replace
`../../../workstream-tracker/spec/planning/task-plan.md` with
`../../../spec/planning/task-plan.md`. The plaintext bracket label
(`[workstream-tracker/spec/planning/task-plan.md]`) can stay — it's
the human-readable name of the doc — but the URL part must be the
vendored-layout path.

### Other cross-reference issues

- All other internal `../`-style links in `library/` resolve from
  their linking file. Clean.
- The `starter/` directory has dozens of links like
  `docs/agents/shared/core/pre-edit-gate.md` from
  `starter/AGENTS.md`. These do not resolve from inside `starter/`
  because the starter is a template — it's shown how it should look
  after copying to the consumer's repo root. Intentional. No fix.
- One link in `starter/docs/agents/README.md` is `/AGENTS.md`
  (absolute root path) — that resolves at consumer-adoption time to
  the repo root. Intentional. No fix.

---

## 4. Locked-in decisions verdict

| # | Decision | Verdict | Evidence |
|---|----------|---------|----------|
| 1 | `pr-body-shape.md` includes Estimate Deviations with cross-ref to spec/ | **Pass** (modulo path bug, §3) | `pr-body-shape.md:57-73` |
| 2 | `meta/light-vs-full-thresholds.md` uses neighborly's narrow-surface-plan-vs-lightweight-implementation example | **Pass** | `light-vs-full-thresholds.md:22-53`, canonical illustration is the lightweight-vs-narrow-surface pair |
| 3 | `meta/rule-additions.md` includes R-32 kernel paragraph | **Pass** | `rule-additions.md:51-62`, "Optional extension: roadmap-fit analysis" section |
| 4 | `self-review/how-to-use.md` uses 4-group split (correctness / drift / downstream impact / scope discipline) | **Pass** | `how-to-use.md:30-89`, all four headers present and load-bearing |
| 5 | `core/anti-patterns.md` regrouped by organizing principle, not flat list | **Pass** | Four groups: don't defer validation / don't let supporting artifacts drift / don't bundle unrelated cleanup / don't name durable artifacts after the rollout cycle |
| 6 | `meta/doc-ownership-table.md` includes 3-row example | **Pass** | `doc-ownership-table.md:35-39`, exactly three rows (README, architecture, dev) |
| 7 | `scripts/assemble.sh` uses `## Local additions` as overlay delimiter | **Pass** | `assemble.sh:103-108` |
| 8 | CalVer (2026-05-15) versioning + single library version for v0.0 | **Pass** | `VERSIONING.md` (not re-read here), `CHANGELOG.md` v2026-05-15, `MANIFEST.example.yaml` version: 2026-05-15 |

All eight locked-in decisions pass. The cross-reference to spec/ in
decision 1 has the wrong relative path; the *placement* of the
Estimate Deviations section in the schema is correct.

---

## 5. Build agent flag resolutions

### 5.1 R-02 and R-03 embedded in starter/AGENTS.md instead of library/

**My read.** R-02 is a true placement judgment call; R-03 is
unplaced (see §2). R-02 is project-specific in its concrete form
("AGENTS.md vs dev.md conflict") and generalizes to "joint
sources-of-truth stop on conflict" — that's a small enough rule
that a paragraph in `library/meta/router-pattern.md` (since it's a
rule-system organization rule) or in the starter is fine. **Verdict:
R-02 placement is structurally sound; recommend an audit-ID footer
or comment in the starter referencing R-02 so coverage is
traceable. R-03 needs a real placement.**

### 5.2 R-115 and R-116 (universal architecture-guardrails kernel) have no home

R-115 (don't duplicate business rules across frontend and backend)
is universal, keep-as-is. R-116 (shared source-of-truth for
correctness logic) is universal kernel with quiz-specific phrasing.

**Spot-check finding.** R-116's kernel is partially present in
`self-review/how-to-use.md` Step 4: "Any designated shared
source-of-truth logic remains the source of truth where
applicable." That covers the *review* side. R-115 isn't stated
anywhere in the library.

**Verdict.** The build agent's suggested home —
`core/change-boundaries.md` — fits. The natural home is actually
a new short section in `core/change-boundaries.md` titled
"Shared source-of-truth for cross-surface correctness" carrying
both R-115 and R-116. The module is 43 lines today (per design,
"intentionally short"), so adding 10-15 lines doesn't bloat it.
Alternative: a new file `library/core/shared-source-of-truth.md`,
but that's overkill for two rules. Recommend the change-boundaries
addition. **Severity: must-fix** if treating audit coverage as a
contract; nice-to-have if you accept the build agent's "no home"
status. I'd push to add it — R-115 is a load-bearing universal
guardrail that catches real bugs.

### 5.3 R-29/R-30 footer convention in scope-and-stop.md

R-29 (consolidated stop-and-report list) is sub-grouped into
Scope/Contract/Quality/Surface in
`library/core/scope-and-stop.md:54-87` per audit note 8 and the
design's call. R-30 (Sub-Agent Delegation as a unit) is captured
by the cross-reference to `delegation/sub-agent-delegation.md` and
the footer correctly notes "R-29, R-30." **Verdict: fine.**

### 5.4 assemble.sh at 95 lines (over the 30-80 target)

Actual line count is **114**, not 95 as the build agent reported.
The script:

- Reads manifest fields (`shared_agent_rules.source`, `.version`,
  `overlay_root`, `modules:`).
- Falls back from `yq` to a grep+awk parser.
- Clones at the named CalVer tag with depth=1.
- Writes a generated-file header to each shared output.
- Appends overlay under `## Local additions` if present.
- Handles missing source modules gracefully (warns and `continue`).

**Verdict: fine-with-cleanup-recommendation.** 114 lines for a
build script is fine in absolute terms — the script is doing
real work (YAML parsing fallback, git fetch, dual-mode read).
The 30-80 line target in the design was an aspiration, not a
contract. Don't shrink for shrink's sake. If cleanup is desired:
the `read_field` function's grep-fallback can be simplified, and
the `git clone || git clone --no-branch` fallback is awkward (it
will clone twice if the first fails for any reason other than a
missing tag). Both are non-blocking.

---

## 6. Module taxonomy / meta-rule layer check

- Every library file maps to a design §4 module description.
- Meta-rule layering is correct:
  - Deep meta in `meta/`: `router-pattern.md` (R-01),
    `rule-additions.md` (R-31). Both explicitly tagged
    "Deep meta-rule" in their bodies.
  - Deep meta in `self-review/`: `mechanism.md` (R-137 through
    R-141). Tagged "deep meta-rule" in its body.
  - Shallow meta in `meta/`: `compound-noun-discipline.md` (R-114,
    tagged "Shallow meta-rule"), `light-vs-full-thresholds.md`
    (R-34, tagged "Shallow meta-rule"),
    `reality-check-examples-as-footnotes.md` (the audit's note 9
    pattern), `doc-ownership-table.md` (optional convention).
- Each kept/rewritten audit rule has a primary home; the few
  duplicates (R-34, R-121, R-122, R-127, R-134) are by design
  with clean reasons. R-127's footer pair could be tidier (see §2).
- Each module's purpose matches the design's section 4 description.

No taxonomy issues.

---

## 7. Quality spot-check (5 rules)

Selected to hit ≥2 keep-as-is, ≥2 rewrite-or-generalize, ≥1
over-specific-could-generalize flag, and pull from modules adjacent
to the issues found above.

### R-07 (Pre-Edit Gate — positive value; keep-as-is, universal)

- **Source.** `neighborly/AGENTS.md` "Pre-Edit Gate" — "confirm
  the requested change is expected to be positive value for the
  codebase: it should reduce real risk, duplication, confusion,
  operational friction, or product/user pain enough to justify
  its diff and review cost."
- **Build.** `library/core/pre-edit-gate.md:47-54`, near-verbatim.
  Adds the audit's R-29 "needless / cosmetic" stop-and-report tie-in
  in the same paragraph. Coherent.
- **Verdict.** Preserves meaning faithfully. No protection lost.

### R-130 (Validation Honesty list; keep-as-is, universal)

- **Source.** `neighborly/docs/agents/reference/validation.md`
  "Validation Honesty" — list of seven items.
- **Build.** `library/validation/philosophy.md:37-62`, all seven
  items preserved with "PR" generalized to "change for review."
  One concrete generalization: the audit's "if the test runs in
  fallback or mocked mode, document that precisely" is kept.
- **Verdict.** Pass. Meaning preserved, generalization clean.

### R-22 (phase-named test files; rewrite-or-generalize +
over-specific-could-generalize)

- **Source.** `neighborly/AGENTS.md` Anti-Patterns — "naming
  living test or code files after the rollout phase that produced
  them (for example `foo_phase3_bar.test.sql`); name by the
  feature or surface under test."
- **Build.** `library/core/anti-patterns.md:61-76`. Rule body is
  fully generalized ("Durable artifacts are named by what they
  are, not by the rollout cycle that produced them"); the pgTAP
  example becomes a footnote labeled "Consumers can replace this
  footnote with their own incident."
- **Verdict.** Strong rewrite. Universal kernel preserved, the
  forensic example demoted exactly per the design's locked-in
  "forensic rules become footnotes" pattern.

### R-77 (PR screenshots via external host; rewrite-or-generalize +
embeds-github-workflow)

- **Source.** `neighborly/docs/agents/workflows/ui-review.md`
  "Pull Request Screenshot Process" — `catbox.moe` named
  explicitly as the host.
- **Build.** `library/workflows/ui-review.md:74-94`. Rule body is
  generic ("Upload to an external image host so the change
  description can reference them by URL"); `catbox.moe` demoted
  to footnote "consumers should pick their own image host
  appropriate to their org's data-handling rules — e.g., an
  internal asset bucket, an existing CDN, or a chosen third-party
  host."
- **Verdict.** Pass. Cleaner than the source — the org-data-
  handling caveat is an upgrade.

### R-114 (compound-noun-discipline; promote-to-meta,
shallow-meta-rule)

- **Source.** `neighborly/docs/agents/planning/plan.md`
  "Compound-noun discipline" — cites bare "plan" / "task" as the
  specific overloaded nouns.
- **Build.** `library/meta/compound-noun-discipline.md` —
  generalized to "any noun in rule prose with both narrow and
  broad meanings"; neighborly's plan/task examples shipped as
  "illustrative examples" section; the rule then lists other
  common overloaded nouns (event, session, job, build, test) that
  any consuming repo might face.
- **Verdict.** Strong promotion. The rule is now applicable to
  any consuming repo, not just one with a planning vocabulary.

**Summary of spot-checks: 5 of 5 pass.** No rule lost meaning or
protection.

---

## 8. assemble.sh review

- **Manifest format.** Parses `shared_agent_rules.source`,
  `shared_agent_rules.version`, `overlay_root`, and the `modules:`
  list (awk parser, falls back from `yq` to grep). Does NOT read
  the `workstream_tracker_spec:` block at all. The block is
  present in `MANIFEST.example.yaml` per the design's 6.1, but the
  script doesn't act on it. This is a partial gap: the design
  doesn't actually say assemble.sh must vendor spec/ — only that
  the manifest declares the version pin. If the intent is
  "version-pin recordkeeping," current behavior is fine. If the
  intent is "assemble.sh also vendors spec/," it's missing.
  **Verdict: judgment call.** I'd flag this as a documentation
  clarification rather than a script bug — add a comment in
  assemble.sh saying "we do not vendor `workstream_tracker_spec`
  here; the block records the pinned version for downstream
  audit, and spec/ is vendored by the workstream-tracker
  consumption flow."
- **Generated-file header.** Written per design 6.2 step 5:
  source version + module path + edit-the-upstream warning.
  Lines 90-98. Pass.
- **Missing source module.** Warning + `continue` so other
  modules still process. Lines 84-87. Pass.
- **Missing overlay.** Just skips the append. Lines 101-109.
  Pass.
- **Other.** The `git clone --branch "$VERSION" || git clone` fallback
  on line 72-73 will end up making the second clone attempt without
  the branch flag if the first fails for *any* reason. That works
  in practice (a default-branch clone then `checkout $VERSION` on
  line 76 will catch the tag), but it's a noisy fallback. Cosmetic.

---

## 9. Recommended fixes

### Must-fix before ship

1. **Correct the workstream-tracker/spec/ cross-reference paths.**
   Replace `../../../workstream-tracker/spec/planning/task-plan.md`
   with `../../../spec/planning/task-plan.md` in:
   - `repo/library/pr-conventions/pr-body-shape.md` line 67 (and
     also line 122, in the unbracketed cross-references list — same
     fix, drop the leading `workstream-tracker/`).
   - `repo/library/doc-currency/ephemeral-identifiers.md` lines 98
     (bracketed URL) and 110 (plaintext cross-ref — display name
     can stay).
   - `repo/library/meta/light-vs-full-thresholds.md` lines 37
     (bracketed URL) and 81 (plaintext cross-ref).

   The bracket *display name* (`[workstream-tracker/spec/planning/
   task-plan.md]`) should stay since it names the doc; only the
   parenthesized URL portion needs the fix.

2. **Place R-03 (open-questions surface rule).** Add a short
   paragraph to `repo/library/core/pre-edit-gate.md` (insertion
   point: a new "## Capture uncertainty, do not invent answers"
   section after "Confirm positive value"). Update the
   pre-edit-gate.md footer's audit IDs to include R-03.

### Nice-to-have

3. **Tighten R-127 footer attribution.** In
   `repo/library/pr-conventions/pr-body-shape.md` line 131, drop
   R-127 from the footer; the body cross-references
   `validation/philosophy.md` already, so the audit-ID footer
   should reflect the primary home only. Add a body comment
   "validation honesty (R-127) lives in validation/philosophy.md"
   for traceability.

4. **Tighten R-34 footer attribution.** In
   `repo/library/workflows/implementation.md` line 261, the footer
   cites R-34 alongside R-33. Per the design, R-34's *meta-rule*
   form lives in `meta/light-vs-full-thresholds.md`, but the
   implementation file uses the threshold pair. Acceptable to keep
   the footer dual; cleaner to drop R-34 from the implementation
   footer and leave a body note. Judgment call.

5. **Add R-02 audit-ID marker in starter.** In
   `repo/starter/AGENTS.md`, add an HTML comment near line 32
   ("When agent rules in this file conflict with the contributor-
   workflow doc, stop and report") tagging R-02. Coverage
   traceability improves; no content change needed.

6. **Address R-115 and R-116 (universal architecture-guardrails
   kernel).** Add a short section to
   `repo/library/core/change-boundaries.md` titled "Shared
   source-of-truth for cross-surface correctness":
   - "Do not casually duplicate business or correctness rules
     across frontend and backend, or across services."
   - "When the codebase has a designated shared module that owns
     correctness logic (validation, scoring, authorization
     evaluation), changes to that logic land in the shared module,
     and every consuming surface continues to use it. The shared
     module is the source of truth; duplicating its logic
     downstream is how the surfaces drift."
   Update footer to include R-115, R-116. ~12 lines added.

7. **Clarify `workstream_tracker_spec:` block intent in
   assemble.sh.** Add a comment block at the top of
   `repo/scripts/assemble.sh` noting that the manifest's
   `workstream_tracker_spec:` block records the pinned spec/
   version for downstream audit but is not consumed by this
   script. Reduces reader confusion when the script doesn't
   reference the field.

8. **Trim assemble.sh `git clone` fallback.** Replace the
   `git clone --branch "$VERSION" ... || git clone ...` two-step
   with a single clone followed by `git -C "$WORKTREE" checkout
   "$VERSION"`. Avoids the spurious second clone on transient
   errors.

---

## Closing notes

- **Total issues found:** 8 (2 must-fix, 6 nice-to-have).
- **Total fixes recommended:** 8 (2 must-fix, 6 nice-to-have).
- **Report file written to:**
  `/Users/kyle/Library/Application Support/Claude/local-agent-mode-sessions/e79a97c4-52e3-4116-a5a1-f7b79de47037/6de7d5db-2e7c-46a6-a8ca-74df5531010d/local_4ea29352-f6e5-4ef6-ab4b-60d257077f02/outputs/shared-agent-rules-staging/verification/verification-report.md`

### What I'd want a human to weigh in on

- **R-115 / R-116 placement.** The build agent flagged these as
  "no home." I recommend adding them to `core/change-boundaries.md`.
  Alternative views are defensible: (a) treat the kernel as
  implicitly covered by self-review's "designated shared
  source-of-truth logic remains the source of truth" pass, (b) ship
  them in a tiny standalone `core/source-of-truth.md` module
  instead of bolting onto change-boundaries. Worth a one-minute
  judgment call.
- **The `workstream_tracker_spec:` manifest block.** The design 6.1
  introduces it, but neither the design 6.2 nor the build's
  assemble.sh actually consumes it. Two interpretations: (1) the
  block is metadata-only (version pin for audit; consumer vendors
  spec/ separately) — current state is correct, just document it;
  (2) the block is meant to drive a second vendoring pass — script
  is incomplete. Worth confirming.
- **The 4-group self-review split.** The design's open-question 10
  proposed correctness / drift / downstream impact / scope
  discipline. The build adopts that split verbatim. I think the
  split is clean; a human reviewer should sanity-check that the
  group memberships match how they'd actually self-review (e.g.,
  "complete call-site coverage" went into correctness; could
  arguably be downstream-impact).
- **The optional R-32 kernel paragraph in rule-additions.md.**
  Build included it per resolved Q9. Worth a sanity-check that the
  framing ("Optional extension: roadmap-fit analysis") reads as
  "this is a hook for consumers, not a default" — I think it does
  but it's the kind of thing a second reader catches faster.
