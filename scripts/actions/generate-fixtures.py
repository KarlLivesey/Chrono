#!/usr/bin/env python3
"""Generate subscriber-owned scalar/collection Flow harnesses for the declared actions."""
import argparse,json,re
from pathlib import Path
from xml.etree import ElementTree as E
ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'tests/subscriber/force-app/main/default/flows'
NS='http://soap.sforce.com/2006/04/metadata';E.register_namespace('',NS)
def node(parent,name,text=None):
 child=E.SubElement(parent,'{'+NS+'}'+name)
 if text is not None:child.text=str(text)
 return child
def variable(root,name,typ,incoming):
 collection=typ.startswith('List<');typ=typ[5:-1] if collection else typ
 primitive={'String':'String','Integer':'Number','Decimal':'Number','Long':'Number','Date':'Date','Datetime':'DateTime','Boolean':'Boolean'}
 var=node(root,'variables');node(var,'name',name)
 if typ.startswith('Chrono'):node(var,'apexClass','skel__'+typ)
 node(var,'dataType',primitive.get(typ,'Apex' if typ.startswith('Chrono') else 'SObject'))
 node(var,'isCollection',str(collection).lower());node(var,'isInput',str(incoming).lower());node(var,'isOutput',str(not incoming).lower())
 if typ not in primitive and not typ.startswith('Chrono'):node(var,'objectType',typ)
 if primitive.get(typ)=='Number':node(var,'scale',9 if typ=='Decimal' else 0)
def result_fields(name):
 text=(ROOT/'force-app/main/default/classes'/(name+'.cls')).read_text()
 return [(m.group(2),m.group(1)) for m in re.finditer(r'global\s+(List<\w+>|String|Boolean|Integer|Long|Decimal|Date|Datetime)\s+(\w+)\s*[;=]',text)]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--family',action='append')
args=parser.parse_args()
items=json.loads((ROOT/'scripts/actions/catalogue.json').read_text())
if args.family and set(args.family)-{item['family'] for item in items}:parser.error('Unknown action family')
for item in items:
 if args.family and item['family'] not in args.family:continue
 for collection in [False,True]:
  family=item['family'];stem='Chrono'+family+('Collection' if collection else '')+'Harness'
  action='Chrono'+family+('Collection' if collection else '')+'Action'
  inputs=[('items','List<Chrono'+family+'Input>')] if collection else [(f['name'],f['type']) for f in item['fields']]
  outputs=[('success','Boolean'),('errorMessage','String'),('results','List<'+item['result']+'>')] if collection else result_fields(item['result'])
  root=E.Element('{'+NS+'}Flow');call=node(root,'actionCalls');node(call,'name','RunChrono');node(call,'label',item['title']);node(call,'locationX',0);node(call,'locationY',0);node(call,'actionName','skel__'+action);node(call,'actionType','apex');node(call,'flowTransactionModel','CurrentTransaction')
  for name,typ in inputs:
   param=node(call,'inputParameters');node(param,'name',name);node(node(param,'value'),'elementReference',name)
  for name,typ in outputs:
   param=node(call,'outputParameters');node(param,'assignToReference','output_'+name);node(param,'name',name)
  node(root,'apiVersion','67.0');node(root,'interviewLabel',stem+' {!$Flow.CurrentDateTime}');node(root,'label','Chrono test: '+item['title']+(' collection' if collection else ''));node(root,'processType','AutoLaunchedFlow');start=node(root,'start');node(start,'locationX',0);node(start,'locationY',0);node(node(start,'connector'),'targetReference','RunChrono');node(root,'status','Active')
  for name,typ in inputs:variable(root,name,typ,True)
  for name,typ in outputs:variable(root,'output_'+name,typ,False)
  E.indent(root);E.ElementTree(root).write(BASE/(stem+'.flow-meta.xml'),encoding='UTF-8',xml_declaration=True)
