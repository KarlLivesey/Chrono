// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoZonedDateTimeService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoZonedDateTime {
  /** @description instant component; validated by the service. */
  global Datetime instant;
  /** @description timeZoneId component; validated by the service. */
  global String timeZoneId;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoZonedDateTime() {
  }
}
