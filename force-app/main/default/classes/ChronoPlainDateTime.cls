// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoPlainDateTimeService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainDateTime {
  /** @description localDate component; validated by the service. */
  global Date localDate;
  /** @description localTime component; validated by the service. */
  global Time localTime;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoPlainDateTime() {
  }
}
