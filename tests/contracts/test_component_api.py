"""Mutation tests for externally visible LWC, Flow and Apex transport contracts."""
import importlib.util
import unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location('component_api', Path(__file__).resolve().parents[2] / 'scripts/check-component-api.py')
guard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(guard)


class ComponentApiTest(unittest.TestCase):
    def test_metadata_types_roles_defaults_and_targets_are_detected(self):
        original = '<LightningComponentBundle><targets><target>lightning__FlowScreen</target></targets><targetConfigs><targetConfig targets="lightning__FlowScreen"><property name="value" type="String" role="inputOnly" default="x"/></targetConfig></targetConfigs></LightningComponentBundle>'
        for before, after in [('String', 'Date'), ('inputOnly', 'outputOnly'), ('default="x"', 'default="y"'), ('lightning__FlowScreen', 'lightning__RecordPage')]:
            self.assertNotEqual(guard.metadata(original), guard.metadata(original.replace(before, after)))
        self.assertEqual(guard.metadata(original), guard.metadata(original.replace('><', '>\n  <')))

    def test_public_members_accessors_and_defaults_are_detected(self):
        original = "import {LightningElement, api} from 'lwc'; export default class Picker extends LightningElement { @api value = 'x'; @api get mode() { return this._mode; } set mode(value) { this._mode = value; } @api validate(input) { return true; } privateValue = 1; }"
        sources = {'original': original, 'body': original.replace('return true;', 'return false;').replace('privateValue = 1', 'privateValue = 2')}
        changes = [('value = \'x\'', 'value = \'y\''), ('@api value', 'value'), ('validate(input)', 'validate(input, options)'), ('set mode(value) { this._mode = value; }', '')]
        for index, (before, after) in enumerate(changes):
            sources[str(index)] = original.replace(before, after)
        contracts = guard.lwc_contracts(sources)
        self.assertEqual(contracts['original'], contracts['body'])
        for index in range(len(changes)):
            self.assertNotEqual(contracts['original'], contracts[str(index)])

    def test_aura_overloads_are_rejected_but_native_overloads_are_allowed(self):
        original = 'public class X {@AuraEnabled public static String read(String input) {return input;} public static String read(Integer input) {return null;} }'
        self.assertEqual(2, len(guard.aura_contracts(original)))
        with self.assertRaisesRegex(ValueError, 'Do not overload'):
            guard.aura_contracts(original.replace('public static String read(Integer', '@AuraEnabled public static String read(Integer'))

    def test_aura_property_setters_are_protected(self):
        original = 'public class X {@AuraEnabled public String value {get;set;}}'
        self.assertNotEqual(guard.aura_contracts(original), guard.aura_contracts(original.replace('set;', 'private set;')))

    def test_aura_controller_sharing_mode_is_protected(self):
        original = 'public with sharing class X {@AuraEnabled public static String read() {return null;}}'
        self.assertNotEqual(guard.aura_contracts(original), guard.aura_contracts(original.replace('with sharing', 'without sharing')))
