#!/usr/bin/env python3
"""Generate declared Flow entry points and editor wrappers from catalogue.json.

Calculation implementations are maintained separately. Only the files declared
by the catalogue are written; existing core actions are never regenerated.
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'force-app/main/default'
CATALOGUE = json.loads((Path(__file__).with_name('catalogue.json')).read_text())
COPYRIGHT = '// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause\n'
META = '<?xml version="1.0" encoding="UTF-8"?>\n<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata"><apiVersion>67.0</apiVersion><status>Active</status></ApexClass>\n'


def write_class(name, body):
    (BASE / 'classes' / (name + '.cls')).write_text(COPYRIGHT + body)
    (BASE / 'classes' / (name + '.cls-meta.xml')).write_text(META)


def fields(items, aura=False):
    return '\n'.join(f"  /** @description {f['help']} */\n" + ('  @AuraEnabled\n' if aura else '') + f"  @InvocableVariable(label='{f['label']}' description='{f['help']}')\n  global {f['type']} {f['name']};" for f in items)


def generate(item):
    family, title, result = item['family'], item['title'], item['result']
    desc = item['description']
    inputs = item['fields']
    input_type = 'Chrono' + family + 'Input'
    prefix = f"/** @description {desc} */\n@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')\n"
    ctor = lambda name: f"  /** @description Required Flow constructor. */\n  @SuppressWarnings('PMD.EmptyStatementBlock')\n  global {name}() {{}}\n"
    write_class(input_type, prefix + f'global with sharing class {input_type} {{\n' + fields(inputs, True) + '\n' + ctor(input_type) + '}\n')
    for collection in (False, True):
        name = 'Chrono' + family + ('Collection' if collection else '') + 'Action'
        editor = 'chrono' + family + ('Collection' if collection else '') + 'Editor'
        slug = ''.join('-' + c.lower() if c.isupper() else c for c in editor)
        output = ('ChronoFlowCollectionResult' if result == 'ChronoFlowResult' else result.replace('Result', 'CollectionResult')) if collection else result
        request_fields = "  @InvocableVariable(label='Input collection' description='Ordered requests for this interview.')\n  global List<" + input_type + "> items;" if collection else fields(inputs)
        body = prefix + f'global with sharing class {name} {{\n  /** @description Inputs for one Flow interview. */\n  global class Request {{\n' + request_fields + '\n' + ctor('Request') + '  }\n'
        body += f"  /** @description {desc}\n   * @param requests One request per interview.\n   * @return Independent ordered results with per-item errors. */\n  @InvocableMethod(label='Chrono: {title}{' (collection)' if collection else ''}' description='{desc}' category='Chrono: {item['category']}' iconName='slds:standard:event' configurationEditor='skel-{slug}')\n  global static List<{output}> run(List<Request> requests) {{\n    List<{output}> results = new List<{output}>();\n    if (requests == null) {{ return results; }}\n    List<Object> flat = new List<Object>();\n"
        if collection:
            body += f'''    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {{
      if (request == null || request.items == null) {{ sizes.add(-1); continue; }}
      sizes.add(request.items.size());
      for ({input_type} item : request.items) {{ flat.add(item); }}
    }}
    List<Object> values = new ChronoCatalogueBatch('{family}').run(flat);
    Integer cursor = 0;
    for (Integer size : sizes) {{
      results.add(group(values,cursor,size));
      cursor+=Math.max(size,0);
    }}
'''
        else:
            body += f'    for (Request request : requests) {{ flat.add(copyInput(request)); }}\n' + f"    for (Object value : new ChronoCatalogueBatch('{family}').run(flat)) {{ results.add(({result}) value); }}\n"
        body += '    return results;\n  }\n'
        if not collection:
            body += f"  private static {input_type} copyInput(Request request) {{\n    if(request==null) {{ return null; }}\n    {input_type} item=new {input_type}();\n" + ''.join(f"    item.{f['name']}=request.{f['name']};\n" for f in inputs) + "    return item;\n  }\n"
        if collection:
            body += f"""  private static {output} group(List<Object> values,Integer cursor,Integer size) {{
    {output} grouped=new {output}();
    grouped.success=size>=0;
    if(size<0) {{ grouped.errorMessage='Provide an input collection; empty collections are allowed.'; }}
    for(Integer i=0;i<size;i++) {{
      {result} value=({result})values[cursor+i];
      grouped.results.add(value);
      if(!value.success) {{ grouped.success=false; grouped.errorMessage='One or more items failed. Inspect the item results.'; }}
    }}
    return grouped;
  }}
"""
        write_class(name, body + '}\n')
        folder = BASE / 'lwc' / editor
        folder.mkdir(exist_ok=True)
        template = (BASE / 'lwc/chronoRoundEditor/chronoRoundEditor.js').read_text().replace('c-chrono-flow-action-editor', 'c-chrono-catalogue-editor')
        (folder / (editor + '.js')).write_text(template)
        (folder / (editor + '.html')).write_text(f'<template><c-chrono-catalogue-editor kind="{family}"' + (' collection' if collection else '') + ' input-variables={inputVariables} builder-context={builderContext} automatic-output-variables={automaticOutputVariables} element-info={elementInfo}></c-chrono-catalogue-editor></template>\n')
        (folder / (editor + '.js-meta.xml')).write_text((BASE / 'lwc/chronoRoundEditor/chronoRoundEditor.js-meta.xml').read_text())
        from xml.sax.saxutils import escape
        targets = []
        for order, f in enumerate(([{'name': 'items', 'group': 'Requests'}] if collection else inputs), 1):
            targets.append(f"<targets><targetType>ActionParameter</targetType><targetName>{name}.Request.{f['name']}</targetName><attributes><key>Order</key><dataType>Integer</dataType><value>{order}</value></attributes><attributes><key>Group</key><dataType>String</dataType><value>{escape(f.get('group','Configuration'))}</value></attributes></targets>")
        (BASE / 'invocableactionextensions' / (name + '.invocableactionextension-meta.xml')).write_text('<?xml version="1.0" encoding="UTF-8"?>\n<InvocableActionExtension xmlns="http://soap.sforce.com/2006/04/metadata">' + ''.join(targets) + '</InvocableActionExtension>\n')
    if result != 'ChronoFlowResult':
        name = result.replace('Result', 'CollectionResult')
        write_class(name, prefix + f'''global with sharing class {name} {{
  @AuraEnabled @InvocableVariable(label='Success') global Boolean success;
  @AuraEnabled @InvocableVariable(label='Error') global String errorMessage;
  @AuraEnabled @InvocableVariable(label='Results') global List<{result}> results = new List<{result}>();
''' + ctor(name) + '}\n')


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--family', action='append', help='Generate only the named action families; schema still includes all families.')
args = parser.parse_args()
if args.family and set(args.family) - {item['family'] for item in CATALOGUE}:
    parser.error('Unknown action family')
for item in CATALOGUE:
    if not args.family or item['family'] in args.family:
        generate(item)
# Export the same labelled field contract to the reusable configuration editor.
folder = BASE / 'lwc/chronoCatalogueSchema'
folder.mkdir(exist_ok=True)
(folder / 'chronoCatalogueSchema.js').write_text(COPYRIGHT + 'export default ' + json.dumps(CATALOGUE, indent=2) + ';\n')
(folder / 'chronoCatalogueSchema.js-meta.xml').write_text((BASE / 'lwc/chronoRoundEditor/chronoRoundEditor.js-meta.xml').read_text())
# Read XML rather than matching formatted text so regeneration cannot duplicate access entries.
import xml.etree.ElementTree as ET


def update_class_access():
    ns = 'http://soap.sforce.com/2006/04/metadata'
    ET.register_namespace('', ns)
    target = BASE / 'permissionsets/ChronoFlowUser.permissionset-meta.xml'
    root = ET.fromstring(target.read_text())
    existing = {}
    for access in root.findall('{' + ns + '}classAccesses'):
        name = access.find('{' + ns + '}apexClass').text
        enabled = access.find('{' + ns + '}enabled').text
        if name in existing:
            if existing[name] != enabled:
                raise ValueError('Conflicting class access for ' + name)
            root.remove(access)
        else:
            existing[name] = enabled
    for item in CATALOGUE:
        for suffix in ('Action', 'CollectionAction'):
            name = 'Chrono' + item['family'] + suffix
            if name in existing:
                continue
            access = ET.Element('{' + ns + '}classAccesses')
            ET.SubElement(access, '{' + ns + '}apexClass').text = name
            ET.SubElement(access, '{' + ns + '}enabled').text = 'true'
            root.insert(0, access)
            existing[name] = 'true'
    for node in root.iter():
        if node.text is not None and not node.text.strip():
            node.text = None
        node.tail = None
    ET.indent(root, space='  ')
    ET.ElementTree(root).write(target, encoding='UTF-8', xml_declaration=True)


update_class_access()
