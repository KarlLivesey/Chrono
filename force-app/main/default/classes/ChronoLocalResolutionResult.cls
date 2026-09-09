// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoLocalResolutionResult {
  /** @description success component; absent optional values are null. */
  global Boolean success;
  /** @description errorMessage component; absent optional values are null. */
  global String errorMessage;
  /** @description resolutionStatus component; absent optional values are null. */
  global String resolutionStatus;
  /** @description value component; absent optional values are null. */
  global ChronoZonedDateTime value;
  /** @description earlierValue component; absent optional values are null. */
  global ChronoZonedDateTime earlierValue;
  /** @description laterValue component; absent optional values are null. */
  global ChronoZonedDateTime laterValue;
  /** @description previousValue component; absent optional values are null. */
  global ChronoZonedDateTime previousValue;
  /** @description nextValue component; absent optional values are null. */
  global ChronoZonedDateTime nextValue;
  /** @description Creates uninitialised data. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoLocalResolutionResult() {
  }
}
