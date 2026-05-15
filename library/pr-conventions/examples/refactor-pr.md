# Example: Refactor PR

Illustrative filled-in PR body for a fictional behavior-
preserving refactor. Replace with your own once your repo has
shipped a few PRs that exemplify the schema.

The fictional change: extracting the input-validation helpers
from a 1,200-line `request_handlers.py` into a sibling
`request_validation.py`, while keeping the per-handler entry
points and behavior unchanged.

---

## Summary

- Extract input-validation helpers from `request_handlers.py`
  into new `request_validation.py`.
- Re-export the extracted symbols from `request_handlers.py`
  via `from .request_validation import *` to keep existing
  imports working.
- No behavior change. No public-API change.

## Why This Is Worth Merging

`request_handlers.py` grew past 1,200 lines and now mixes
HTTP-layer dispatch with payload-validation rules. Tests for
the validation rules currently import from `request_handlers`,
which forces the test module to load the full handler stack
for what should be a pure-function check. Splitting the
modules lets validation tests import a smaller surface and
makes future ownership of the validation rules clearer.

## User Behavior

Behavior-preserving; no user-visible change.

## Contract and Scope

No public API changes (re-exports preserve the import path).
No persistent-store changes. No auth/authz changes.

## Target Shape Evidence

Before:

- `request_handlers.py` — 1,247 lines, mixing HTTP dispatch
  and input validation.

After:

- `request_handlers.py` — 612 lines, HTTP dispatch only.
- `request_validation.py` — 489 lines, pure validation
  helpers.

Responsibility split:

- `request_handlers.py` owns: route bindings, per-method
  dispatch, response shaping, error-to-status mapping.
- `request_validation.py` owns: payload schema checks, type
  coercion, defensive input cleaning.

The remaining 146 lines (1,247 − 612 − 489) were shared
docstrings and `__all__` block re-exports.

## Documentation

- `docs/architecture.md` — updated the "Request layer" section
  to name the new module.
- Module-level docstring in `request_validation.py` describes
  what it owns and what it deliberately does not.

## Estimate Deviations

N/A (no plan doc drove this refactor).

## UX Review

N/A (refactor, no UX surface).

## Validation

- [x] `make lint`
- [x] `make test` — full suite passing; no test files
  modified.
- [x] `make test-integration` — request handlers exercised
  end-to-end; behavior unchanged.
- [x] Imports audit: `rg "from .* import.* request_handlers"`
  shows existing import sites still resolve via the re-export
  surface.

## Remaining Risk

None known. The re-export shim keeps existing imports
working; a follow-up cleanup to migrate callers to import
from `request_validation` directly is captured in
`docs/backlog.md` and will land as a separate change.

---

_Example only. Substitute your repo's validation commands and
adjust to your codebase's import conventions._
