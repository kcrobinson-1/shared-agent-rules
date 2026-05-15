# Versioning

`shared-agent-rules` uses **calendar-versioned tags** of the form
`YYYY-MM-DD`. The version is the day the maintainer cut the tag
on `main`.

## Why CalVer

Rule libraries don't have an API in the SemVer sense: there's no
runtime contract that "breaks" when prose changes. What
consumers actually care about is "when did this rule set last
change" and "what changed since the version I'm pinned to."
Date-shaped tags answer both questions directly without making
the maintainer pretend the rule surface has a version-number
philosophy.

## How to pin

The consuming repo's manifest names a specific date tag:

```yaml
shared_agent_rules:
  source: github.com/<org>/shared-agent-rules
  version: 2026-05-15
```

Pinning is exact — no version ranges, no "latest." Bumps are a
deliberate manifest edit followed by a re-run of
`scripts/assemble.sh`. Never automatic.

## How to bump

1. Read [`CHANGELOG.md`](CHANGELOG.md) from the consumer's
   pinned version to `HEAD`.
2. Update the manifest's `version:` field to the chosen new
   tag.
3. Run `scripts/assemble.sh`.
4. Read the diff under `docs/agents/shared/` to see what
   actually changed in this repo, and review whether the local
   overlays still make sense on top of the new content.

## Same-day changes

Changes that land on the same calendar day stay under that day's
tag — no per-change bump, no SemVer-style minor/patch reasoning
on top of the date. The tag and the day are the same artifact.

If a second release truly needs to ship on the same calendar day
(rare; usually only an urgent fix wedged between two larger
releases), use a patch suffix: `2026-05-15.1`, `2026-05-15.2`.
The suffix is the only escape hatch; date components themselves
never bump for non-date reasons.

## Single library version

For v0.0 the library ships **one version per release** — all
modules at the same tag. Per-module versioning is not supported.
Consumers manage drift via the manifest's `modules:` opt-out
list, not via per-module pins.

If the library grows enough that seed audits churn faster than
the rest of the library and consumers want to opt out of newer
audit revisions while taking newer rule revisions, the design
will be revisited.

## What changes warrant a new tag

- Any change to a rule body in `library/`.
- Any structural change to the library (new module, removed
  module, renamed module).
- Any change to `starter/` files consumers copy on adoption.
- Any change to `scripts/assemble.sh`.

Tag-worthy changes also get an entry in
[`CHANGELOG.md`](CHANGELOG.md). Pure formatting fixes
(whitespace, typos in proposals/ templates) can land without a
new tag if the maintainer judges the change non-substantive.
