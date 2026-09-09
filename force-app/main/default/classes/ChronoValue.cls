// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoValue {
  /** @description valueType component; absent optional values are null. */
  global String valueType;
  /** @description instant component; absent optional values are null. */
  global ChronoInstant instant;
  /** @description zonedDateTime component; absent optional values are null. */
  global ChronoZonedDateTime zonedDateTime;
  /** @description plainDateTime component; absent optional values are null. */
  global ChronoPlainDateTime plainDateTime;
  /** @description plainDate component; absent optional values are null. */
  global ChronoPlainDate plainDate;
  /** @description plainTime component; absent optional values are null. */
  global ChronoPlainTime plainTime;
  /** @description yearMonth component; absent optional values are null. */
  global ChronoPlainYearMonth yearMonth;
  /** @description monthDay component; absent optional values are null. */
  global ChronoPlainMonthDay monthDay;
  /** @description duration component; absent optional values are null. */
  global ChronoDuration duration;
  /** @description Creates uninitialised data. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoValue() {
  }
}
