"""Keep Apex batch entry points independent of Flow and UI adapters."""
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CLASSES = ROOT / 'force-app/main/default/classes'


class BulkServiceBoundaries(unittest.TestCase):
    def test_all_calculation_actions_use_shared_services(self):
        families = json.loads((ROOT / 'tests/contracts/bulk-services.json').read_text())
        actual = {
            p.stem.removeprefix('Chrono').removesuffix('Action')
            for p in CLASSES.glob('*Action.cls')
            if not p.stem.endswith('CollectionAction') and '@InvocableMethod' in p.read_text()
        }
        self.assertEqual(set(families), actual, 'Every action family needs a reviewed service route')
        adapters = {'WorkingTime': ('ChronoFlowWorking', 'add'), 'TimeAllocation': ('ChronoFlowAllocation', 'allocate')}
        for family, (service, method) in families.items():
            route, route_method = adapters.get(family, (service, method))
            if family in adapters:
                adapter = (CLASSES / f'{route}.cls').read_text()
                self.assertRegex(adapter, rf'\b{service}\s*\.\s*{method}\s*\(')
            for suffix in ('Action', 'CollectionAction'):
                with self.subTest(family=family, suffix=suffix):
                    source = (CLASSES / f'Chrono{family}{suffix}.cls').read_text()
                    self.assertRegex(source, rf'\b{route}\s*\.\s*{route_method}\s*\(')
                    self.assertNotRegex(source, r'new\s+Chrono(?:Flow|Catalogue)Batch\s*\(')

    def test_service_facades_only_forward_to_implementations(self):
        families = json.loads((ROOT / 'tests/contracts/bulk-services.json').read_text())
        services = {pair[0] for pair in families.values()}
        services.update({'ChronoTimeAllocationService', 'ChronoWorkingTimeService'})
        for service in services:
            source = (CLASSES / f'{service}.cls').read_text()
            with self.subTest(service=service):
                self.assertNotIn('ChronoFlowResult', source)
                methods = re.findall(r'global static List<\w+>\s+\w+\([^)]*\)\s*\{([^}]+)\}', source)
                self.assertTrue(methods)
                for body in methods:
                    self.assertRegex(body.strip(), r'^return Chrono\w+Operations\.\w+\(requests\);$')

    def test_shared_calculations_do_not_call_flow_or_ui_entry_points(self):
        for src in CLASSES.glob('*.cls'):
            if src.stem.endswith(('Action', 'Test', 'Controller')):
                continue
            with self.subTest(source=src.stem):
                self.assertNotRegex(src.read_text(), r'\bChrono\w+Action\.run\s*\(')
                self.assertNotRegex(src.read_text(), r'\bChrono\w*Controller\.\w+\s*\(')
                self.assertNotRegex(src.read_text(), r'\bFlow\.Interview\b')
        self.assertIn('ChronoWorkingTimeService.add', (CLASSES / 'ChronoFlowWorking.cls').read_text())
        self.assertIn('ChronoTimeAllocationService.allocateAll', (CLASSES / 'ChronoFlowAllocation.cls').read_text())


    def test_every_global_service_has_a_boundary_guard(self):
        families = json.loads((ROOT / 'tests/contracts/bulk-services.json').read_text())
        core = json.loads((ROOT / 'tests/contracts/core-services.json').read_text())
        covered = set(core) | {pair[0] for pair in families.values()}
        actual = {p.stem for p in CLASSES.glob('*Service.cls') if 'global with sharing class' in p.read_text()}
        self.assertEqual(actual, covered, 'New global services need an explicit boundary and coverage review')
