# Temporal

Salesforce second-generation managed package in the `skel` namespace, using
`skel-devhub` as its Dev Hub.

The managed package is registered in the Dev Hub with package ID
`0HogK0000004dxFSAQ` and local alias `Temporal`.

The intended scope is to replicate JavaScript Temporal functionality in Apex and
provide conversions to and from Salesforce's standard `Date`, `Time` and
`Datetime` types.

This project currently contains setup only. No Apex implementation, tests,
dependencies or package versions have been created.

## Project configuration

- `sfdx-project.json`: package directory, namespace, API version and version settings.
- `config/project-scratch-def.json`: Developer Edition scratch-org definition.
- `force-app/main/default/classes/`: empty directory reserved for future Apex source.

The initial package version setting is `0.1.0.NEXT`. This is configuration for a
future build, not an existing installable version.

## Local development setup

Authenticate the Dev Hub if the `skel-devhub` alias is not already available:

```sh
sf org login web --alias skel-devhub --set-default-dev-hub
```

Set the Dev Hub for this project:

```sh
sf config set target-dev-hub=skel-devhub
```

When development begins, create a namespaced scratch org:

```sh
sf org create scratch --definition-file config/project-scratch-def.json --target-dev-hub skel-devhub --alias temporal-dev --set-default --duration-days 7
```

No scratch org is created as part of the initial setup.

Package configuration follows the [Salesforce managed 2GP project configuration documentation](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev2gp-config-file.html).

## Licence

Temporal is licensed under the [BSD 3-Clause License](LICENSE)
(`BSD-3-Clause`). Copyright (c) 2026, Karl.
