// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Direct bulk Apex API. Flow adapters use these same services. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoTimeZoneService {
  /** @description Bulk ResolveLocal operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoLocalResolutionResult> resolveLocal(
    List<ChronoResolveLocalInput> requests
  ) {
    return ChronoTimeZoneOperations.resolveLocal(requests);
  }
  /** @description Bulk ZoneTools operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoZoneResult> calculate(
    List<ChronoZoneToolsInput> requests
  ) {
    return ChronoTimeZoneOperations.calculate(requests);
  }
}
