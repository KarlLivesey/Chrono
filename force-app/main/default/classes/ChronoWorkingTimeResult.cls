// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only outcome for one bulk working-time request. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoWorkingTimeResult {
  /** @description True when the corresponding request succeeded. */
  global Boolean success;
  /** @description Failure diagnostic; null on success. */
  global String errorMessage;
  /** @description Independent zoned result; null on failure. */
  global ChronoZonedDateTime value;
  /** @description Creates an uninitialised result. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoWorkingTimeResult() {
  }
}
