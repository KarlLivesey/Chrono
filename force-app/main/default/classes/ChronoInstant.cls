// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoInstantService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoInstant {
  /** @description value component; validated by the service. */
  global Datetime value;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoInstant() {
  }
}
