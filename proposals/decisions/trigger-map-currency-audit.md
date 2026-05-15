# Proposal: New Audit — `trigger-map-currency`

**Type:** 2 (new audit).
**Status:** Accepted 2026-05-16 (content landed in `library/`; see CHANGELOG).
**Proposing consumer:** `shared-agent-rules` itself — self-review of v0.0 by the maintainer.
**Date filed:** 2026-05-15.

## Firing context

External review of v0.0 surfaced the risk that path-triggered rules drift as the codebase evolves. A folder rename, a sibling-directory split, a new top-level category — any of these can silently invalidate the path glob that fires a rule, leaving the underlying intent unprotected without warning. Some intent surfaces — security-sensitive paths, schema-change folders, deployment-config files — have high enough blast radius that drift detection cannot wait for incidental discovery.

The companion rule-change proposal (`intent-statement-required-for-path-triggers.md`) requires every path-triggered rule to carry an explicit Intent line. This audit makes that intent statement load-bearing by comparing it against the trigger map's current state.

Filed against v0.0 before any consumer integration; the firing pattern is the rule system's own design review.

## Why existing rules didn't prevent it

No existing audit fires on rule-system drift. The closest existing rule, `library/doc-currency/currency.md`, governs doc drift but covers durable docs in the codebase, not the rule system's trigger map. The trigger map is a special kind of durable artifact — it's the binding declaration of "these intents need reading" — and it deserves a dedicated drift check rather than being folded into general doc currency.

The self-review catalog mechanism in `library/self-review/mechanism.md` already supports the catalog format and lifecycle, so this audit is a content addition, not a mechanism change.

## Candidate audit body

### Trigger

Any commit (or branch's cumulative diff) that:

- Renames a directory referenced by a trigger-map entry, **or**
- Moves files between top-level directories under a tracked surface, **or**
- Introduces a new top-level directory in the consuming repo, **or**
- Adds files matching the Intent of an existing trigger-map entry but not its declared Triggers (e.g., a new `*.migrations.sql` outside the declared migration paths).

### Check

1. Open the consuming repo's `AGENTS.md` "Mandatory pre-edit reads" section. Enumerate every trigger-map entry.

2. For each entry, evaluate the Triggers against the post-diff repository state, by trigger type:
   - **Path globs** — expand against the filesystem; record whether the glob resolves at least one file or directory entry.
   - **Content patterns** — scan the post-diff tree for files matching the pattern.
   - **Metadata tags** — scan file frontmatter (or whatever metadata surface the consumer uses) for matching tags.

3. For each trigger with zero current matches, flag for classification — do **not** auto-classify as drift. Zero matches indicates one of three states, and only the first and third are actionable:
   - **Drift.** The original surface moved or was renamed; the trigger needs updating to point at the new location.
   - **Pre-positioning.** The trigger guards a future surface that does not yet exist — a deliberate guardrail written ahead of the surface it protects. No action needed; the trigger stays as-is.
   - **Decommissioning.** The surface was removed; the trigger and its rule should be retired.

   The reviewer (human or AI) classifies each zero-match trigger and routes accordingly. The audit's job is to surface the gap, not to assume drift.

4. If the diff renamed or moved any directories named in a path-glob Trigger, explicitly verify the trigger still names the intended surface — even if the glob coincidentally resolves elsewhere post-rename (a same-named subdirectory may have appeared at a different path). This is a separate check from step 2's resolution test because a non-empty glob match is not sufficient evidence the Intent is still being honored.

5. For each entry, walk the codebase for surfaces that match the entry's Intent but are not matched by any of its Triggers. Concretely: read the Intent line, identify the kind of surface it describes (e.g., "files that change database schema"), and look for instances of that surface the Triggers do not cover. Flag uncovered intent surfaces.

6. For any drift identified in steps 3-5 (Drift or Decommissioning classifications, post-rename mis-resolutions, uncovered intent surfaces), propose corrected Triggers. Update the `AGENTS.md` entry in the same diff if practical; otherwise file a follow-up.

### Example (illustrative)

A consuming repo declares:

```
### database-migrations

Intent: changes to database schema (DDL, migrations, RLS policies) require migration-safety review.
Triggers:
  - supabase/migrations/**
  - **/schema.sql
Read: docs/agents/local/reference/migration-safety.md
```

A diff renames `supabase/migrations/` to `db/migrations/` (the team is moving to a different backend toolchain) and introduces `db/migrations/001_users.sql`. The audit fires on two counts:

- The `supabase/migrations/**` trigger no longer matches anything (dead trigger).
- The new `db/migrations/001_users.sql` matches the Intent but is not covered by any Trigger (uncovered intent surface).

The audit's correction proposes updating the Triggers to `db/migrations/**, **/schema.sql` and lands the fix alongside the rename. Without the audit, the rule would silently stop firing on future migration changes — and the next migration with a backfill problem would slip past the safety net the rule was designed to provide.

For consumers without the rename event, the audit also catches the inverse: a new top-level folder appears that satisfies an Intent but the trigger map hasn't been updated to include it.

## Universality check

Applies to every consuming repo with a trigger map. The drift mode is structural: any codebase that evolves will face restructures (directory renames, content-shape changes, tagging-convention drift), and any rule system that proxies intent through deterministic triggers — most acutely with path globs — faces silent degradation when those restructures are not reflected in the trigger map.

For an alternative consumer (Go monorepo, no Supabase): the same audit applies. Their trigger map might pair Intent: "changes to authentication logic" with Triggers: `services/auth/**, pkg/shared/auth/**`. When the auth service is split into `services/auth-public/` and `services/auth-internal/`, the audit fires on the same dead-trigger + uncovered-intent-surface pattern.

For a consumer using content-pattern triggers rather than path globs (e.g., "Triggers: any file containing `CREATE POLICY`"), the audit still applies — the inverse direction. The Intent might say "RLS policies need security review," but if a new policy is introduced via a stored-procedure body that doesn't contain `CREATE POLICY` as a literal, the content-pattern trigger misses it. The Intent walk-through catches the gap.

## What this proposes to retire or merge

Adds rule mass without retiring an existing audit, justified by:

- The companion rule-change proposal (`intent-statement-required-for-path-triggers.md`) introduces the Intent line this audit checks against; the two are co-dependent and should land together.
- The risk this audit covers (silent rule-trigger degradation) is high-blast-radius and not covered by any existing audit or rule.

Per `library/meta/rule-additions.md`, the alternative — letting drift accumulate until a missed read causes an incident — is the failure mode this audit exists to prevent. No existing audit was found that could be retired or merged into this one.

## Cross-references

- `library/core/pre-edit-gate.md` "Mandatory pre-edit reads" — the rule whose drift this audit detects. Companion proposal `intent-statement-required-for-path-triggers.md` adds the Intent line this audit reads.
- `library/self-review/mechanism.md` — the catalog format and lifecycle this audit follows.
- `library/doc-currency/currency.md` — adjacent rule on doc drift in the codebase; this audit covers the analogous concern for the rule system itself.
