# Example: Feature PR

Illustrative filled-in PR body for a fictional change. Replace
with your own once your repo has shipped a few PRs that
exemplify the schema; this file is a worked example, not a
binding template.

The fictional change: adding a `--quiet` flag to a CLI tool
that currently emits one progress line per processed file.

---

## Summary

- Add `--quiet` flag to the `pkgtool process` subcommand.
- When `--quiet` is passed, suppress per-file progress lines;
  errors and the final summary still print.
- Document the flag in the CLI reference and the `--help`
  output.

## Why This Is Worth Merging

Users running `pkgtool process` against large input sets in CI
report log spam crowding out actionable errors. The progress
output is useful interactively but hostile in non-TTY
contexts. Adding the flag lets CI invocations stay quiet
without changing default behavior for interactive users.

## User Behavior

Interactive users: no change. Default output still prints one
progress line per file.

`--quiet` users: per-file progress is suppressed. Errors still
print to stderr; the final summary still prints to stdout.

## Contract and Scope

No public API changes. No persistent-store schema changes. No
auth/authz changes. Adds one CLI flag and its documentation.

## Target Shape Evidence

N/A (feature change, not a refactor).

## Documentation

- `docs/cli-reference.md` — added `--quiet` row to the
  `process` flag table.
- `pkgtool process --help` output — extended (auto-generated
  from the flag declaration, but verified locally).

## Estimate Deviations

N/A (no plan doc drove this change).

## UX Review

N/A (CLI change; output verified by running the command in
both modes, output captured in the Validation section below).

## Validation

- [x] `make lint`
- [x] `make test` — all suites passing including the new
  `test_quiet_flag_suppresses_progress` case.
- [x] Manual: `pkgtool process samples/*.txt` (normal mode,
  progress lines present).
- [x] Manual: `pkgtool process --quiet samples/*.txt` (quiet
  mode, only final summary printed).
- [x] Manual: `pkgtool process --quiet samples/bad.txt`
  (error path; error still printed to stderr).

## Remaining Risk

None known. The flag is additive and gated behind an explicit
opt-in; default behavior is unchanged.

---

_Example only. Substitute your repo's validation commands and
flesh out documentation surfaces specific to your codebase._
