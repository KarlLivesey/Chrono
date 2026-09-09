# Documentation workflow

Handwritten guides live in `docs/handbook`. The release reference is generated
from actual Apex declarations, the action catalogue and the checked LWC public
contracts. `docs/site.json` controls release metadata and navigation.

```sh
npm run docs:build
npm run test:docs
python3 -m http.server 4173 --directory .docs-site
```

The build writes only `.docs-site` and `docs/reference`; it does not change Apex,
component source or contract baselines. Marked is a pinned development-only
Markdown renderer with no runtime site dependency. Raw HTML in Markdown is
escaped. Search uses a local static index; no tracking or external search service
is loaded. Fonts use named local typefaces with serif/sans-serif fallbacks.

The build fails for broken local links, missing fragments/assets, changed
reference inventories or an invalid example bundle. The reference generator
requires the global source inventory to match the reviewed baseline. Do not
change the baseline merely to make a documentation build pass.

## Source references and released installation

The generated reference uses the current project version and is labelled as
development source. The install links and site release badge identify the latest
released package separately. Do not label APIs added in development as already
available in that released package.

## Released documentation

Release numbers and install IDs must come from a successful Salesforce version
report. Verify runnable Apex examples against that installed version before
claiming they work. Keep standard package-build authorisation separate: generating
or publishing docs does not authorise a Salesforce build.

The Pages site is published from a separate `gh-pages` branch containing only
built static artifacts. A documentation publish does not require committing the
workspace's unrelated package changes. Build and check first, then copy the
output to a temporary checkout of that branch, review the diff, commit and push.
Never force-push or overwrite an existing Pages branch without comparing it.

The initial publication used GitHub's signed `createCommitOnBranch` API after
the configured 1Password SSH signer failed. Its verified commit is
`73bd675bf35813292c03d8a06e60ec92dfc5a21a`. This leaves local Git signing settings
unchanged. Use the expected current branch SHA to protect against concurrent
updates when publishing through that API.

The full source of the documentation remains in the main workspace for normal
review/commit. This initial publishing approach intentionally does not run an
automatic build from an older committed package snapshot.

## Content rules

- Lead with tasks an admin or developer recognises; use exact labels/API names
  in the reference and copyable examples.
- Keep old beta migration notes out of current setup instructions.
- Separate native/ISO date payloads from action request/result envelopes.
- State defaults, timezone context, half-open boundaries and precision explicitly.
- Describe actual operations, not guessed class names or future API plans.
- Browser rendering and released-upgrade checks are separate from metadata,
  component and Apex tests; do not imply that one proves another.
