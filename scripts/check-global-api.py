"""Snapshot the complete global Apex declaration surface, excluding method bodies.

An intentional contract migration uses --update after API review. Routine checks
must never rewrite the baseline. Annotations and modifiers are part of the API.
"""
import argparse
import difflib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASELINE = ROOT / 'tests/contracts/global-api.json'
TOKEN = re.compile(r"//[^\n]*|/\*[\s\S]*?\*/|'(?:\\.|[^'\\])*'|[A-Za-z_$][\w$]*|\d+|[^\s]")


def declarations(source, include_aura=False):
    """Read declarations, including implicit interface members and property accessors."""
    tokens = [m[0] for m in TOKEN.finditer(source) if not m[0].startswith(('//', '/*'))]
    result = []

    def block_end(start):
        depth = 1
        cursor = start + 1
        while cursor < len(tokens) and depth:
            depth += (tokens[cursor] == '{') - (tokens[cursor] == '}')
            cursor += 1
        if depth:
            raise ValueError('Unclosed Apex declaration body')
        return cursor

    def accessors(start, end):
        items, pending = [], []
        cursor = start + 1
        while cursor < end - 1:
            token = tokens[cursor]
            if token in (';', '{'):
                if not pending or pending[-1] not in ('get', 'set'):
                    raise ValueError('Unrecognised Apex property accessor')
                items.append(' '.join(pending))
                pending = []
                if token == '{':
                    cursor = block_end(cursor)
                    continue
            else:
                pending.append(token)
            cursor += 1
        return sorted(items)

    def walk(start, end, scopes, interface=False):
        pending, parens = [], 0
        cursor = start
        while cursor < end:
            token = tokens[cursor]
            parens += (token == '(') - (token == ')')
            if token not in ('{', ';') or parens:
                pending.append(token)
                cursor += 1
                continue
            contract = without_initializer(pending)
            plain = strip_annotations(contract)
            type_index = next((n for n, t in enumerate(contract) if t in ('class', 'interface', 'enum')), None)
            kind = 'type' if type_index is not None else ('method' if '(' in plain else 'field')
            exposed = 'global' in contract or (interface and kind == 'method') or (include_aura and ('AuraEnabled' in contract or kind == 'type'))
            row = {'owner': '.'.join(scopes), 'kind': kind, 'declaration': ' '.join(contract)}
            stop = block_end(cursor) if token == '{' else cursor + 1
            if type_index is not None:
                type_kind, name = contract[type_index:type_index + 2]
                if exposed:
                    result.append(row)
                if type_kind == 'enum':
                    if exposed:
                        members = tokens[cursor + 1:stop - 1]
                        for member in members:
                            if member != ',':
                                result.append({'owner': '.'.join(scopes + [name]), 'kind': 'enumMember', 'declaration': member})
                else:
                    walk(cursor + 1, stop - 1, scopes + [name], type_kind == 'interface' and exposed)
            elif exposed:
                if kind == 'field' and token == '{' and len(contract) == len(pending):
                    row['kind'] = 'property'
                    row['accessors'] = accessors(cursor, stop)
                result.append(row)
            pending = []
            cursor = stop

    walk(0, len(tokens), [])
    return result



def without_initializer(tokens):
    """Exclude field initializers without mistaking annotation attributes for them."""
    depth = 0
    for index, token in enumerate(tokens):
        depth += (token == '(') - (token == ')')
        if token == '=' and depth == 0:
            return tokens[:index]
    return tokens


def strip_annotations(tokens):
    """Remove annotation argument parentheses before distinguishing fields/methods."""
    output = []
    i = 0
    while i < len(tokens):
        if tokens[i] != '@':
            output.append(tokens[i])
            i += 1
            continue
        i += 2
        if i < len(tokens) and tokens[i] == '(':
            depth = 1
            i += 1
            while depth:
                depth += (tokens[i] == '(') - (tokens[i] == ')')
                i += 1
    return output


def inventory():
    result = {}
    for src in sorted((ROOT / 'force-app/main/default/classes').glob('*.cls')):
        found = declarations(src.read_text())
        if found:
            result[src.stem] = found
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--update', action='store_true', help='Record an explicitly reviewed contract change')
    args = parser.parse_args()
    current = json.dumps(inventory(), indent=2) + '\n'
    if args.update:
        BASELINE.write_text(current)
    elif current != BASELINE.read_text():
        diff = ''.join(difflib.unified_diff(BASELINE.read_text().splitlines(True), current.splitlines(True), fromfile='reviewed global API', tofile='current global API'))
        raise SystemExit('Global API changed; review compatibility before updating the baseline.\n' + diff)
    count = sum(len(items) for items in json.loads(current).values())
    print(f'Verified {count} global declarations, including annotations, modifiers and nested types.')


if __name__ == '__main__':
    main()
