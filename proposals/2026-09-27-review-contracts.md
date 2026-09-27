# Proposal: Rule Change — review the affected contract

**Type:** 3 (rule change).
**Status:** Draft — prepared for maintainer review.
**Proposing consumer:** music-manager-app.
**Date filed:** 2026-09-27.

## Target

Revise [self-review correctness](../library/self-review/how-to-use.md#correctness)
and consolidate [review-fix diagnosis and validation](../library/workflows/review-fixes.md).
This is a workflow integration, not a rewrite of the rule system.

## Firing context

The account foundation [PR](https://github.com/kcrobinson-1/music-curator-app/pull/10)
allowed identity removal to release a provider reservation while the account
still ended the transaction deleting, even after cleanup obligations completed.
The first correction rejected that violation, but also rejected a valid active
unlink or identity replacement followed by deletion acceptance in one transaction.
A later email comment concerned an original defect: address or verification
changes during deletion entry released the old reservation. Version comparison
established that this bug was unchanged by the first correction.

The broader audit found original gaps in deletion entry, ledger/account terminal
consistency, caller-controlled completion time and partial expired history purge.
The incident record is `docs/session-log/2026-09-27-account-foundation.md`,
“PR churn audit”, in the account-foundation worktree. Its test/probe results are
historical evidence, not checks rerun by this rules session. Later PR comments
must each be diagnosed from their own evidence.

## Why existing rules didn't prevent it

General self-review already required regressions, complete call-site coverage
and persistence enforcement. Review-fixes already required equal rigor, sibling
sweeps and a new-bug check. Those rules should have caught these failures.
The incident log records review of named operations and the reported failure
without enough combined-field or transaction-composition coverage. It does not
establish the first automated reviewer's internal reasoning; that cause is unknown.

The consumer additionally omitted review-fixes from its manifest and router
because “there are no PRs”. PRs now exist, and its contributor workflow owns a
PR handoff. Local overlays repeat the stale exclusion. This routing gap weakens
access to the existing workflow; it does not excuse failure to apply self-review.

## Candidate rule text

The candidate bodies live in the linked target modules on this branch, so the
shared modules remain the owners of the instructions. The central delta is:

> Review the affected behavior or invariant, including relevant unchanged
> callers, writers, consumers and enforcement paths. Bound the review by the
> shared contract or dependency; a broader read does not authorize unrelated
> implementation changes.

The review-fix workflow applies that same review unit through diagnosis,
contract sweep, validation and recorded evidence before committing or reporting
a comment addressed. It distinguishes an original miss from a correction
regression, tests legitimate counterexamples and keeps unknown causes unknown.
External replies remain conditional on authorization; resolving threads or
submitting reviews still requires the explicit write request.

## Universality check

The same reasoning applies to a different consumer with an inventory reservation
contract: checkout and a background allocation worker both reserve stock.
Ordinary reservations must not make available stock negative; explicitly
permitted backorders are an exception. A checkout-only correction cannot
establish that contract if the unchanged worker shares the write path. A repair
must preserve permitted backorders, and concurrent competing reservations
need a race check when that is the failure path. A typography change shares none
of this contract and does not call for an inventory audit.

This principle applies to lifecycle, authorization, persistence and other shared
contracts without requiring a repository-wide sweep, exhaustive matrix or an
extra reviewer for every patch. Tests and scope follow the affected behavior.

## What this proposes to retire or merge

Revise the existing Correctness introduction and call-site coverage guidance
in place. Merge “Audit for siblings of the same class” and “New-bug check before
committing”, together with the overlapping Review-Fix Rigor validation bullets,
into one diagnosis/sweep/validation/evidence sequence. Preserve the successful-
write versus failed-follow-up example inside that sequence.

No new seed audit, memory reminder or incident-specific permanent rule is added.
The [catalog lifecycle](../library/self-review/mechanism.md#lifecycle) remains
unchanged: recurrence/severity govern additions and automation/nonrecurrence
govern retirement. Logs own incident history; tests own mechanical regressions.
The consumer adopts an existing workflow and removes the obsolete exclusions.

## Execution plan and review boundary

Use a managed rules worktree and a separate consumer worktree; preserve the
primary checkouts and do not edit or commit the account-foundation worktree.
The managed tool only targets this chat's rules repository, so the consumer
worktree is created with Git in `/private/tmp/agent-review-routing-music-manager`.

Intended commits: (1) proposal and compact upstream module revisions with an
Unreleased changelog entry; (2) consumer routing/overlay reconciliation and
assembly from the existing released pin, with its session log. Validate each
slice, then the combined handoff. Maintainer merge accepts the proposal; move it
to `proposals/decisions/` and mark Accepted during that landing. Cut the CalVer
tag on main per VERSIONING, then bump and assemble the consumer at that real tag.
Do not label unreleased output as a released version.

## Validation and handoff

Baseline: `scripts/check-vendored-links.sh` passed with all 150 relative links
resolving. The isolated consumer's `python3 scripts/check-docs.py` passed.
Final checks: `git diff --check` passed; `scripts/check-vendored-links.sh`
passed with all 152 relative links resolving. The checker exercises a literal
starter copy and assembly from the current working library. The retained
illustrative sibling footnote keeps the footnote-pattern module's reference
current. No script or starter edits were needed.

A separate read-only review compared the delta to the agreed recommendations.
It identified an unconditional inventory invariant conflicting with a valid
backorder exception, and wording that assumed every change corrected a defect.
Both were narrowed. The final rule review is qualitative, not a measured model
evaluation; no claim of improved model detection or account-code revalidation
is made.

### Scenario walkthrough of the candidate text

| Scenario | Expected application | Inspection result |
|---|---|---|
| Account reservation removed while account still ends deleting | Diagnose the reservation invariant and sweep direct SQL, helpers and terminal enforcement | Review-fix steps require the failure, shared writers and evidence beyond a passing gate |
| Valid active partial unlink or replacement, then deletion acceptance in one transaction | Preserve the legitimate composition while fixing deleting-time removal | Counterexample validation and lifecycle composition explicitly apply; sole unlink leaving an empty account is a separate violation |
| Account-related typography only | Review copy and drift within scope | No lifecycle, authorization or persistence behavior changed; no lifecycle sweep is required |
| Inventory checkout rejects overselling but unchanged allocation worker can oversell | Sweep writers sharing ordinary reservation constraints | Contract review includes the unchanged consumer; competing reservations warrant a concurrency check |
| Explicitly permitted inventory backorder | Preserve the contract's valid exception | Legitimate-counterexample validation prevents an unconditional negative-stock ban |
| Inventory consumer changes a heading's font | Keep the review proportional to presentation | The stock contract is unaffected; unrelated inventory implementation changes are not authorized |

These are reasoned walkthroughs of the instructions against incident and
synthetic examples, not executions of the account or inventory code. The
observable categories remain distinct: original transition/composed-field
miss, correction regression and shared-writer coverage gap. Unknown reviewer
reasoning stays unknown.

General self-review covered scope, correctness, downstream routing, doc currency,
validation honesty and audit lifecycle. The audit mechanism and seed catalog
are unchanged. No pre-edit trigger map changed and no new readiness mechanism
was introduced.

### Consumer handoff and release order

The consumer branch `codex/agent-review-routing` adopts the existing released
review-fixes module at `2026-05-15`, adds a router row and reconciles PR-denying
overlays. PR descriptions remain owned by the consumer's existing template;
its PR-body schema opt-out now explains that owner rather than claiming no PRs.
A posting-authorization compatibility overlay protects the old shared workflow
until the revision ships, then is retired. The consumer session log is
`docs/session-log/2026-09-27-agent-review-rules.md`.

An isolated fixture assembled the candidate library for the consumer under
`review-contracts-fixture`: all 29 modules had matching fixture headers and
source ownership, the new guidance survived assembly, and removal of the
posting overlay left the revised upstream authorization condition intact.
Fixture output is disposable validation evidence, not committed released output.

Concrete remaining dependency: maintainer review/merge, proposal disposition and
CalVer tag on upstream main; then deliberate consumer pin bump, compatibility
overlay retirement and assembly at that actual tag. Review the entire release
diff and remaining overlays, because main can include other changes since the
consumer's old pin. No main merge, public release or account-PR write was made
by this session. Primary untracked `.claude/`, consumer modifications and the
account implementation checkout remain intact.

## Sources

[Custom Code Review rules](https://developers.openai.com/blog/custom-code-review-rules-for-codex)
informed the scoped invariant and violating/safe/unrelated example walkthrough.
[Rethinking skills and prompts](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra)
informed contextual routing and keeping the instruction surface compact.
These are design inputs, not evidence that this revision improves model outcomes.

## Cross-references

- [Rule-addition trade-off](../library/meta/rule-additions.md).
- [Scope boundaries](../library/core/scope-and-stop.md).
- [Validation honesty](../library/validation/philosophy.md).
- [Release and pin workflow](../VERSIONING.md).

### Local publication state

The validated revision and proposal are committed on the local feature branch.
Automatic approval review rejected its GitHub push because the payload includes
incident/project detail without explicit authorization for that destination.
No branch was pushed and no PR was created. The prepared PR body is
`/private/tmp/agent-review-upstream-pr.md`; the paired consumer PR body is
`/private/tmp/agent-review-consumer-pr.md`. Publication needs the user's explicit
approval of those payloads and repositories. This is an external handoff gate,
not an incomplete implementation or a failed validation check.
