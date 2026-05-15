# Doc Ownership Table

**Recommended-but-optional convention.** A repo that maintains
a table mapping each canonical durable doc to its owner and
its update triggers can apply the trigger-driven form of the
doc-currency rule in
[`../doc-currency/currency.md`](../doc-currency/currency.md).
Repos that skip the convention apply the general
"keep docs synchronized" principle without per-doc
trigger granularity.

## The convention

A Doc Ownership Table lives in the consuming repo (commonly at
the top of the contributor-workflow doc or its own
`docs/doc-ownership.md` file). Each row names:

- **Doc.** The canonical path to the durable doc.
- **Canonical owner.** Who or what is responsible for keeping
  this doc current — a team, an individual, or a documented
  role (e.g., "the implementer landing a change in the area
  this doc describes").
- **Update triggers.** The list of changes that trigger an
  update to this doc, in concrete terms.

Optionally a fourth column:

- **Lifecycle moment ownership shifts** — if the doc changes
  ownership at different stages (e.g., the design owner during
  draft, the implementer during rollout, the operator after
  release), name the transitions.

## Example (illustrative)

| Doc | Canonical owner | Update triggers |
|---|---|---|
| `README.md` | The implementer landing a setup-affecting change | New setup step; new build prerequisite; renamed top-level command; deployment target change |
| `docs/architecture.md` | The architect role (or implementer if no architect role) | New runtime flow; new trust boundary; new persistence-layer module; ownership boundary moved between modules |
| `docs/dev.md` | Contributor-workflow maintainer | New validation command; new tooling dependency; changed deployment flow; new contributor environment setup |

Three rows is enough to show the shape. A real Doc Ownership
Table grows to cover each canonical durable doc in the repo;
the column structure stays the same.

## How the convention plugs into doc-currency

When the convention is adopted, the doc-currency rule's
"per-named-doc update triggers" section gets its triggers
from the table directly: walking the doc-currency gate at PR
time becomes walking the table's trigger column. When the
convention is not adopted, the gate falls back to the general
"if you touched a durable doc and the diff makes its content
stale, update it" framing.

## Why this is optional

Smaller repos with few durable docs may not need the formal
table — a paragraph in the README naming the canonical docs
and "update them when you touch their area" is enough. The
table earns its keep when:

- The repo has more than ~5 canonical durable docs.
- Doc currency has been a recurring review-feedback class.
- The team has explicit role separation (architect, ops,
  implementer) and wants ownership of each doc to be clear.

## What this rule does not say

This rule does not require adoption. Consumers who don't carry
a Doc Ownership Table still get the general doc-currency rule;
they just don't get the trigger-driven specialization.

## Cross-references

- [`../doc-currency/currency.md`](../doc-currency/currency.md)
  — the rule that depends on this convention for its
  trigger-driven form.
- [`../doc-currency/ephemeral-identifiers.md`](../doc-currency/ephemeral-identifiers.md)
  — a related doc-currency discipline.

---

_Audit IDs: convention that supports R-121._
