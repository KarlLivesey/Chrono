"""Create a deterministic demo archive, excluding tests and retired feasibility Flows."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import xml.etree.ElementTree as ET
import json

ROOT = Path(__file__).resolve().parents[2]
DEST = ROOT / '.docs-site/downloads'
SITE_CONFIG = json.loads((ROOT / 'docs/site.json').read_text())
RELEASE_VERSION = SITE_CONFIG['version']
RELEASE_PACKAGE_ID = SITE_CONFIG['packageVersionId']
DEST.mkdir(parents=True, exist_ok=True)
flows = sorted((ROOT / 'tests/subscriber/force-app/main/default/flows').glob('ChronoExample*.flow-meta.xml'))
assert len(flows) == 13, 'Review the example inventory before publishing a changed bundle.'
namespace = 'http://soap.sforce.com/2006/04/metadata'
ET.register_namespace('', namespace)
package = ET.Element('{' + namespace + '}Package')
types = ET.SubElement(package, '{' + namespace + '}types')
files = {}
for src in flows:
    name = src.name.removesuffix('.flow-meta.xml')
    ET.SubElement(types, '{' + namespace + '}members').text = name
    files[f'chrono-examples/metadata/flows/{name}.flow'] = src.read_bytes()
ET.SubElement(types, '{' + namespace + '}name').text = 'Flow'
ET.SubElement(package, '{' + namespace + '}version').text = '67.0'
files['chrono-examples/metadata/package.xml'] = ET.tostring(package, encoding='utf-8', xml_declaration=True)
for name in ['seed-example-holiday.apex', 'seed-example-hours.apex']:
    files['chrono-examples/scripts/' + name] = (ROOT / 'tests/subscriber/scripts' / name).read_bytes()
files['chrono-examples/README.txt'] = f'''Chrono {RELEASE_VERSION} examples

Install {RELEASE_PACKAGE_ID} first and assign Chrono Flow User.
From the directory containing chrono-examples, deploy:
sf project deploy start --metadata-dir chrono-examples/metadata --target-org your-org --wait 20

Optional saved demo data (test org only; these perform DML):
sf apex run --target-org your-org --file chrono-examples/scripts/seed-example-holiday.apex
sf apex run --target-org your-org --file chrono-examples/scripts/seed-example-hours.apex

Run the two scripts in separate transactions. Open Setup > Flows, search Chrono,
then Debug an example or inspect its actions in Flow Builder.
'''.encode()
target = DEST / f'chrono-examples-{RELEASE_VERSION}.zip'
with ZipFile(target, 'w') as archive:
    for name, data in sorted(files.items()):
        info = ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
        info.compress_type = ZIP_DEFLATED
        info.external_attr = 0o100644 << 16
        archive.writestr(info, data)
with ZipFile(target) as archive:
    assert archive.testzip() is None
print('Packaged 13 example Flows, manifest and two optional seed scripts.')
