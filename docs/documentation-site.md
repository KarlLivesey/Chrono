# Documentation site delivery — 10 September 2026

Published **https://karllivesey.github.io/Chrono/** for released **0.2.0.4**.
The repository homepage points to the site. GitHub Pages uses `gh-pages` at `/`
with HTTPS enforced.

## Content and implementation

- 222 content pages, plus search and a 404 page.
- Task-based admin and developer guides, 147 global Apex class references,
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

- All 224 built HTML pages and 11,348 local links/assets/fragments checked.
- Published Git tree: all generated files match the checked build byte-for-byte.
- Live HTTPS checks matched exact built content for the home page, installation
  and timezone guides, allocation action, zoned service and Flow component
  references, CSS/JS/search assets, example ZIP and build manifest.
- Five documentation tests passed: search ranking, released-index coverage,
  jsdom interactions/safe text rendering/theme/navigation, and normal-text
  contrast for both themes. These are not browser rendering tests.
- All eight complete handbook Apex snippets/scripts compiled and ran against
  installed released 0.2.0.4, including unsaved hours and allocation assertions.
- Documentation formatting and `git diff --check` passed.

The current publication commit and Pages build are recorded here after the
`gh-pages` update. Package source and the main workspace are kept separate from
the generated Pages branch.

Visual rendering was not inspected in a browser, in accordance with the project's
no-screen-capture/Computer Use requirement. No Salesforce package build or new
scratch org was used for documentation. The earlier authorised promotion of
0.2.0.4 succeeded and is recorded in `validation.md`.

For rebuild commands and content maintenance, see `scripts/docs/README.md`.
