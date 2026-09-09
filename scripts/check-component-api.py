"""Protect LWC public members, builder metadata and Apex transport declarations.

Uses the existing LWC test parser and Python XML parser, not regular expressions
for JavaScript. Behaviour and event payloads remain covered by component tests.
"""
import argparse
import difflib
import importlib.util
import json
import re
import subprocess
from pathlib import Path
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[1]
BASELINE = ROOT / 'tests/contracts/component-api.json'
spec = importlib.util.spec_from_file_location('apex_contract', ROOT / 'scripts/check-global-api.py')
apex = importlib.util.module_from_spec(spec)
spec.loader.exec_module(apex)


def metadata(source):
    def element(node):
        return {'tag': node.tag.rsplit('}', 1)[-1], 'attributes': dict(sorted(node.attrib.items())),
                'text': (node.text or '').strip(), 'children': [element(child) for child in node]}
    return element(ElementTree.fromstring(source))


def lwc_contracts(sources):
    run = subprocess.run(['node', str(ROOT / 'scripts/inspect-lwc-api.cjs')], input=json.dumps(sources),
                         capture_output=True, text=True, check=True, cwd=ROOT)
    return json.loads(run.stdout)


def aura_contracts(source):
    declarations = apex.declarations(source, include_aura=True)
    rows = [row for row in declarations if '@ AuraEnabled' in row['declaration']]
    owners = {row['owner'] for row in rows}
    names = set()
    for row in rows:
        if row['kind'] != 'method':
            continue
        signature = ' '.join(apex.strip_annotations(row['declaration'].split()))
        name = re.search(r'(\w+)\s*\(', signature)[1]
        key = row['owner'], name
        if key in names:
            raise ValueError('Do not overload @AuraEnabled endpoints: ' + '.'.join(key))
        names.add(key)
    types = []
    for row in declarations:
        if row['kind'] != 'type':
            continue
        name = re.search(r'\b(?:class|interface|enum) (\w+)', row['declaration'])[1]
        qualified = '.'.join(filter(None, [row['owner'], name]))
        if any(owner == qualified or owner.startswith(qualified + '.') for owner in owners):
            types.append(row)
    return types + rows


def inventory():
    result, sources = {}, {}
    for folder in sorted((ROOT / 'force-app/main/default/lwc').iterdir()):
        xml = folder / (folder.name + '.js-meta.xml')
        js = folder / (folder.name + '.js')
        if not xml.exists():
            continue
        result[folder.name] = {'metadata': metadata(xml.read_text())}
        # Utility modules have no LightningElement class or component public API.
        if js.exists():
            sources[folder.name] = js.read_text()
    for name, members in lwc_contracts(sources).items():
        if members is not None:
            result[name]['members'] = members
    transports = {}
    for src in sorted((ROOT / 'force-app/main/default/classes').glob('*.cls')):
        rows = aura_contracts(src.read_text())
        if rows:
            transports[src.stem] = rows
    return {'components': result, 'apexTransports': transports}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--update', action='store_true')
    args = parser.parse_args()
    current = json.dumps(inventory(), indent=2) + '\n'
    if args.update:
        BASELINE.write_text(current)
    elif json.loads(current) != json.loads(BASELINE.read_text()):
        diff = ''.join(difflib.unified_diff(BASELINE.read_text().splitlines(True), current.splitlines(True),
                                          fromfile='reviewed component API', tofile='current component API'))
        raise SystemExit('Component/Flow/Apex transport contract changed; review before updating the baseline.\n' + diff)
    data = json.loads(current)
    print(f"Verified {len(data['components'])} LWC metadata contracts and {len(data['apexTransports'])} Apex transport types; no overloaded Aura endpoints.")


if __name__ == '__main__':
    main()
