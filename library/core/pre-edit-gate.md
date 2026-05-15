# Pre-Edit Gate

The discipline an agent runs before the first edit of any non-trivial
change. Each item below is a binding precondition, not a checklist
suggestion: if a precondition fails, stop and report instead of editing
files.

## Mandatory pre-edit reads

Some files in a consuming repo are designated as **mandatory pre-edit
reads**: topic-organized constraint sets that must be read end-to-end
before the first edit when the diff surface intersects a named set of
paths.

The pattern is:

> `<repo>/docs/agents/local/reference/<topic>.md` is a mandatory
> pre-edit read for any session whose diff surface intersects
> `<paths>`. Read end-to-end before the first edit. It is not an
> optional lookup.

The consuming repo's `AGENTS.md` declares the binding list under its
"Mandatory pre-edit reads" section. The list lives there, not here, so
the path-to-topic mapping is single-source-of-truth in the consuming
repo. When in doubt about whether a topic applies, treat any
intersection of the diff surface with a named path as triggering the
read.

## Worktree and branch hygiene

Before the first edit:

- Make sure the worktree does not contain unrelated uncommitted
  changes; if it does, stop and ask how to proceed. Carrying unrelated
  changes into a focused diff is how unrelated work gets bundled into
  one PR.
- Make sure you are not doing substantial implementation work on the
  default/trunk branch. Create or switch to an appropriately named
  feature branch first.

## Read before deciding target shape

Read the relevant docs, tests, and neighboring implementation before
deciding the target shape. The agent who decides shape before reading
is guessing; the agent who reads first is grounded.

## Confirm positive value

Confirm the requested change is expected to be positive value for the
codebase: it should reduce real risk, duplication, confusion,
operational friction, or product/user pain enough to justify its diff
and review cost. Stop and report instead of editing if the change
appears needless, mostly cosmetic, or likely to introduce more noise
than value after reviewing the current code and docs.

## Run baseline validation

Run the task's specified baseline validation commands before editing
when the prompt or checklist names them. If a required baseline
validation fails before edits, stop and report the failure instead of
changing files — the failure is a baseline failure, not a failed
implementation, and conflating the two is a recurring debugging
trap.

If no baseline command is specified, identify the smallest relevant
validation surface before editing and run it when practical.

## Trust-boundary check for new persistent writes

For any change that adds or modifies a write to the persistent store
that is reachable from a public or origin-gated surface, answer
before writing code: what prevents a caller from writing arbitrary
or nonexistent data?

Prefer enforcement as close to the persistent store as possible —
database-level referential integrity and constraints over
application-layer validation. The persistence layer is the
authoritative enforcement point and cannot be bypassed by a future
code path. If no enforcement exists yet, add it in the same change.

## Capture uncertainty rather than inventing answers

When the codebase or its documentation leaves a decision unresolved,
record the uncertainty in the consuming repo's designated
open-questions surface instead of inventing an answer to move past
the ambiguity. Inventing answers buries decisions that should have
been raised; recording them keeps the question visible until someone
with authority resolves it.

This applies during the read-before-deciding step above and during
implementation: if the right shape can't be inferred from the
existing repo, stop and capture the question, then either route to a
human or proceed under an explicitly-flagged assumption.

The open-questions surface is per-repo; the starter template's
"Repo orientation" section names it. Common names are
`docs/open-questions.md`, `OPEN-QUESTIONS.md`, or a dedicated section
within an architecture doc.

## Cross-references

- [`../validation/philosophy.md`](../validation/philosophy.md) for
  what "baseline validation" means and how validation honesty applies
  before the first edit.
- [`../workflows/implementation.md`](../workflows/implementation.md)
  for what comes after the gate passes.
- The consuming repo's `AGENTS.md` "Mandatory pre-edit reads" section
  for the binding path-to-topic list.

---

_Audit IDs: R-03, R-04, R-05, R-06, R-07, R-08, R-09._
