# Documentation site delivery — 8 September 2026

Published **https://karllivesey.github.io/Chrono/** for released **0.1.0.19**.
The repository homepage points to the site. GitHub Pages uses `gh-pages` at `/`
with HTTPS enforced.

## Content and implementation

- 201 content pages, plus search and a 404 page.
- Task-based admin and developer guides, 129 global Apex class references,
  all 27 Flow families / 54 actions and 18 exposed component references.
- Searchable local index, keyboard search shortcut, in-page contents, copyable
  code examples, responsive navigation and system/light/dark themes.
- Downloadable Metadata API bundle with all 13 example Flows, a manifest and two
  optional demo-data seed scripts. Runnable subscriber Apex examples are separate.
- The source reference is generated through the existing declaration reader,
  checked contract inventories, invocable annotations and component metadata.
- Marked 18.0.12 is a pinned development-only Markdown renderer. The static site
  needs no runtime framework, font downloads, analytics or external search service.

## Verification

- All 203 built HTML pages and 9,847 local links/assets/fragments checked.
- Published Git tree: all 214 files match the checked build byte-for-byte.
- Live HTTPS checks matched exact built content for the home page, installation
  and timezone guides, allocation action, zoned service and Flow component
  references, CSS/JS/search assets, example ZIP and build manifest.
- Four documentation tests passed: search ranking, released-index coverage,
  jsdom interactions/safe text rendering/theme/navigation, and normal-text
  contrast for both themes. These are not browser rendering tests.
- All eight complete handbook Apex snippets/scripts compiled and ran against
  installed released 0.1.0.19, including unsaved hours and allocation assertions.
- Documentation formatting and `git diff --check` passed.

The publication commit is `73bd675bf35813292c03d8a06e60ec92dfc5a21a`, signed
and verified by GitHub. Pages build/deployment `34252496341` succeeded.
The local 1Password SSH signer failed (`failed to fill whole buffer`); publication
used GitHub's signed `createCommitOnBranch` API without disabling signing.
Only the new `gh-pages` branch was changed. Package source and the existing main
workspace were not committed as part of this publication.

Visual rendering was not inspected in a browser, in accordance with the project's
no-screen-capture/Computer Use requirement. No Salesforce package build or new
scratch org was used for documentation. The earlier authorised promotion of
0.1.0.19 succeeded and is recorded in `validation.md`.

For rebuild commands and content maintenance, see `scripts/docs/README.md`.
