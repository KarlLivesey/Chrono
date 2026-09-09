"""Regression tests for API guard coverage, independent of the live baseline."""
import importlib.util
import unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location('global_api', Path(__file__).resolve().parents[2] / 'scripts/check-global-api.py')
guard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(guard)


class GlobalApiGuardTest(unittest.TestCase):
    source = """@SuppressWarnings('Example') global class Contract {
      @AuraEnabled @InvocableVariable(label='Label') global String value;
      global Contract() {}
      global static String read(String input) { return 'global fake;'; }
      global class Request { @InvocableVariable global Integer count; }
    }"""

    def test_nested_fields_and_constructors_are_included(self):
        rows = guard.declarations(self.source)
        self.assertEqual(['type', 'field', 'method', 'method', 'type', 'field'], [row['kind'] for row in rows])
        self.assertEqual('Contract.Request', rows[-1]['owner'])
        self.assertIn("label = 'Label'", rows[1]['declaration'])

    def test_contract_mutations_are_detected(self):
        original = guard.declarations(self.source)
        for before, after in [('global String value', 'global Integer value'), ('label=\'Label\'', 'label=\'Other\''), ('global static', 'global'), ('read(String input)', 'read(String input, Boolean flag)'), ('global class Request', 'public class Request'), ('global Contract()', 'global Contract(String input)')]:
            with self.subTest(before=before):
                self.assertNotEqual(original, guard.declarations(self.source.replace(before, after)))

    def test_annotation_attributes_survive_field_initializers(self):
        source = "global class Example { @InvocableVariable(label='Mode') global List<String> mode = new List<String>(); }"
        field = guard.declarations(source)[1]
        self.assertEqual('field', field['kind'])
        self.assertIn("label = 'Mode'", field['declaration'])
        self.assertTrue(field['declaration'].endswith('global List < String > mode'))

    def test_property_access_is_contract_but_accessor_bodies_are_not(self):
        source = 'global class X { global String value { get; set; } }'
        changed = source.replace('set;', 'private set;')
        self.assertNotEqual(guard.declarations(source), guard.declarations(changed))
        self.assertNotEqual(guard.declarations(source), guard.declarations(source.replace('{ get; set; }', ';')))
        self.assertEqual(guard.declarations(source), guard.declarations(source.replace('get;', "get {return 'x';}")))

    def test_enum_members_and_implicit_interface_methods_are_contract(self):
        for source, changed in [
            ('global enum X { First, Second }', 'global enum X { First }'),
            ('global interface X { String read(String input); }', 'global interface X { Integer read(Integer input); }'),
            ('global class X { global enum Mode { First, Second } global String next; }', 'global class X { global enum Mode { First } global String next; }')
        ]:
            self.assertNotEqual(guard.declarations(source), guard.declarations(changed))
        rows = guard.declarations('global class X { global enum Mode { First } global String next; }')
        self.assertEqual('X', rows[-1]['owner'])

    def test_initialiser_braces_are_not_property_accessors(self):
        rows = guard.declarations("global class X {global List<String> values = new List<String>{'a'}; global String next;}")
        self.assertEqual(['type', 'field', 'field'], [row['kind'] for row in rows])

    def test_aura_contracts_include_public_endpoints_and_dto_properties(self):
        rows = guard.declarations('public class X {@AuraEnabled public String value {get;set;} @AuraEnabled(cacheable=true) public static String read(String input) {return input;} }', include_aura=True)
        self.assertEqual(['type', 'property', 'method'], [row['kind'] for row in rows])
        self.assertEqual([], guard.declarations('public class X {public String hidden;}'))

    def test_method_bodies_and_comments_are_not_contract(self):
        altered = self.source.replace("return 'global fake;';", "// global Nope;\n return input;")
        self.assertEqual(guard.declarations(self.source), guard.declarations(altered))


if __name__ == '__main__':
    unittest.main()
