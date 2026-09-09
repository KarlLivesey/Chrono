"""Generate development-source reference Markdown from Apex declarations and LWC metadata.

Uses the same declaration reader as the compatibility guard. This never updates
the API baselines or edits package sources. Handwritten guides live separately.
"""
import importlib.util
import json
import re
import xml.etree.ElementTree as ET
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DOCS = ROOT / 'docs'
CLASSES = ROOT / 'force-app/main/default/classes'
NS = {'m': 'http://soap.sforce.com/2006/04/metadata'}
VERSION = json.loads((ROOT / 'sfdx-project.json').read_text())['packageDirectories'][0]['versionNumber']
REFERENCE_STATUS = 'Development source; not the released installation package'
spec = importlib.util.spec_from_file_location('chrono_api', ROOT / 'scripts/check-global-api.py')
api = importlib.util.module_from_spec(spec)
spec.loader.exec_module(api)


def plain(declaration):
    return api.strip_annotations(api.TOKEN.findall(declaration))


def compact(tokens):
    value = ' '.join(tokens)
    for pattern, replacement in [(r'\s+([,;)\]>])', r'\1'), (r'([(\[<])\s+', r'\1'),
                                 (r'\s*\.\s*', '.'), (r'\s+\(', '('), (r'\s+<', '<')]:
        value = re.sub(pattern, replacement, value)
    return value


def attributes(declaration):
    pairs = re.findall(r"(\w+)\s*=\s*('(?:\\.|[^'\\])*'|true|false)", declaration)
    return {key: value[1:-1].replace("\\'", "'") if value.startswith("'") else value for key, value in pairs}


def description(source, tokens):
    match = re.search(r'\s*'.join(re.escape(t) for t in tokens), source)
    if not match:
        return ''
    comments = list(re.finditer(r'/\*\*([\s\S]*?)\*/', source[:match.start()]))
    if not comments:
        return ''
    comment = comments[-1]
    if '}' in source[comment.end():match.start()]:
        return ''
    body = re.sub(r'^\s*\*\s?', '', comment[1], flags=re.M)
    found = re.search(r'@description\s+([\s\S]*?)(?=@\w+|$)', body)
    return ' '.join(found[1].split()) if found else ''


def cell(text):
    return str(text or '—').replace('|', '\\|').replace('\n', ' ')


def table(headers, rows):
    return '\n'.join(['| ' + ' | '.join(headers) + ' |', '| ' + ' | '.join(['---'] * len(headers)) + ' |'] +
                     ['| ' + ' | '.join(cell(v) for v in row) + ' |' for row in rows]) + '\n'


def write(relative, contents):
    target = DOCS / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(contents.rstrip() + '\n')


def related(declaration, inventory):
    names = sorted(set(re.findall(r'\bChrono\w+', declaration)) & inventory.keys())
    return ', '.join(f'[{name}]({name}.md)' for name in names)


def apex_pages(inventory):
    groups = defaultdict(list)
    for name, rows in inventory.items():
        source = (CLASSES / f'{name}.cls').read_text()
        category = ('Services' if name.endswith('Service') else 'Flow entry points' if name.endswith('Action')
                    else 'Core values' if name in CORE else 'Requests, results and configuration')
        groups[category].append((name, description(source, plain(rows[0]['declaration']))))
        out = [f'# {name}', f'Apex reference · `{VERSION}` · {REFERENCE_STATUS} · Subscriber name: `skel.{name}`.',
               description(source, plain(rows[0]['declaration']))]
        if name in CORE:
            out.append(f'Data-only value. Use [{name}Service]({name}Service.md) for construction and operations. '
                       'An empty constructor creates uninitialised data; services validate mutable fields.')
        if name.endswith('Service'):
            out.append('Call these static entry points from subscriber Apex. Core operations return new values and validate '
                       'their source. The package owns the implementation behind these signatures. '
                       'See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).')
        owners = defaultdict(list)
        for row in rows:
            owners[row['owner']].append(row)
        for owner, members in owners.items():
            out.append(f'## {owner or "Declaration"}')
            fields = [row for row in members if row['kind'] in ('field', 'property', 'enumMember')]
            if fields:
                field_rows = []
                for row in fields:
                    dec = row['declaration']; attrs = attributes(dec); tokens = plain(dec)
                    notes = attrs.get('description') or description(source, tokens)
                    if attrs.get('required') == 'true': notes = 'Required. ' + notes
                    if row.get('accessors'): notes += ' Accessors: ' + ', '.join(row['accessors']) + '.'
                    field_rows.append((f'`{compact(tokens)}`', attrs.get('label'), notes))
                out.append(table(['Field / property', 'Flow label', 'Contract'], field_rows))
            for row in members:
                if row['kind'] not in ('type', 'method'):
                    continue
                tokens = plain(row['declaration'])
                if row['kind'] == 'method':
                    out.append(f'### {tokens[tokens.index("(") - 1]}')
                declaration = compact(tokens)
                out.append(f'```apex\n{declaration}\n```')
                out.append(description(source, tokens))
                refs = related(declaration, inventory)
                if refs: out.append('Types: ' + refs + '.')
        out.append('Generated from the current development source declarations. Signatures shown without bodies are reference '
                   'declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).')
        write(f'reference/apex/{name}.md', '\n\n'.join(v for v in out if v))
    out = ['# Apex reference', f'All **{len(inventory)} global classes** in Chrono {VERSION}, including nested declarations. '
           f'The reference contains **{sum(len(rows) for rows in inventory.values()):,} global declarations**. Internal public classes are deliberately excluded. ',
           f'**{REFERENCE_STATUS}.** See [release notes](../../handbook/releases.md). '
           'Start with the core value services or the [direct bulk Apex services](../../bulk-apex-services.md). Flow entry points are also callable from Apex, but their nested '
           'requests and specialised results are different from the core values. '
           '[Read the quick start](../../handbook/apex.md).']
    for group in ['Services', 'Core values', 'Flow entry points', 'Requests, results and configuration']:
        out += [f'## {group}', table(['Class', 'Purpose'], [(f'[{n}]({n}.md)', desc) for n, desc in groups[group]])]
    write('reference/apex/index.md', '\n\n'.join(out))


CORE = {'Chrono' + name for name in ['Instant', 'ZonedDateTime', 'PlainDateTime', 'PlainDate', 'PlainTime',
                                    'PlainYearMonth', 'PlainMonthDay', 'Duration']}
GUIDES = {'Values': 'types', 'Calculations': 'arithmetic', 'Time Zones': 'timezones', 'Durations': 'arithmetic',
          'Formatting': 'formatting', 'Working Hours': 'operating-hours', 'Ranges': 'ranges-recurrence',
          'Recurrence': 'ranges-recurrence', 'Collections': 'collections', 'Time allocation': 'allocation'}


def action_pages(inventory):
    catalogue = {item['family']: item for item in json.loads((ROOT / 'scripts/actions/catalogue.json').read_text())}
    groups = defaultdict(list)
    for name, rows in inventory.items():
        methods = [r for r in rows if 'InvocableMethod' in r['declaration']]
        if not methods or 'CollectionAction' in name:
            continue
        family = name.removeprefix('Chrono').removesuffix('Action')
        method = methods[0]; meta = attributes(method['declaration']); category = meta['category'].removeprefix('Chrono: ')
        title = meta['label'].removeprefix('Chrono: ')
        groups[category].append((family, title, meta.get('description', '')))
        coll_name = f'Chrono{family}CollectionAction'; coll_rows = inventory[coll_name]
        coll_method = next(r for r in coll_rows if 'InvocableMethod' in r['declaration'])
        coll_meta = attributes(coll_method['declaration'])
        item_field = next(r for r in coll_rows if r['kind'] == 'field')
        item_type = re.search(r'List\s*<\s*(\w+)', item_field['declaration'])[1]
        result = re.search(r'List\s*<\s*(\w+)', compact(plain(method['declaration'])))[1]
        coll_result = re.search(r'List\s*<\s*(\w+)', compact(plain(coll_method['declaration'])))[1]
        out = [f'# {title}', f'**{meta["category"]}** · `{family}` · {VERSION} · {REFERENCE_STATUS}.', meta.get('description', ''),
               table(['Form', 'Builder label', 'Apex entry point'], [
                   ('Single', meta['label'], f'[{name}](../apex/{name}.md)'),
                   ('Collection', coll_meta['label'], f'[{coll_name}](../apex/{coll_name}.md)')]),
               f'Read [{GUIDES[category].replace("-", " ")}](../../handbook/{GUIDES[category]}.md) for semantics '
               'and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.',
               '## Inputs', 'Fields below describe the scalar request. “Required” is the universal annotation; '
               'additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.']
        field_rows = []
        for row in rows:
            if row['kind'] != 'field' or 'InvocableVariable' not in row['declaration']:
                continue
            dec = row['declaration']; attrs = attributes(dec); tokens = plain(dec)
            field_rows.append((f'`{tokens[-1]}`', attrs.get('label'), f'`{compact(tokens[1:-1])}`',
                               'Yes' if attrs.get('required') == 'true' else 'Conditional / optional', attrs.get('description')))
        out.append(table(['API name', 'Label', 'Type', 'Required', 'Meaning'], field_rows))
        fields = catalogue.get(family, {}).get('fields', [])
        choices = [(f'`{field["name"]}`', ', '.join(f'`{v}`' for v in field['options']),
                    ', '.join(field.get('appliesTo', []))) for field in fields if field.get('options')]
        if choices:
            out += ['## Editor choices', table(['Field', 'Values', 'Applicable source types'], choices),
                    'These are field-level choices; they do not imply every operation supports every combination. '
                    'The runtime rejects combinations requiring missing context or unsupported units.']
        out += ['## Results', f'The scalar result is [{result}](../apex/{result}.md). '
                'Check `success` before consuming its fields; `errorMessage` identifies an item failure.',
                f'The collection result is [{coll_result}](../apex/{coll_result}.md). '
                'Inspect each inner result as well as the collection envelope.',
                '## Collection requests', f'Use an Apex-defined collection of '
                f'[{item_type}](../apex/{item_type}.md) for this action. '
                'Do not substitute another family’s request type. Both forms batch across interviews and '
                'preserve item order; returned data is independent.',
                '## Configuration registration', f'Scalar editor: `{meta["configurationEditor"]}`. '
                f'Collection editor: `{coll_meta["configurationEditor"]}`. '
                'Both are namespaced package components with a calendar icon. '
                'The installed 0.1.0.19 action metadata was checked against these registrations.',
                'Generated from invocable source declarations and the editor catalogue. '
                '[All action families](index.md) · [Examples](../../handbook/examples.md).']
        write(f'reference/actions/{family}.md', '\n\n'.join(out))
    assert sum(map(len, groups.values())) == 27
    out = ['# Flow action reference', '**27 families · 54 actions · 10 categories.** '
           'Every family has a single-value and explicit-collection form, both bulkified across Flow interviews.',
           'Choose a task below, then open its page for exact inputs, output types and configuration choices. '
           '[How to configure actions](../../handbook/flow-configuration.md).']
    for group, items in groups.items():
        out += [f'## {group}', table(['Action', 'What it does'], [(f'[{title}]({family}.md)', desc)
                                                                 for family, title, desc in items])]
    write('reference/actions/index.md', '\n\n'.join(out))


def component_pages():
    contract = json.loads((ROOT / 'tests/contracts/component-api.json').read_text())['components']
    index = []
    for src in sorted((ROOT / 'force-app/main/default/lwc').glob('*/*js-meta.xml')):
        root = ET.parse(src).getroot()
        if root.findtext('m:isExposed', namespaces=NS) != 'true':
            continue
        name = src.parent.name
        label = root.findtext('m:masterLabel', namespaces=NS) or name
        targets = [v.text for v in root.findall('m:targets/m:target', NS)]
        index.append((f'[{label}]({name}.md)', f'`{name}`', ', '.join(targets) or 'Composition'))
        out = [f'# {label}', f'Component `{name}` · {VERSION} · {REFERENCE_STATUS}.',
               root.findtext('m:description', namespaces=NS) or '',
               'Targets: ' + (', '.join(f'`{t}`' for t in targets) or 'Composition in a parent LWC; no direct Builder target.') + '.',
               '[Component architecture](../../handbook/components.md) · '
               '[Screen setup](../../handbook/screen-configuration.md).']
        for config in root.findall('m:targetConfigs/m:targetConfig', NS):
            out.append('## ' + config.get('targets', 'Builder configuration'))
            if config.get('configurationEditor'): out.append('Configuration editor: `' + config.get('configurationEditor') + '`.')
            out.append(table(['Property', 'Label', 'Type', 'Direction', 'Default / required', 'Meaning'],
                             [(f'`{p.get("name")}`', p.get('label'), f'`{p.get("type")}`',
                               p.get('role', 'Input/output'),
                               ('Required; ' if p.get('required') == 'true' else '') + p.get('default', 'No metadata default'),
                               p.get('description') or p.get('datasource')) for p in config.findall('m:property', NS)]))
        out += ['## Public LWC members', 'These are the checked `@api` members. JavaScript defaults are separate from '
                'Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer '
                'is not a promise that every empty value is accepted.']
        member_rows = []
        for member in contract[name]['members']:
            default = member.get('default')
            if default is None: default_text = 'Not declared'
            elif 'value' in default: default_text = json.dumps(default['value'])
            elif default.get('type') == 'ArrayExpression': default_text = 'Array initializer'
            elif default.get('type') == 'ObjectExpression': default_text = 'Object initializer'
            else: default_text = default.get('type', 'Expression')
            member_rows.append((f'`{member["name"]}`', member['kind'], default_text))
        out.append(table(['Member', 'Kind', 'JS default'], member_rows))
        out.append('Generated from exposed component metadata and the checked LWC public-member inventory. '
                   'Custom events and validation behaviour are described in the component guide; metadata alone '
                   'does not describe event semantics or prove browser rendering.')
        write(f'reference/components/{name}.md', '\n\n'.join(v for v in out if v))
    write('reference/components/index.md', '# Component reference\n\n' +
          'Flow screens, the record-page adapter and exposed components for parent composition. '
          'Configuration editors and internal helpers are not independent end-user components.\n\n' +
          table(['Label / reference', 'Bundle', 'Target'], index))
    return len(index)


def main():
    inventory = api.inventory()
    expected = json.loads((ROOT / 'tests/contracts/global-api.json').read_text())
    assert inventory == expected, 'Source differs from reviewed API baseline; do not publish stale reference.'
    apex_pages(inventory)
    action_pages(inventory)
    components = component_pages()
    print(f'Generated {len(inventory)} Apex classes, 27 action families and {components} exposed components.')


if __name__ == '__main__':
    main()
