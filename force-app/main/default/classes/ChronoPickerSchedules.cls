// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Read-only LWC bridge for saved and Flow-supplied operating hours. */
public with sharing class ChronoPickerSchedules {
  /** @description Searches accessible schedules using an optional ID allowlist and structured filter.
   * @param searchTerm A literal name fragment.
   * @param allowedIds Optional allowed record IDs.
   * @param filterJSON Optional JSON criteria on Name or TimeZone, combined with AND.
   * @param useIdFilter Explicit false allows all readable IDs; otherwise a missing/empty list denies all.
   * @return Up to 50 schedules; narrow the search for additional matches.
   */
  // Primitive bridge parameters avoid a wrapper and preserve Aura allowlist semantics.
  @SuppressWarnings(
    'PMD.ExcessiveParameterList, PMD.AvoidBooleanMethodParameters'
  )
  @AuraEnabled(cacheable=true)
  public static List<ChronoPickerScheduleChoice> searchHours(
    String searchTerm,
    List<Id> allowedIds,
    String filterJSON,
    Boolean useIdFilter
  ) {
    List<ChronoPickerScheduleChoice> result = new List<ChronoPickerScheduleChoice>();
    for (
      OperatingHours hours : new ChronoPickerScheduleQuery(
          filterIds(allowedIds, useIdFilter),
          filterJSON
        )
        .selectHours(searchTerm, null)
    ) {
      result.add(new ChronoPickerScheduleChoice(hours));
    }
    return result;
  }
  /** @description Checks an instant or schedule-local date, including holidays, in user mode.
   * @param operatingHoursId Saved OperatingHours ID.
   * @param dateValue Date-only input; ignored for an instant.
   * @param instantValue Exact instant, or null in date mode.
   * @param timeZoneId Display zone for datetime alternatives.
   * @param allowedIds Optional allowed record IDs.
   * @param filterJSON Optional structured filter, enforced on the selected ID.
   * @param useIdFilter Explicit false disables the ID allowlist; filters and user permissions still apply.
   * @return Eligibility and nearest-open alternatives.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList, PMD.AvoidBooleanMethodParameters'
  ) // Native bridge values and an explicit allowlist flag preserve the transport contract.
  @AuraEnabled(cacheable=true)
  public static ChronoPickerAvailability checkHours(
    Id operatingHoursId,
    Date dateValue,
    Datetime instantValue,
    String timeZoneId,
    List<Id> allowedIds,
    String filterJSON,
    Boolean useIdFilter
  ) {
    ChronoSupport.requireValue(operatingHoursId, 'OperatingHours ID');
    List<OperatingHours> accessible = new ChronoPickerScheduleQuery(
        filterIds(allowedIds, useIdFilter),
        filterJSON
      )
      .selectHours(null, operatingHoursId);
    if (accessible.isEmpty()) {
      throw new ChronoException(
        'The selected OperatingHours record is unavailable or outside the configured choices.'
      );
    }
    ChronoOperatingSchedules loaded = new ChronoOperatingSchedules(
      new Set<Id>{ operatingHoursId }
    );
    return new ChronoPickerCalendar(
        accessible[0],
        loaded.slots.get(operatingHoursId),
        loaded.holidays.get(operatingHoursId)
      )
      .check(dateValue, instantValue, timeZoneId);
  }
  // Aura transport does not reliably preserve null versus empty List values.
  // Keep unrestricted selection explicit; an absent flag must never broaden access.
  private static List<Id> filterIds(List<Id> ids, Boolean useIdFilter) {
    return useIdFilter == false ? null : (ids == null ? new List<Id>() : ids);
  }
  /** @description Evaluates supplied native records, including unsaved values, without queries or DML.
   * @param operatingHours Schedule name and explicit timezone.
   * @param timeSlots Weekly normal opening slots.
   * @param holidays Applicable holidays.
   * @param dateValue Calendar date in date mode.
   * @param instantValue Exact instant in datetime mode.
   * @param timeZoneId Display zone for datetime alternatives.
   * @return Eligibility and nearest-open alternatives.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Separate supported native and primitive LWC inputs.
  @AuraEnabled(cacheable=true)
  public static ChronoPickerAvailability checkSupplied(
    OperatingHours operatingHours,
    List<TimeSlot> timeSlots,
    List<Holiday> holidays,
    Date dateValue,
    Datetime instantValue,
    String timeZoneId
  ) {
    return new ChronoPickerCalendar(operatingHours, timeSlots, holidays)
      .check(dateValue, instantValue, timeZoneId);
  }
}
