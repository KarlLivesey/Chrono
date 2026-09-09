# Shared Temporal and Apex fixtures

`cases.json` is the single dataset for both implementations, with explicit expected
values. Run it against the existing subscriber org with the current package installed:

```sh
python3 tests/conformance/run.py --target-org chrono-subscriber --output /tmp/chrono-conformance.json
```

The runner performs no deployment, package build, org creation or record writes.
It uses the installed global Apex services and local-resolution action. The client
loads the production picker engine with native Temporal; an attempted Apex fallback
fails the client fixture, so it cannot conceal a difference between implementations.
Duration expectations are also compared with native Temporal, converted independently
to Chrono's months/days/milliseconds representation. Error fixtures compare rejection,
not implementation-specific exception text. A missing result fails comparison.

The 30 fixtures cover ordinary offsets, differing seasonal-change dates, repeated
hours, 30-minute transitions, nearest valid gap boundaries, Samoa's skipped date,
fraction truncation, pre-epoch instants, duration normalisation and invalid values.
Both the instant and its local projection must remain in years 0001–9999. Leap-second
notation is rejected rather than normalised to second 59. These are Chrono's narrower
rules around Temporal, whose supported range and parsing behaviour differ.

`npm run test:temporal` runs the client half without an org. The full runner is
required to claim agreement with Apex. This is a representative compatibility suite,
not exhaustive timezone history or browser rendering verification.
