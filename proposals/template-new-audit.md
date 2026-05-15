# Proposal: New Audit — `<audit-name>`

**Type:** 2 (new audit).
**Status:** Draft / Under review / Accepted / Rejected.
**Proposing consumer:** `<repo-name>`.
**Date filed:** `<YYYY-MM-DD>`.

## Firing context

<!--
  What concretely happened in the session that surfaced the gap.
  Link / SHA / diff snippet is fine; coordination identifiers are
  acceptable in proposal docs because they are transient.
-->

## Why existing rules didn't prevent it

<!--
  Walk through what the existing rule set said, and where the gap
  was. If a near-miss rule exists, name it and explain why it
  didn't fire.
-->

## Candidate audit body

### Trigger

<!--
  One-sentence diff pattern. Short triggers beat elaborate ones.
  A trigger like "any migration touches GRANT EXECUTE" is
  actionable; "think about authorization" is not.
-->

### Check

<!--
  Concrete walk-through. Enumerated steps, not prose. What does
  the reviewer-or-agent actually do against the diff?
-->

### Example (illustrative)

<!--
  One concrete instance the audit would have caught. The
  proposing repo's incident is fine; the audit body must be
  generic enough that other repos can replace this example.
-->

## Universality check

<!--
  Does this audit apply to other consuming repos, not just the
  proposing one? Walk through at least one hypothetical
  alternative consumer (different stack, different domain) and
  explain how the audit applies there too.

  If the audit is specific to one repo, the proposal targets
  that repo's local catalog, not the shared library. Close
  this proposal and file the audit locally.
-->

## What this proposes to retire or merge

<!--
  Per library/meta/rule-additions.md, name a rule (or sibling
  audit) the new audit retires or merges into, OR state why no
  existing rule could be retired.
-->

## Cross-references

<!--
  Link any related modules in library/ that the new audit
  touches or extends.
-->
