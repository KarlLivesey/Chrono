// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoPlainYearMonthService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainYearMonth {
  /** @description Year component; validated by the service. */
  global Integer year;
  /** @description Month component; validated by the service. */
  global Integer month;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoPlainYearMonth() {
  }
}
