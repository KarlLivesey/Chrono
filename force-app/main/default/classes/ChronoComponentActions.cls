// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Read-only component endpoints sharing the Flow action engines and native record contracts. */
public with sharing class ChronoComponentActions {
  @AuraEnabled
  public static ChronoAvailabilityResult availability(
    ChronoAvailabilityInput input
  ) {
    return (ChronoAvailabilityResult) new ChronoCatalogueBatch('Availability')
      .run(new List<Object>{ input })[0];
  }
  @AuraEnabled
  public static ChronoRecurrenceResult recurrence(ChronoRecurrenceInput input) {
    return (ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
      .run(new List<Object>{ input })[0];
  }
}
