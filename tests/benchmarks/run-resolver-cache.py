#!/usr/bin/env python3
"""Compare a native-key cache wrapper with the actual resolver in chrono-dev.

Runs paired anonymous Apex transactions; never deploys metadata or changes the
production resolver. Explicit developer-org access is needed for the internal
resolver. Each measured pair alternates which implementation runs first.
"""
import argparse
import hashlib
import json
import statistics
import subprocess
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCENARIOS = ['repeat-unique', 'repeat-overlap', 'repeat-gap', 'reuse-90',
             'reuse-50', 'reuse-25', 'distinct-times', 'distinct-dates']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target-org', default='chrono-dev')
    parser.add_argument('--pairs', type=int, default=6)
    parser.add_argument('--count', type=int, default=200)
    parser.add_argument('--case', action='append', choices=SCENARIOS, dest='selected')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--checks-only', action='store_true', help='Run cache isolation, key separation and validation checks without timing.')
    args = parser.parse_args()
    if args.pairs < 2 or args.pairs > 10 or args.pairs % 2:
        parser.error('Use an even number of pairs between 2 and 10 to balance ordering.')
    if not 1 <= args.count <= 200:
        parser.error('Use 1–200 operations per arm.')
    if args.output.exists():
        parser.error('Choose a new output file to preserve earlier measurements.')
    template = (Path(__file__).parent / 'experiments/nested-resolver-cache.apex').read_text()
    report = {'createdAt': datetime.now(timezone.utc).isoformat(), 'targetOrg': args.target_org,
              'sourceCommit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
              'fixtureSha256': hashlib.sha256(template.encode()).hexdigest(),
              'operationsPerArm': args.count, 'measuredPairs': args.pairs, 'warmupPairs': 1,
              'method': 'Paired current resolver versus native-key wrapper; alternating order; fresh cache per arm.',
              'cases': []}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.checks_only:
        checks = (Path(__file__).parent / 'experiments/nested-resolver-cache-checks.apex').read_text()
        source = template[:template.index('String scenario =')] + checks
        with tempfile.TemporaryDirectory(prefix='chrono-cache-checks-') as folder:
            script = Path(folder) / 'checks.apex'
            script.write_text(source)
            response = subprocess.run(['sf', 'apex', 'run', '--target-org', args.target_org,
                                       '--file', str(script), '--json'], cwd=ROOT, capture_output=True, text=True)
        data = json.loads(response.stdout)
        result = data.get('result', data.get('data', {}))
        report['checksSha256'] = hashlib.sha256(checks.encode()).hexdigest()
        report['checksPassed'] = response.returncode == 0 and result.get('success') is True
        if not report['checksPassed']:
            report['failure'] = result.get('compileProblem') or result.get('exceptionMessage') or data.get('message')
        args.output.write_text(json.dumps(report, indent=2) + '\n')
        if not report['checksPassed']:
            raise RuntimeError(report['failure'])
        print('Cache isolation, zone/date/millisecond keys, overlaps, gaps and invalid inputs passed.', flush=True)
        return
    for scenario in args.selected or SCENARIOS:
        row = {'name': scenario, 'samples': []}
        report['cases'].append(row)
        for pair in range(-1, args.pairs):
            source = template.replace('__SCENARIO__', scenario).replace('__PAIR__', str(pair)).replace('__COUNT__', str(args.count))
            with tempfile.TemporaryDirectory(prefix='chrono-cache-benchmark-') as folder:
                script = Path(folder) / 'benchmark.apex'
                script.write_text(source)
                response = subprocess.run(['sf', 'apex', 'run', '--target-org', args.target_org,
                                           '--file', str(script), '--json'], cwd=ROOT, capture_output=True, text=True)
            data = json.loads(response.stdout)
            result = data.get('result', data.get('data', {}))
            if response.returncode or not result.get('success'):
                report['failure'] = {'scenario': scenario, 'pair': pair,
                                     'message': result.get('compileProblem') or result.get('exceptionMessage') or data.get('message')}
                args.output.write_text(json.dumps(report, indent=2) + '\n')
                raise RuntimeError(report['failure'])
            values = [json.loads(line.split('CHRONO_CACHE_BENCH ', 1)[1])
                      for line in result.get('logs', '').splitlines()
                      if '|USER_DEBUG|' in line and 'CHRONO_CACHE_BENCH ' in line]
            if len(values) != 2 or {value['cached'] for value in values} != {False, True}:
                raise RuntimeError('Incomplete paired measurement')
            row['samples'].extend(values)
            args.output.write_text(json.dumps(report, indent=2) + '\n')
        measured = [value for value in row['samples'] if value['pair'] >= 0]
        for cached, label in [(False, 'uncached'), (True, 'cached')]:
            cpu = [value['cpuMs'] for value in measured if value['cached'] == cached]
            row[label] = {'minCpuMs': min(cpu), 'medianCpuMs': statistics.median(cpu), 'maxCpuMs': max(cpu)}
        differences = [next(v['cpuMs'] for v in measured if v['pair'] == pair and v['cached']) -
                       next(v['cpuMs'] for v in measured if v['pair'] == pair and not v['cached'])
                       for pair in range(args.pairs)]
        row['pairedCpuDeltaMs'] = {'values': differences, 'median': statistics.median(differences)}
        args.output.write_text(json.dumps(report, indent=2) + '\n')
        print(f"{scenario}: uncached {row['uncached']['medianCpuMs']} ms; cached {row['cached']['medianCpuMs']} ms; paired delta {row['pairedCpuDeltaMs']['median']} ms", flush=True)


if __name__ == '__main__':
    main()
