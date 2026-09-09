// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Direct bulk Apex API. Flow adapters use these same services. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoValueService {
  /** @description Bulk Convert operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> convert(
    List<ChronoConvertInput> requests
  ) {
    return ChronoValueOperations.convert(requests);
  }
  /** @description Bulk CreateValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> create(
    List<ChronoCreateValueInput> requests
  ) {
    return ChronoValueOperations.create(requests);
  }
  /** @description Bulk ReplaceValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> replace(
    List<ChronoReplaceValueInput> requests
  ) {
    return ChronoValueOperations.replace(requests);
  }
  /** @description Bulk ParseValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValueResult> parse(
    List<ChronoParseValueInput> requests
  ) {
    return ChronoValueOperations.parse(requests);
  }
  /** @description Bulk ValidateValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoValidationResult> validate(
    List<ChronoValidateValueInput> requests
  ) {
    return ChronoValueOperations.validate(requests);
  }
  /** @description Bulk EpochValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoEpochResult> convertEpoch(
    List<ChronoEpochValueInput> requests
  ) {
    return ChronoValueOperations.convertEpoch(requests);
  }
  /** @description Bulk ValueDetails operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch. Shared configuration is loaded once per call.
   * @return Independent results in request order; check success before reading values.
   */
  global static List<ChronoDetailsResult> details(
    List<ChronoValueDetailsInput> requests
  ) {
    return ChronoValueOperations.details(requests);
  }
}
