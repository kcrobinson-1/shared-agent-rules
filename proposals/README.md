# Proposals

How to propose a new shared audit or a change to existing
shared rules. Three output types come out of self-review; two
of them become proposals against this repo.

## The three output types

**Type 1: fix the work.** Local to the firing session. No
escalation; the agent fixes the issue and continues. No
proposal artifact.

**Type 2: propose a new audit.** When the firing pattern is
one the catalog should have caught.

- If the audit's trigger is universal (applies to any
  consuming repo), the proposal targets the shared catalog
  (this repo's
  [`library/self-review/seed-audits/`](../library/self-review/seed-audits/)).
- If the audit's trigger is project-specific, the proposal is
  handled locally in the consuming repo and not filed here.

**Type 3: propose a rule change.** When existing rules should
have prevented the finding but didn't. Always targets the
shared library here.

## Filing channels

### PR with label (primary)

Open a PR against `shared-agent-rules` that adds a file under
`proposals/` following the appropriate template:

- [`template-new-audit.md`](template-new-audit.md) for type-2
  proposals (new audit).
- [`template-rule-change.md`](template-rule-change.md) for
  type-3 proposals (rule change).

Apply the label `proposal:audit` for type-2 or
`proposal:rule-change` for type-3.

See "Lifecycle and disposition" below for what happens after a
decision (accepted proposals land in `library/` and the proposal
file moves to `proposals/decisions/` as the design record;
abandoned proposals are removed via `git rm` and live on in git
history).

### Issue (optional, lightweight)

A consumer can file a GitHub issue with label
`proposal:audit` or `proposal:rule-change` as a lightweight
early-stage proposal. The issue is informal — if the proposal
proceeds, the maintainer or the proposer follows up with a PR
that lands the content.

## What every proposal includes

Both templates require:

1. **Firing context.** What concretely happened in the
   session that surfaced the gap. A link, a SHA, or a diff
   snippet is fine — this is not a durable doc, so coordination
   identifiers are acceptable.
2. **Why existing rules didn't prevent it.** Walk through
   what the existing rule set said, and where the gap was.
3. **Candidate rule text** (for rule-change proposals) **or
   candidate audit body** (Trigger / Check / Example) for new
   audits.
4. **Universality check.** A paragraph confirming the
   rule/audit applies beyond the proposing repo. For audits,
   this is the test that decides shared vs local catalog.
5. **What this proposes to retire or merge.** Mirrors
   [`../library/meta/rule-additions.md`](../library/meta/rule-additions.md)
   — applies to the shared library too. Adding a rule means
   either naming a rule it retires or stating why nothing
   could be.

## Decision authority

The maintainer of `shared-agent-rules` accepts or rejects via
PR merge or close. Multiple consumers seeing the same gap is
signal but not a vote: the maintainer weighs universality and
the rule-system effect (adding a rule is also adding rule-
system mass — see
[`../library/meta/rule-additions.md`](../library/meta/rule-additions.md)).

This is intentionally not over-engineered. The receiving
surface is the PR + label channel; the deciding mechanism is
the maintainer. If the shared repo grows to 4+ active
consumers and the proposal volume warrants it, the channel
may need a triage cadence or a stronger acceptance contract.

## Lifecycle and disposition

A proposal is in one of three states; the state determines where
the file lives.

**Active (under review).** Lives at the root of `proposals/`,
alongside the README and templates. The root is a working set —
scanning it tells you what is currently in flight.

**Accepted.** Content lands in `library/` (a rule body for type-3
proposals, a seed-audit file for type-2). The proposal file moves
to `proposals/decisions/`, its `Status:` updates to
`Accepted <YYYY-MM-DD>`, and `CHANGELOG.md` records the
consumer-visible impact. Accepted proposals are preserved
indefinitely under `decisions/` as the design record: the rule
body in `library/` says *what* the rule is; the accepted proposal
says *why* it was shaped that way (firing context, the gap in
existing rules, the universality argument).

**Abandoned.** The proposal file is deleted via `git rm`. The
closing commit's message captures the rejection rationale.
Recovering rejected content is via `git log --diff-filter=D
--name-only -- proposals/` plus `git show <commit>:<path>`. The
asymmetry — accepted preserved in-tree, abandoned in git history
— is deliberate: accepted proposals carry long-term design
weight, abandoned ones usually do not, and the archaeological
cost on the rare "did we consider this?" question is acceptable.

### Maintainer checklists

**To accept a proposal:**

1. Apply the candidate rule text (or audit body) to the
   appropriate `library/` file.
2. `git mv proposals/<slug>.md proposals/decisions/<slug>.md`
   (create the `decisions/` directory if it does not exist yet).
3. Update the moved file's `Status:` to `Accepted <YYYY-MM-DD>`.
4. Update `CHANGELOG.md`.
5. Commit.

**To abandon a proposal:**

1. `git rm proposals/<slug>.md`.
2. Commit with a message capturing the rejection rationale.

## Cross-references

- [`../library/self-review/mechanism.md`](../library/self-review/mechanism.md)
  for the catalog format and lifecycle.
- [`../library/meta/rule-additions.md`](../library/meta/rule-additions.md)
  for the deep meta-rule the "what this retires" field
  enforces.
