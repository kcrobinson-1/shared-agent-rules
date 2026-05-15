# Genesis artifacts

The audit, design, and verification documents from the four-phase
process that produced v0.0 of this repo (2026-05-15). Preserved here
for posterity — these are not living documents.

- `audit-neighborly-rule-inventory.md` — the 152-rule audit of
  `neighborly-scavenger-game`. Each rule is tagged by scope, action,
  and type with flags for friction, duplication, and over-fitting.
  Audit rule IDs (`R-NN`) are referenced from the `_Audit IDs:_`
  footers in `library/` files for traceability.
- `design-repo-design.md` — the design doc that translated the audit
  into the repo structure. Authoritative for the boundary with
  `workstream-tracker/spec/`, the module taxonomy, the consumption
  mechanism, and the proposal channels architecture.
- `verification-report.md` — the independent verification pass over
  the build output. All must-fix issues (cross-reference paths,
  R-03 placement) and the six nice-to-haves were applied before
  this initial commit.

If a rule's history needs to be traced, start with the rule ID in
the relevant `library/` file's footer, then look up the entry in
`audit-neighborly-rule-inventory.md` to find the original neighborly
source.
