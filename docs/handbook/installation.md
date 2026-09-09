# Install Chrono

Install **0.1.0.19**, the first released managed-package version. Its namespace is
`skel` and its subscriber version ID is `04tgK000000KFNtQAO`.

## Install into your org

| Your org                        | Install Chrono 0.1.0.19                                                                                                            |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Production or Developer Edition | **[Install in production / Developer Edition](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KFNtQAO)** |
| Sandbox                         | **[Install in a sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KFNtQAO)**                       |

No repository clone, scratch org or Dev Hub is needed to install the package.
Sign in to the intended org and review Salesforce's package installation screen.
Start with **Install for Admins Only**, then assign access deliberately.

Alternatively, authenticate your org with Salesforce CLI and run:

```sh
sf package install --package 04tgK000000KFNtQAO --target-org your-org --security-type AdminsOnly --wait 20
```

Here `your-org` is your authenticated alias, not a Chrono requirement. An install
can continue after the CLI wait ends. Use the returned request ID with
`sf package install report --request-id YOUR_REQUEST_ID --target-org your-org`
and require a successful result before deploying examples.

## Give users access

1. In Setup, open **Permission Sets**.
2. Open **Chrono Flow User** and manage its assignments.
3. Assign it to the people running Chrono actions and screens.
4. Separately grant the object and field access needed for the schedules or
   records they will use.

The permission set grants package Apex access. It does not grant unrestricted
access to your organisation's schedules, holidays or business records.
See [permissions and execution context](security.md).

## Choose a schedule model

Saved OperatingHours calculations use `OperatingHours`, normal `TimeSlot`
records, `OperatingHoursHoliday` links and `Holiday` records. Your org must make
those objects and fields available. Having Salesforce `BusinessHours` configured
does not automatically create an OperatingHours schedule.

Chrono also supports native BusinessHours arithmetic through the corresponding
working-time action and Apex overloads. These use that model's separate schedule
and holiday configuration. See [operating hours](operating-hours.md) before
choosing which model to use.

## Confirm the installation

Create a Screen Flow and look for **Chrono: Date and time** in the screen's custom
components. Add an Action and search for **Chrono: Convert date/time**. The action
should have a Chrono category and its own configuration editor.

Then follow [Your first Flow](first-flow.md) or run the
[Apex quick start](apex.md). The [example library](examples.md) is supplied
separately from the package so installing Chrono does not add demo data to your org.

## Updates

Keep the package version recorded with your deployment. Preserve the released
global API and Flow property contracts when writing integrations; use documented
services rather than package internals. Future releases need an upgrade check
against this baseline. No released-to-released upgrade was possible when this
first version was published.
