// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoPlainMonthDayService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainMonthDay {
  /** @description Month component; validated by the service. */
  global Integer month;
  /** @description Day component; validated by the service. */
  global Integer day;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoPlainMonthDay() {
  }
}
