# Proposal: Rule Change — `library/core/pre-edit-gate.md` (Mandatory pre-edit reads)

**Type:** 3 (rule change).
**Status:** Accepted 2026-05-15 (content landed in `library/`; see CHANGELOG).
**Proposing consumer:** `shared-agent-rules` itself — self-review of v0.0 by the maintainer.
**Date filed:** 2026-05-15.

## Target

`library/core/pre-edit-gate.md`, the full "Mandatory pre-edit reads" section. The current section spans the intro paragraph, the "pattern is" block, and the closing single-source-of-truth paragraph; this proposal replaces all three with new prose that defines mandatory pre-edit reads, names their structure (Intent / Triggers / Read), and locates the binding list — coherent in a single replacement rather than three overlapping edits.

## Firing context

External review of v0.0 surfaced this risk:

> Path-triggered rules are under-specified by default. The mandatory pre-edit system is good, but the starter leaves the real trigger map as a placeholder. If a repo owner does not carefully fill that in, agents will miss architecture, security, styling, database, or deployment constraints.

A follow-up observation named the deeper version of the issue: path triggers are a **proxy for intent** (e.g., `supabase/migrations/**` is shorthand for "files that change database schema"). When the codebase drifts — folder renames, new sibling directories, restructures — the proxy stops matching the intent, and the safety property of the rule silently degrades. The rule body alone (a path glob) carries no record of what the rule was protecting; once the paths go stale, the protection is gone without a trace.

This is a rule-system review, not a consuming-repo session — the proposal is filed against v0.0 before any consumer is integrated.

## Why existing rules didn't prevent it

The current pattern in `library/core/pre-edit-gate.md` describes path-triggered reads as:

> `<repo>/docs/agents/local/reference/<topic>.md` is a mandatory pre-edit read for any session whose diff surface intersects `<paths>`. Read end-to-end before the first edit. It is not an optional lookup.

This conflates two things: the **trigger** (a deterministic mechanism for firing the rule) and the **intent** (what the rule is protecting). Both bind to the same prose, so when the trigger drifts the intent disappears with it. There is no carryover artifact that lets a future agent — or a drift-detection audit — recover the original purpose.

The pattern also implicitly fixes the trigger style as a path glob. Some intents are better proxied by file *content* ("any file containing `CREATE POLICY`") or by file *metadata* ("any file with `@stability: contract` in frontmatter") — those are more robust against directory restructures because they trigger on what the file *is*, not where it *lives*. The current rule body doesn't acknowledge alternative trigger styles, so path globs become the default by omission.

## Candidate rule text

Replace the full "Mandatory pre-edit reads" section (current intro paragraph + "pattern is" block + single-source-of-truth paragraph) with:

> Some files in a consuming repo are designated as **mandatory pre-edit reads**: topic-organized constraint sets that must be read end-to-end before the first edit when the diff intersects a named trigger. The trigger may be a path glob, a content pattern, or a file-metadata tag — whichever proxies the underlying intent most robustly against codebase drift.
>
> Every mandatory pre-edit read entry in the consuming repo's `AGENTS.md` carries three components:
>
> - **Intent.** One sentence naming what the rule protects against, in surface-independent terms. The intent is what survives when the trigger drifts; it is also what a drift-detection audit (see [`../self-review/seed-audits/trigger-map-currency.md`](../self-review/seed-audits/trigger-map-currency.md)) compares against to find gaps.
> - **Triggers.** One or more deterministic conditions that fire the rule. Path globs are the canonical form; alternatives are acceptable and preferred when the intent maps to file content or metadata more robustly than to a directory location. Examples: a path glob (`supabase/migrations/**`), a content pattern (any file containing `CREATE POLICY`), a frontmatter tag (`@stability: contract`).
> - **Read.** The constraint set the agent must read end-to-end before the first edit on a matching diff.
>
> The canonical written form:
>
> ```
> ### <topic>
>
> Intent: <one sentence naming what is protected>.
> Triggers:
>   - <path glob, content pattern, or metadata tag>
>   - ...
> Read: <repo>/docs/agents/local/reference/<topic>.md
> ```
>
> When the diff matches any trigger, the read is mandatory and not an optional lookup. Drift between an entry's Intent and its Triggers — surfaces that match the intent but escape all triggers, or triggers that no longer match the surface they were written for — is detected by the trigger-map-currency audit (`library/self-review/seed-audits/trigger-map-currency.md`), not by the pre-edit gate itself. The gate stays mechanically deterministic; drift detection runs retroactively at self-review time.
>
> The consuming repo's `AGENTS.md` declares the binding list under its "Mandatory pre-edit reads" section. The list lives there, not here, so the intent-trigger-read mapping is single-source-of-truth in the consuming repo.

This replaces the current ~22-line "Mandatory pre-edit reads" section (intro + pattern + single-source paragraphs) with ~30 lines of new prose. The net rule-mass increase is ~8 lines, justified in "What this proposes to retire" below.

## Universality check

Applies to every consuming repo. The drift problem is structural — any codebase that evolves over time will have its directory structure shift, and any rule system that proxies intent via paths alone faces the same silent degradation.

For a hypothetical alternative consumer (Go monorepo with `services/auth/`, `services/billing/`, `pkg/shared/`, no Supabase or Vercel): the same pattern applies. Their path-triggered rules might say "Intent: changes to authentication logic carry session-handling risk; Triggers: services/auth/**, pkg/shared/auth/**; Read: docs/security/auth-threat-model.md." Same shape, different surfaces.

The intent-statement requirement is also robust across trigger styles. A consumer who proxies authorization rules via a frontmatter tag rather than a path glob still benefits from the intent line — drift on metadata schemas is rarer than directory drift but still happens, and the same audit pattern recovers it.

## What this proposes to retire or merge

This is a revision in place: the existing "Mandatory pre-edit reads" section is replaced wholesale by an internally-coherent rewrite. No rule is retired. The change does add net rule mass (~8 lines on a ~22-line section), justified by:

- The Intent component is load-bearing for drift survival (which the original section does not provide) and unblocks the companion seed audit (`trigger-map-currency`).
- The multi-trigger-style acknowledgment (path globs, content patterns, metadata tags) is load-bearing because some intent surfaces are better proxied by file content or metadata than by directory location; the original framing only named paths.

Pairs with the new-audit proposal `trigger-map-currency-audit.md`. The two should land together or neither: the audit relies on the intent statement; the intent statement is most useful when an audit checks against it.

## Cross-references

- `library/core/pre-edit-gate.md` — target of this change.
- `library/self-review/seed-audits/trigger-map-currency.md` — companion seed audit (proposed separately in `trigger-map-currency-audit.md`).
- `library/meta/rule-additions.md` — the deep meta-rule requiring this proposal to name what it retires or merges.
- `starter/AGENTS.md` "Mandatory pre-edit reads" section — needs its example updated to the new three-component form (small follow-up after acceptance).
