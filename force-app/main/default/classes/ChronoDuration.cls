// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only value. Use ChronoDurationService for construction, validation and operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoDuration {
  /** @description months component; validated by the service. */
  global Integer months;
  /** @description days component; validated by the service. */
  global Integer days;
  /** @description milliseconds component; validated by the service. */
  global Long milliseconds;
  /** @description Creates uninitialised data for explicit field assignment. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // A data-only value intentionally has no constructor logic.
  global ChronoDuration() {
  }
}
