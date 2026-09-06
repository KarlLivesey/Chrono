// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable partial date.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoPlainMonthDay {
  private final Date value;
  /**
   * @description Constructs an immutable partial date.
   * @param month Month.
   * @param day Day.
   */
  global ChronoPlainMonthDay(Integer month, Integer day) {
    value = Date.newInstance(2000, month, day);
    if (value.month() != month || value.day() != day) {
      throw new ChronoException('Invalid partial date components.');
    }
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  global static ChronoPlainMonthDay parse(String value) {
    ChronoSupport.requireMatch(value, '--\\d{2}-\\d{2}', 'partial date');
    List<String> parts = value.substring(2).split('-');
    return new ChronoPlainMonthDay(
      Integer.valueOf(parts[0]),
      Integer.valueOf(parts[1])
    );
  }
  /**
   * @description Serialises a partial date.
   * @return The resulting value.
   */
  global override String toString() {
    return '--' +
      ChronoIso.pad(value.month(), 2) +
      '-' +
      ChronoIso.pad(value.day(), 2);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param year Missing date component.
   * @return The resulting value.
   */
  global ChronoPlainDate toPlainDate(Integer year) {
    Date completed = Date.newInstance(year, value.month(), value.day());
    if (
      completed.year() != year ||
      completed.month() != value.month() ||
      completed.day() != value.day()
    ) {
      throw new ChronoException(
        'This month and day do not exist in the requested year.'
      );
    }
    return new ChronoPlainDate(completed);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param source Value to operate on.
   * @param year Missing date component.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(
    ChronoPlainMonthDay source,
    Integer year
  ) {
    return source.toPlainDate(year);
  }
}
