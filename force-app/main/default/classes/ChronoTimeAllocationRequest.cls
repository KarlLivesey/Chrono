// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationRequest {
  global Datetime startInstant;
  global Datetime endInstant;
  global String timeZoneId;
  global List<ChronoTimeBlock> blocks;
  global List<Holiday> holidays;
  global String overlapMode;
  global String timeBasis;
  global String allocationUnit;
  global Integer maximumSegments;
  /** @description Empty data constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeAllocationRequest() {
  }
}
