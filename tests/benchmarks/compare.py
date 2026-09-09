#!/usr/bin/env python3
"""Compare matching Apex benchmark cases without imposing timing pass/fail thresholds."""
import argparse
import json
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('baseline', type=Path)
parser.add_argument('current', type=Path)
args = parser.parse_args()
before = json.loads(args.baseline.read_text())
after = json.loads(args.current.read_text())
old_cases = {case['name']: case for case in before['cases']}
print('| Case | Baseline CPU ms | Current CPU ms | Change |')
print('| --- | ---: | ---: | ---: |')
for case in after['cases']:
    old = old_cases.get(case['name'])
    if not old:
        continue
    old_count = old.get('operationsPerSample', before['operationsPerSample'])
    new_count = case.get('operationsPerSample', after['operationsPerSample'])
    if old_count != new_count or before['measuredSamples'] != after['measuredSamples']:
        raise ValueError(case['name'] + ': workload or sample count differs')
    if old.get('transactionMode', 'perCase') != case.get('transactionMode', 'perCase'):
        raise ValueError(case['name'] + ': transaction mode differs')
    baseline, current = old['cpuMs']['median'], case['cpuMs']['median']
    delta = f'{(current / baseline - 1) * 100:+.1f}%' if baseline else 'n/a'
    print(f"| {case['name']} ({new_count}) | {baseline} | {current} | {delta} |")
