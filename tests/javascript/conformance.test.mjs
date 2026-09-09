// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import test from "node:test";
import assert from "node:assert/strict";
import { fixtures, evaluate } from "../conformance/client.mjs";
for (const fixture of fixtures) {
  test(`shared conformance: ${fixture.id}`, async () =>
    assert.deepEqual(await evaluate(fixture), fixture.expected));
}
