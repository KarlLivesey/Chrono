// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Direct bulk Apex API. Flow adapters use these same services. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoCalculationService {
  /** @description Bulk Adjust operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> adjust(
    List<ChronoAdjustInput> requests
  ) {
    return ChronoCalculationOperations.adjust(requests);
  }
  /** @description Bulk Difference operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoDurationCalculationResult> difference(
    List<ChronoDifferenceInput> requests
  ) {
    return ChronoCalculationOperations.difference(requests);
  }
  /** @description Bulk CalendarDifference operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoDurationCalculationResult> calendarDifference(
    List<ChronoCalendarDifferenceInput> requests
  ) {
    return ChronoCalculationOperations.calendarDifference(requests);
  }
  /** @description Bulk Compare operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoComparisonResult> compare(
    List<ChronoCompareInput> requests
  ) {
    return ChronoCalculationOperations.compare(requests);
  }
  /** @description Bulk PeriodBoundary operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> boundary(
    List<ChronoPeriodBoundaryInput> requests
  ) {
    return ChronoCalculationOperations.boundary(requests);
  }
  /** @description Bulk Round operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> round(List<ChronoRoundInput> requests) {
    return ChronoCalculationOperations.round(requests);
  }
}
