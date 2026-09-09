// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoDurationCalculationResult {
  /** @description success component; absent optional values are null. */
  global Boolean success;
  /** @description errorMessage component; absent optional values are null. */
  global String errorMessage;
  /** @description value component; absent optional values are null. */
  global ChronoDuration value;
  /** @description Creates uninitialised data. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoDurationCalculationResult() {
  }
}
