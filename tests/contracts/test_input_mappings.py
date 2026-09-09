"""Fail when a shared input field is added or renamed without updating its typed adapter."""
import re
import unittest
from pathlib import Path

CLASSES = Path(__file__).resolve().parents[2] / 'force-app/main/default/classes'


def fields(name):
    return set(re.findall(r'  (?:public|global) [\w<> ,]+ (\w+);', (CLASSES / (name + '.cls')).read_text()))


class InputMappingTest(unittest.TestCase):
    def test_shared_fields_have_explicit_assignments(self):
        count = 0
        for name in ['ChronoValueInputs', 'ChronoRangeInputs']:
            source = (CLASSES / (name + '.cls')).read_text()
            for match in re.finditer(r'public static (\w+) (\w+)\(\s*(\w+) input\s*\)\s*\{([^}]+)\}', source):
                dest, method, src, body = match.groups()
                expected = fields(src) & fields(dest)
                if method == 'source':
                    # These adapters preserve the common value projection; formatting
                    # reference fields belong to formatting, not source construction.
                    expected &= fields('ChronoValueFields')
                copies = re.findall(r'result\.(\w+) = input\.(\w+);', body)
                self.assertEqual(expected, {left for left, right in copies}, src)
                self.assertTrue(all(left == right for left, right in copies), src)
                self.assertNotIn('JSON.', body)
                count += 1
        self.assertEqual(15, count)

    def test_working_schedule_fields_reach_scalar_and_collection_adapters(self):
        mapping = (CLASSES / 'ChronoOperationInputs.cls').read_text()
        for family in ['WorkingTime', 'Difference', 'CheckWorkingTime', 'FindWorkingTime']:
            request = 'Chrono' + family + 'Action.Request'
            match = re.search(r'public static \w+ adapt\(\s*' + re.escape(request) + r' source\s*\) \{(.*?)\n  \}', mapping, re.S)
            self.assertIsNotNone(match, request)
            # Every public input must survive adaptation, even optional native records.
            used = set(re.findall(r'source\.(\w+)', match[1]))
            self.assertEqual(fields('Chrono' + family + 'Input'), used, request)
            if family in ['CheckWorkingTime', 'FindWorkingTime']:
                action = (CLASSES / ('Chrono' + family + 'Action.cls')).read_text()
                copies = set(re.findall(r'item\.(\w+) = request\.\w+;', action))
                self.assertEqual(fields('Chrono' + family + 'Input'), copies, family)

    def test_extension_targets_are_unique(self):
        import xml.etree.ElementTree as ET
        seen = set()
        for src in (CLASSES.parent / 'invocableactionextensions').glob('*.xml'):
            tree = ET.parse(src)
            for target in tree.findall('.//{*}targetName'):
                name = target.text.strip()
                self.assertNotIn(name, seen, src.name + ': ' + name)
                seen.add(name)
