# Review-Fix Workflow

Per-session-type playbook for addressing PR review feedback. Layer
this on top of the implementation workflow for code-side fixes.

## Review-Fix Rigor

Review-fix commits do not get a lighter diligence standard than
the original implementation. Apply the same design, validation and
self-review depth for the affected surface. Before committing a fix
or reporting a comment addressed, complete the following steps.

## Diagnose, sweep the contract and validate

1. **Diagnose the violation and origin.** Name the violated contract.
   Use reproductions and version history where available to distinguish
   an original defect from a regression introduced by a correction.
   Describe the observable miss: an alternate path, combined field
   change, transaction composition, incorrect assumption, coverage gap
   or correction regression. State unknown causes as unknown; do not
   invent explanations for a reviewer or model's internal reasoning.
2. **Sweep paths sharing the contract.** Apply the
   [self-review correctness guidance](../self-review/how-to-use.md#correctness)
   to other paths sharing that contract, including relevant unchanged
   code. Look for related defects and regressions caused by the
   correction. Keep implementation changes within the authorized scope;
   report findings outside it through the repo's follow-up surface.[^siblings-example]
3. **Validate the failure and legitimate counterexamples.** Verify the
   reported violation and successful operations the correction could
   break. Use focused tests, probes or code-level proof appropriate to
   the contract, adding composition, failure/retry or concurrency checks
   when relevant. For a new async step, follow-up read, fallback or
   external dependency, check transient failure and partial success.
   A successful write must not appear failed because a best-effort
   follow-up read or reconciliation failed, unless the contract makes
   the operation atomic. Do not accept a correction that introduces a
   higher-severity bug than the reported issue.
4. **Record the evidence and its limits.** Name the invariant, paths
   checked, tests/probes or code-level proof, related findings, what
   existing verification missed and material remaining gaps. Distinguish
   known evidence from uncertainty; a passing gate alone does not
   establish complete contract coverage. Keep incident history in the
   session log and mechanical regression protection in tests. New audits
   still follow the existing [catalog lifecycle](../self-review/mechanism.md#lifecycle).

[^siblings-example]: Illustrative: a reviewer found a plan paragraph treating
    tool output as proof without checking what it proved. Another paragraph
    made the same mistake; a sweep of that verification contract would have
    found it before a second review round. Consumers can replace this example.

## Review-thread state discipline

When addressing review feedback, keep the review surface readable
for humans.

- When the user has authorized posting, reply after pushing on the
  exact review thread with the cause, correction, broader checks,
  evidence and commit reference, plus any material uncertainty.
  Reporting the comment addressed follows the quality work above.
- For pushback or deferral, an authorized reply gives the rationale;
  otherwise keep the decision in the local handoff.
- Do not resolve threads, submit a review, or mark conversations
  resolved unless the user explicitly asks for that write
  action.
- When summarizing review state to the user, distinguish clearly
  between live review-surface threads and pasted review text
  supplied in chat.

The "review surface" is whatever surface the review is happening
on — GitHub PR threads, GitLab merge-request notes, Gerrit
comment threads, an internal review tool. The discipline is the
same wherever review threads carry state.[^review-surface]

[^review-surface]: The source rules were written against
    GitHub-flavored review surfaces; the discipline transfers to
    any review surface that distinguishes a thread (a
    conversation pinned to a line or section) from a review
    submission (a top-level approval/changes-requested action).

## Cross-references

- [`../self-review/how-to-use.md`](../self-review/how-to-use.md)
  for the self-review the original implementation should have
  run; review fixes apply the same audits through the contract sweep
  above.
- [`debugging.md`](debugging.md) when the review feedback is
  about a failing check rather than a code defect.

---

_Audit IDs: R-68, R-69, R-70, R-71._
