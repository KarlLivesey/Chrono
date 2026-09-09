// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only time allocation contract; services validate all supplied fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeBlock {
  /** @description Unique stable identifier; input order defines priority. */
  global String key;
  /** @description Readable block name. */
  global String label;
  /** @description Comma-separated ISO weekdays 1 Monday through 7 Sunday; empty means all weekdays. */
  global String weekdays;
  /** @description regular or holiday; default regular. Holidays replace normal time. */
  global String dayType;
  /** @description ISO local time; inclusive. */
  global String startTime;
  /** @description Exclusive ISO local time; 24:00 is allowed. An earlier end crosses midnight. */
  global String endTime;
  /** @description Empty transport constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeBlock() {
  }
}
