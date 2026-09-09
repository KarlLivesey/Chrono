"""Run the handbook's complete Apex snippets in an existing installed subscriber org.

These snippets must remain read-only, use supplied records and avoid DML. This
command never creates an org, builds a package or deploys metadata.
"""
import argparse
import json
import re
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--target-org', required=True)
parser.add_argument('--output', required=True)
args = parser.parse_args()
snippets = []
for file in sorted((ROOT / 'docs/handbook').glob('*.md')) + [ROOT / 'docs/time-allocation.md']:
    for index, match in enumerate(re.finditer(r'```apex\n([\s\S]*?)```', file.read_text()), 1):
        snippets.append((str(file.relative_to(ROOT)) + ':' + str(index), match[1]))
snippets.append(('docs/examples/services.apex', (ROOT / 'docs/examples/services.apex').read_text()))
records = []
with tempfile.TemporaryDirectory(prefix='chrono-doc-examples-') as folder:
    for index, (name, source) in enumerate(snippets):
        file = Path(folder) / f'example-{index}.apex'
        file.write_text(source)
        response = subprocess.run(['sf', 'apex', 'run', '--target-org', args.target_org, '--file', str(file), '--json'],
                                  capture_output=True, text=True)
        data = json.loads(response.stdout)
        result = data.get('result', {})
        passed = response.returncode == 0 and result.get('compiled') is True and result.get('success') is True
        records.append({'example': name, 'passed': passed, 'compileProblem': result.get('compileProblem'),
                        'exceptionMessage': result.get('exceptionMessage')})
        print(('PASS ' if passed else 'FAIL ') + name, flush=True)
Path(args.output).write_text(json.dumps({'targetOrg': args.target_org, 'passed': all(r['passed'] for r in records),
                                       'examples': records}, indent=2) + '\n')
if not all(r['passed'] for r in records): raise SystemExit(1)
