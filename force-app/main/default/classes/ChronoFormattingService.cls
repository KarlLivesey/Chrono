// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Direct bulk Apex API. Flow adapters use these same services. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoFormattingService {
  /** @description Bulk FormatValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoFormatResult> format(
    List<ChronoFormatValueInput> requests
  ) {
    return ChronoFormattingOperations.format(requests);
  }
}
