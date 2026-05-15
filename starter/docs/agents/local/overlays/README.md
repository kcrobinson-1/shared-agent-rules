# Repo-specific overlays

Placeholder directory for per-module overlays appended to vendored
shared content.

For each shared module vendored at `../shared/<module-path>.md`,
an optional overlay file at `<module-path>.md` here gets appended
to the vendored file below a `## Local additions` delimiter when
`scripts/assemble.sh` runs.

Use overlays for small, repo-specific extensions to a shared rule
that would otherwise live as in-place edits to the shared file —
which is forbidden because shared content is regenerated on every
vendoring pass.

For larger additions (a full new rule, a net-new workflow), prefer
authoring a separate file under `../workflows/` or `../reference/`
rather than overloading an overlay. Overlays are for incremental
clarifications and exceptions, not for net-new rule content.
