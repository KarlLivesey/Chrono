"""Validate every built page, local link, fragment, asset and reference inventory."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit
import json
import re
import zipfile

ROOT = Path(__file__).resolve().parents[2]
SITE = ROOT / '.docs-site'


class Page(HTMLParser):
    def __init__(self, text):
        super().__init__(convert_charrefs=True)
        self.ids = set()
        self.links = []
        self.errors = []
        self.h1 = self.main = 0
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs:
            if attrs['id'] in self.ids: self.errors.append('Duplicate id: ' + attrs['id'])
            self.ids.add(attrs['id'])
        if tag == 'h1': self.h1 += 1
        if tag == 'main': self.main += 1
        if tag == 'img' and 'alt' not in attrs: self.errors.append('Image has no alt attribute')
        if tag in ('a', 'link') and attrs.get('href'): self.links.append(attrs['href'])
        if tag in ('script', 'img') and attrs.get('src'): self.links.append(attrs['src'])


pages = {p.resolve(): Page(p.read_text()) for p in SITE.rglob('*.html')}
errors = []
links = 0
for file, page in pages.items():
    errors += [str(file.relative_to(SITE)) + ': ' + e for e in page.errors]
    if page.h1 != 1 or page.main != 1: errors.append(str(file) + ': expected one h1 and main')
    for href in page.links:
        url = urlsplit(href)
        if url.scheme or url.netloc: continue
        links += 1
        target = (file.parent / unquote(url.path)).resolve() if url.path else file
        if not target.is_relative_to(SITE):
            errors.append(f'{file.name}: link escapes site: {href}'); continue
        if not target.exists():
            errors.append(f'{file.relative_to(SITE)}: missing {href}'); continue
        if url.fragment and target in pages and unquote(url.fragment) not in pages[target].ids:
            errors.append(f'{file.relative_to(SITE)}: missing anchor {href}')
assert not errors, '\n'.join(errors)
inventory = json.loads((ROOT / 'tests/contracts/global-api.json').read_text())
assert len(list((SITE / 'reference/apex').glob('*.html'))) == len(inventory) + 1
assert len(list((SITE / 'reference/actions').glob('*.html'))) == 28
assert len(list((SITE / 'reference/components').glob('*.html'))) == 19
search = json.loads((SITE / 'search-index.json').read_text())
assert len(search) == len(pages) - 2
assert all((SITE / p['url']).is_file() for p in search)
with zipfile.ZipFile(SITE / 'downloads/chrono-examples-0.1.0.19.zip') as archive:
    assert archive.testzip() is None
    assert len([n for n in archive.namelist() if n.endswith('.flow')]) == 13
    assert all('..' not in Path(n).parts for n in archive.namelist())
css = (SITE / 'assets/site.css').read_text()
assert not re.search(r'#[0-9a-f]*[^\x00-\x7f]', css, re.I), 'Invalid colour literal'
print(f'Checked {len(pages)} HTML pages, {links} local links/assets/fragments, all reference inventories and example ZIP.')
