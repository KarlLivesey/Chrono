// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validates the mutually exclusive native/ISO representation of an exact instant. */
public with sharing class ChronoExactInput {
  public static Datetime resolve(Datetime nativeValue, String text) {
    if (nativeValue != null) {
      if (!String.isBlank(text)) {
        throw new ChronoException(
          'Provide a native instant or an ISO instant, not both.'
        );
      }
      return nativeValue;
    }
    ChronoSupport.requireValue(text, 'ISO instant');
    return text.contains('[')
      ? ChronoZonedDateTimeOperations.toDatetime(
          ChronoZonedDateTimeOperations.parseIso(text)
        )
      : ChronoInstantOperations.toDatetime(
          ChronoInstantOperations.parseIso(text)
        );
  }
}
