// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Bulk working-time arithmetic over saved schedules or supplied native OperatingHours records. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoWorkingTimeService {
  /** @description Adds signed working hours or minutes. Loads saved OperatingHours in three user-mode queries per batch, plus one query when BusinessHours is requested. Supplied-record-only batches use no queries. No DML. Ordinary failures are returned per item; governor limits still apply. Null or empty lists return an empty list.
   * @param requests Ordered inputs, each with a native or ISO date/date-time, explicit input/result zone, signed amount, hours/minutes unit and saved schedule ID/type or native OperatingHours, TimeSlot and Holiday records. Dates mean local midnight; local inputs reject gaps and require a repeated-time policy for overlaps. Inputs are not mutated.
   * @return One independent typed result per input in the same order. Check success before using value; failed values are null.
   */
  global static List<ChronoWorkingTimeResult> add(
    List<ChronoWorkingTimeInput> requests
  ) {
    return ChronoWorkingTimeOperations.add(requests);
  }
  /** @description Bulk CheckWorkingTime operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoWorkingTimeCheckResult> check(
    List<ChronoCheckWorkingTimeInput> requests
  ) {
    return ChronoWorkingCalendarOperations.check(requests);
  }
  /** @description Bulk FindWorkingTime operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> find(
    List<ChronoFindWorkingTimeInput> requests
  ) {
    return ChronoWorkingCalendarOperations.find(requests);
  }
  /** @description Bulk WorkingDays operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> addDays(
    List<ChronoWorkingDaysInput> requests
  ) {
    return ChronoWorkingCalendarOperations.addDays(requests);
  }
}
