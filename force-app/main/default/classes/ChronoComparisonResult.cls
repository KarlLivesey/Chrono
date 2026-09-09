// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoComparisonResult {
  /** @description success component; absent optional values are null. */
  global Boolean success;
  /** @description errorMessage component; absent optional values are null. */
  global String errorMessage;
  /** @description comparison component; absent optional values are null. */
  global Integer comparison;
  /** @description withinTolerance component; absent optional values are null. */
  global Boolean withinTolerance;
  /** @description samePeriod component; absent optional values are null. */
  global Boolean samePeriod;
  /** @description Creates uninitialised data. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoComparisonResult() {
  }
}
