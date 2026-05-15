# shared-agent-rules

A vendor-and-consume library of agent/dev rules that new
repositories adopt on day one. Lets a new repo start with a
worked-through set of universal session disciplines, workflow
playbooks, and rule-authoring meta-conventions, instead of growing
each one from scratch.

## What this repo ships

Three layers:

1. **A rule library** ([`library/`](library/)) — one folder per
   topic. Each module ships one or a few small Markdown files.
   See [`library/README.md`](library/README.md) for the module
   map.
2. **A starter `AGENTS.md` template** ([`starter/`](starter/)) —
   the per-repo entry point a new repo copies, plus the
   surrounding `docs/agents/` directory skeleton and an example
   consumption manifest.
3. **Meta-conventions** — rule-authoring rules, the self-review
   catalog mechanism, the proposal-channel surface
   ([`proposals/`](proposals/)), and a small assemble script
   ([`scripts/assemble.sh`](scripts/assemble.sh)) that vendors
   selected modules into a consuming repo.

## Who uses it

Any repo that wants a coherent agent-rule layer without
authoring one from scratch. The starter template assumes the
consuming repo also adopts
[`workstream-tracker/spec/`](https://github.com/<org>/workstream-tracker)
for plan-doc authoring and lifecycle rules — the two repos are
designed to be vendored together.

If your repo doesn't carry a plan-doc system, the
plan-implementing routing row drops out and the rest of the
library still applies.

## Day-one quick start

1. Copy [`starter/AGENTS.md`](starter/AGENTS.md) to the root
   of the consuming repo.
2. Copy [`starter/docs/agents/`](starter/docs/agents/) to
   `docs/agents/` in the consuming repo.
3. Copy [`starter/MANIFEST.example.yaml`](starter/MANIFEST.example.yaml)
   to `docs/agents/shared.manifest.yaml` in the consuming
   repo and pin the version.
4. Run [`scripts/assemble.sh`](scripts/assemble.sh) (vendored
   into the consuming repo, or invoked from a checkout of this
   repo). It reads the manifest, clones the named version of
   the shared library, and writes
   `docs/agents/shared/<module-path>.md` for each module the
   manifest opts into.
5. Fill in the `<!-- REPO-SPECIFIC -->` placeholders in the
   copied `AGENTS.md`: repo orientation, the contributor-
   workflow doc, the mandatory pre-edit reads path list.
6. Add any repo-specific reference constraint sets under
   `docs/agents/local/reference/`.

That's day-one. The local catalog
(`docs/agents/local/self-review-catalog.md`) starts seeded with
the shared audits and grows over time. The local overlay
mechanism lets the repo add to a shared module without
forking it.

## What's vendored vs. what's local

- **Vendored, do not edit:** everything under
  `docs/agents/shared/` in the consuming repo. Edit upstream,
  re-run `assemble.sh`.
- **Local, owned by the consuming repo:** everything under
  `docs/agents/local/` and the root `AGENTS.md` template
  itself. Customize freely; follow
  [`library/meta/rule-additions.md`](library/meta/rule-additions.md)
  when adding rules.

## Changes and proposals

- **Version policy:** [`VERSIONING.md`](VERSIONING.md).
- **What changed when:** [`CHANGELOG.md`](CHANGELOG.md).
- **Propose a change or a new audit:**
  [`proposals/README.md`](proposals/README.md).

## Boundary with workstream-tracker

This repo owns session discipline, workflow playbooks, code-
level conventions, PR shape, and rule-authoring meta.

[`workstream-tracker/spec/`](https://github.com/<org>/workstream-tracker)
owns everything plan-doc-aware: plan-tree taxonomy, the
`In draft` / `Proposed` / `In progress` / `Validating` /
`Landed` / `Deferred` lifecycle, plan promotion gates, the
Plan-to-PR Completion Gate, the Estimate Deviations callout
(referenced from `library/pr-conventions/pr-body-shape.md`),
`Verified by:` annotations, and other workstream-tracker
vocabulary.

Cross-referencing across the boundary is direct, not hedged —
both libraries are assumed to be vendored together.
