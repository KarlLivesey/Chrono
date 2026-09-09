# Chrono

Dates, times and durations for Salesforce. Chrono builds on native `Date`, `Time`
and `Datetime` values, with Apex services, Flow actions and reusable Lightning
components.

**[Documentation](https://karllivesey.github.io/Chrono/)** · **[Examples](https://karllivesey.github.io/Chrono/handbook/examples.html)** · **[Release notes](https://karllivesey.github.io/Chrono/handbook/releases.html)**

## What it does

- **Timezones:** convert local times and exact instants, handle daylight-saving
  changes, and explicitly resolve repeated or missing times.
- **Calculations:** add dates and durations, calculate calendar or elapsed
  differences, compare values, round and format them.
- **Working time:** respect Salesforce operating hours and holidays when adding
  time, measuring work or finding availability.
- **Time allocation:** divide work into named blocks, with separate holiday
  rules and configurable overlap handling.
- **Flow and UI:** 54 Flow actions with configuration editors, plus reusable
  date/time pickers and components for Flow screens and record pages.

Chrono uses Salesforce's calendar and timezone rules, with millisecond precision.

## Quick start

Install **0.2.0.4**, a managed package in the **`skel`** namespace:

| Your org                        | Install package                                                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Production or Developer Edition | **[Install Chrono](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KOZFQA4)**             |
| Sandbox                         | **[Install Chrono in a sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KOZFQA4)** |

1. Open the appropriate link, sign in to your org and select **Install for Admins Only**.
2. In **Setup → Permission Sets → Chrono Flow User**, assign access to your users.
3. Create a Screen Flow. Add **Chrono: Date and time** to a screen, or add the
   **Chrono: Convert date/time** action.

For working schedules, also grant access to the required schedule, time-slot
and holiday records. See the [installation guide](https://karllivesey.github.io/Chrono/handbook/installation.html).

Already using Salesforce CLI? Replace `your-org` with your authenticated org alias:

```sh
sf package install --package 04tgK000000KOZFQA4 --target-org your-org --security-type AdminsOnly --wait 20
```

## Start building

- **Admins:** [Your first Flow](https://karllivesey.github.io/Chrono/handbook/first-flow.html) · [Action catalogue](https://karllivesey.github.io/Chrono/reference/actions/index.html)
- **Developers:** [Apex quick start](https://karllivesey.github.io/Chrono/handbook/apex.html) · [API reference](https://karllivesey.github.io/Chrono/reference/apex/index.html)
- **Components:** [Flow screen setup](https://karllivesey.github.io/Chrono/handbook/screen-configuration.html) · [LWC guide](https://karllivesey.github.io/Chrono/handbook/components.html)
- **Examples:** [Downloadable Flows and runnable Apex](https://karllivesey.github.io/Chrono/handbook/examples.html)

## Licence

[BSD 3-Clause](LICENSE). Copyright (c) 2026, Karl.
