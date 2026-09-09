#!/usr/bin/env python3
"""Measure read-only Chrono operations through the installed global API.

Uses existing sf authentication. Each case has its own transaction, one warm-up
sample and measured samples. Never deploys metadata, creates an org or builds a
package. An operation/assertion failure fails the benchmark, rather than reporting
fast error handling as a successful timing.
"""
import argparse
import json
import statistics
import subprocess
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

def apex_source(case, samples, count, first_sample=-1):
    body = case['body'].replace('$COUNT', str(count))
    setup = case.get('setup', '').replace('$COUNT', str(count))
    assertion = case['assert'].replace('$COUNT', str(count))
    return f'''{setup}
for (Integer sample = {first_sample}; sample < {samples}; sample++) {{
    Integer cpuBefore = Limits.getCpuTime();
    Integer heapBefore = Limits.getHeapSize();
    Integer queriesBefore = Limits.getQueries();
    Integer dmlBefore = Limits.getDmlStatements();
    {body}
    Integer cpu = Limits.getCpuTime() - cpuBefore;
    Integer heapAfter = Limits.getHeapSize();
    Integer queries = Limits.getQueries() - queriesBefore;
    Integer dml = Limits.getDmlStatements() - dmlBefore;
    {assertion}
    Assert.areEqual(0, dml, 'Benchmarks must not perform DML.');
    System.debug(LoggingLevel.ERROR, 'CHRONO_BENCH ' + JSON.serialize(new Map<String,Object>{{
        'sample' => sample, 'cpuMs' => cpu, 'heapAfterBytes' => heapAfter,
        'heapDeltaBytes' => heapAfter - heapBefore,
        'callerNamespaceQueries' => queries, 'callerNamespaceDml' => dml,
        'cpuLimitMs' => Limits.getLimitCpuTime(), 'cpuUsedMs' => Limits.getCpuTime(),
        'heapLimitBytes' => Limits.getLimitHeapSize()
    }}));
}}
'''

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target-org', default='chrono-subscriber')
    parser.add_argument('--label', default='', help='Package version or other run context')
    parser.add_argument('--samples', type=int, default=3)
    parser.add_argument('--count', type=int, default=200)
    parser.add_argument('--case', action='append', dest='selected')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if not 1 <= args.samples <= 10 or not 1 <= args.count <= 200:
        parser.error('Use 1–10 samples and 1–200 operations per sample.')
    if args.output.exists():
        parser.error('Choose a new output file to preserve earlier measurements.')
    cases = json.loads((Path(__file__).parent / 'apex-cases.json').read_text())
    if args.selected:
        unknown = set(args.selected) - {case['name'] for case in cases}
        if unknown:
            parser.error('Unknown cases: ' + ', '.join(sorted(unknown)))
        cases = [case for case in cases if case['name'] in args.selected]
    else:
        cases = [case for case in cases if not case.get('explicitSelectionOnly', False)]
    report = {'createdAt': datetime.now(timezone.utc).isoformat(),
              'targetOrg': args.target_org, 'label': args.label, 'operationsPerSample': args.count,
              'measuredSamples': args.samples, 'warmupSamples': 1, 'cases': []}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    for case in cases:
        count = min(args.count, case.get("maxCount", args.count))
        samples = []
        runs = range(-1, args.samples) if case.get('freshTransactionPerSample') else [None]
        for sample in runs:
            with tempfile.TemporaryDirectory(prefix='chrono-benchmark-') as folder:
                script = Path(folder) / 'benchmark.apex'
                script.write_text(apex_source(case, args.samples if sample is None else sample + 1,
                                              count, -1 if sample is None else sample))
                command = subprocess.run(['sf', 'apex', 'run', '--target-org', args.target_org,
                                          '--file', str(script), '--json'],
                                         cwd=ROOT, capture_output=True, text=True)
            response = json.loads(command.stdout)
            result = response.get('result', response.get('data', {}))
            if command.returncode or not result.get('success'):
                message = str(result.get('compileProblem') or result.get('exceptionMessage') or
                              response.get('message') or command.stderr)
                report['failure'] = {'case': case['name'], 'sample': sample, 'message': message}
                args.output.write_text(json.dumps(report, indent=2) + '\n')
                raise RuntimeError(case['name'] + ': ' + message)
            samples.extend(json.loads(line.split('CHRONO_BENCH ', 1)[1])
                           for line in result.get('logs', '').splitlines()
                           if '|USER_DEBUG|' in line and 'CHRONO_BENCH ' in line)
        measured = [sample for sample in samples if sample['sample'] >= 0]
        if len(measured) != args.samples:
            raise RuntimeError(case['name'] + ': incomplete benchmark log')
        cpu = [sample['cpuMs'] for sample in measured]
        row = {'name': case['name'], 'description': case['description'], 'operationsPerSample': count, 'samples': samples,
               'transactionMode': 'perSample' if case.get('freshTransactionPerSample') else 'perCase',
               'cpuMs': {'min': min(cpu), 'median': statistics.median(cpu), 'max': max(cpu)},
               'medianCpuMsPerOperation': statistics.median(cpu) / count}
        report['cases'].append(row)
        args.output.write_text(json.dumps(report, indent=2) + '\n')
        print(f"{case['name']}: {row['cpuMs']['median']} ms CPU / {count} operations", flush=True)

if __name__ == '__main__':
    main()
