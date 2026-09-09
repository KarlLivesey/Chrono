#!/usr/bin/env python3
"""Compare shared fixtures against native Temporal and the installed Apex API."""
import argparse
import json
import subprocess
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent


def apex_results(fixtures, target_org):
    # Fixture JSON is embedded in an Apex string literal, not a shell command.
    encoded = json.dumps(fixtures).replace('\\', '\\\\').replace("'", "\\'")
    with tempfile.TemporaryDirectory(prefix='chrono-conformance-') as folder:
        script = Path(folder) / 'conformance.apex'
        script.write_text((HERE / 'apex.template').read_text().replace('__FIXTURES__', encoded))
        command = subprocess.run(
            ['sf', 'apex', 'run', '--target-org', target_org, '--file', str(script), '--json'],
            cwd=ROOT, capture_output=True, text=True,
        )
    response = json.loads(command.stdout)
    result = response.get('result', response.get('data', {}))
    if command.returncode or not result.get('success'):
        raise RuntimeError(result.get('compileProblem') or result.get('exceptionMessage') or response.get('message'))
    rows = {}
    for line in result.get('logs', '').splitlines():
        if '|USER_DEBUG|' in line and 'CHRONO_CONFORMANCE ' in line:
            row = json.loads(line.split('CHRONO_CONFORMANCE ', 1)[1])
            rows[row['id']] = row['actual']
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target-org', default='chrono-subscriber')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error('Choose a new output file.')
    fixtures = json.loads((HERE / 'cases.json').read_text())
    client = subprocess.run(
        ['node', '--harmony-temporal', str(HERE / 'client.mjs')],
        capture_output=True, text=True, check=True,
    )
    js_results = {row['id']: row['actual'] for row in json.loads(client.stdout)}
    apex = apex_results(fixtures, args.target_org)
    rows = []
    for fixture in fixtures:
        ident = fixture['id']
        expected = fixture['expected']
        rows.append({
            'id': ident, 'passed': js_results.get(ident) == apex.get(ident) == expected,
            'expected': expected, 'temporal': js_results.get(ident), 'apex': apex.get(ident),
        })
    passed = all(row['passed'] for row in rows)
    report = {
        'createdAt': datetime.now(timezone.utc).isoformat(),
        'targetOrg': args.target_org, 'passed': passed, 'cases': rows,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + '\n')
    for row in rows:
        if not row['passed']:
            print(json.dumps(row, indent=2))
    print(f"{sum(row['passed'] for row in rows)}/{len(rows)} shared fixtures agree with expected results in both implementations.")
    raise SystemExit(0 if passed else 1)


if __name__ == '__main__':
    main()
