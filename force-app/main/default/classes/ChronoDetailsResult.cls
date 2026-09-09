// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flat Flow result for details operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDetailsResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type')
  global String valueType;
  /** @description ISO value. */
  @AuraEnabled
  @InvocableVariable(label='ISO value')
  global String value;
  /** @description Local date. */
  @AuraEnabled
  @InvocableVariable(label='Local date')
  global Date dateValue;
  /** @description Local time. */
  @AuraEnabled
  @InvocableVariable(label='Local time')
  global String timeValue;
  /** @description Native datetime. */
  @AuraEnabled
  @InvocableVariable(label='Native datetime')
  global Datetime instantValue;
  /** @description Timezone. */
  @AuraEnabled
  @InvocableVariable(label='Timezone')
  global String timeZoneId;
  /** @description Is leap year. */
  @AuraEnabled
  @InvocableVariable(label='Is leap year')
  global Boolean isLeapYear;
  /** @description Duration elapsed milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Duration elapsed milliseconds')
  global Long durationMilliseconds;
  /** @description Year. */
  @AuraEnabled
  @InvocableVariable(label='Year')
  global Integer year;
  /** @description Month. */
  @AuraEnabled
  @InvocableVariable(label='Month')
  global Integer month;
  /** @description Day. */
  @AuraEnabled
  @InvocableVariable(label='Day')
  global Integer day;
  /** @description Hour. */
  @AuraEnabled
  @InvocableVariable(label='Hour')
  global Integer hour;
  /** @description Minute. */
  @AuraEnabled
  @InvocableVariable(label='Minute')
  global Integer minute;
  /** @description Second. */
  @AuraEnabled
  @InvocableVariable(label='Second')
  global Integer second;
  /** @description Millisecond. */
  @AuraEnabled
  @InvocableVariable(label='Millisecond')
  global Integer millisecond;
  /** @description ISO weekday. */
  @AuraEnabled
  @InvocableVariable(label='ISO weekday')
  global Integer dayOfWeek;
  /** @description Day of year. */
  @AuraEnabled
  @InvocableVariable(label='Day of year')
  global Integer dayOfYear;
  /** @description ISO week number. */
  @AuraEnabled
  @InvocableVariable(label='ISO week number')
  global Integer weekOfYear;
  /** @description ISO week year. */
  @AuraEnabled
  @InvocableVariable(label='ISO week year')
  global Integer yearOfWeek;
  /** @description Days in month. */
  @AuraEnabled
  @InvocableVariable(label='Days in month')
  global Integer daysInMonth;
  /** @description Days in year. */
  @AuraEnabled
  @InvocableVariable(label='Days in year')
  global Integer daysInYear;
  /** @description Calendar quarter. */
  @AuraEnabled
  @InvocableVariable(label='Calendar quarter')
  global Integer quarter;
  /** @description UTC offset seconds. */
  @AuraEnabled
  @InvocableVariable(label='UTC offset seconds')
  global Integer offsetSeconds;
  /** @description Duration calendar months. */
  @AuraEnabled
  @InvocableVariable(label='Duration calendar months')
  global Integer durationMonths;
  /** @description Duration calendar days. */
  @AuraEnabled
  @InvocableVariable(label='Duration calendar days')
  global Integer durationDays;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoDetailsResult() {
  }
}
