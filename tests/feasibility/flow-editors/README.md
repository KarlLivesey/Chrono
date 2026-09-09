# Live Flow checks

These scripts use an isolated headless Chromium with a CLI-generated login URL.
They do not use the desktop, a personal browser, screen capture or recording.
The browser closes in `finally`, and authentication URLs are never logged.
No Salesforce orgs or package versions are created.

Use an existing Playwright installation with its Chromium browser available;
no project dependency is required. Run from the repository root:

```sh
export CHRONO_PLAYWRIGHT_MODULE=/absolute/path/to/playwright-core
export CHRONO_TARGET_ORG=chrono-dev
node tests/feasibility/flow-editors/examples.cjs
node tests/feasibility/flow-editors/additional-actions.cjs
node tests/feasibility/flow-editors/schedule-editor.cjs
node tests/feasibility/flow-editors/action-editor.cjs
```

Prerequisites: matching source, the scalar harnesses and all seven examples deployed, Chrono Flow User
assigned, and the demo schedules seeded as described in
[the example guide](../../../docs/flow-examples.md).

- `examples.cjs` runs all seven active examples and asserts their actual displayed
  results, including a repeated time, gap boundary, bank holiday and per-item error.
- `schedule-editor.cjs` opens the real screen editor, checks lookup selection,
  weekday preset, narrow-sidebar geometry and partial-day holiday controls. Its
  configuration changes are discarded when the browser closes.
- `action-editor.cjs` checks held-mouse timezone/resource selections and switching
  between a native Datetime literal and resource. It restores the example's
  original resource and timezone, **saves a new draft Flow version**, reloads and
  verifies the persisted values. It does not activate that draft.

These are live integration checks, not screenshot comparisons or a complete
visual/accessibility audit. Salesforce UI changes can require locator updates.
Do not point the mutation checks at a production org.

`additional-actions.cjs` opens all seven new action editors in their small
autolaunched harnesses and checks their operation-specific inputs.
It does not save changes. Set `CHRONO_EXAMPLE=Planning` to run only the new
planning scenario in `examples.cjs`.
