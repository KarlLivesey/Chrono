// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
@SuppressWarnings('PMD.NcssCount, PMD.ApexUnitTestClassShouldHaveAsserts')
private class ChronoRecurrenceRuleTest {
  private static ChronoRecurrenceInput input(String operation) {
    ChronoRecurrenceInput result = new ChronoRecurrenceInput();
    result.operation = operation;
    result.valueType = 'PlainDate';
    return result;
  }

  private static void expectFailure(
    ChronoRecurrenceInput inputValue,
    String expectedMessage
  ) {
    try {
      new ChronoRecurrenceRule(inputValue);
      Assert.fail('Expected recurrence rule validation to fail');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains(expectedMessage),
        expected.getMessage()
      );
    }
  }

  @IsTest
  static void parsesSupportedPartsAndUntilByValueType() {
    ChronoRecurrenceInput dateRule = input('rrule');
    dateRule.rule = 'RRULE:FREQ=MONTHLY;INTERVAL=2;BYDAY=MO,FR;BYMONTHDAY=1,-1;BYMONTH=1,12;WKST=SU;UNTIL=20261231';
    ChronoRecurrenceRule parsedDate = new ChronoRecurrenceRule(dateRule);
    Assert.areEqual('monthly', parsedDate.frequency);
    Assert.areEqual(2, parsedDate.interval);
    Assert.isNull(parsedDate.count);
    Assert.areEqual(7, parsedDate.weekStart);
    Assert.areEqual(new Set<Integer>{ 1, 5 }, parsedDate.weekdays);
    Assert.areEqual(new Set<Integer>{ 1, -1 }, parsedDate.monthDays);
    Assert.areEqual(new Set<Integer>{ 1, 12 }, parsedDate.months);
    Assert.areEqual(Date.newInstance(2026, 12, 31), parsedDate.untilDate);
    Assert.isNull(parsedDate.untilInstant);

    ChronoRecurrenceInput instantRule = input('rrule');
    instantRule.valueType = 'Instant';
    instantRule.rule = 'FREQ=DAILY;UNTIL=20260103T120000Z';
    ChronoRecurrenceRule parsedInstant = new ChronoRecurrenceRule(instantRule);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 1, 3, 12, 0, 0),
      parsedInstant.untilInstant
    );
    Assert.isNull(parsedInstant.untilDate);

    ChronoRecurrenceInput localRule = input('rrule');
    localRule.valueType = 'PlainDateTime';
    localRule.rule = 'FREQ=DAILY;UNTIL=20260103T120000';
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 1, 3, 12, 0, 0),
      new ChronoRecurrenceRule(localRule).untilInstant
    );
  }

  @IsTest
  static void generatedRulesDefaultAndFilterDates() {
    ChronoRecurrenceInput daily = input('generate');
    daily.frequency = 'daily';
    daily.interval = null;
    daily.count = 2;
    ChronoRecurrenceRule dailyRule = new ChronoRecurrenceRule(daily);
    Assert.areEqual(1, dailyRule.interval);
    Assert.isTrue(
      dailyRule.matches(
        Date.newInstance(2026, 9, 8),
        Date.newInstance(2026, 9, 7)
      )
    );

    ChronoRecurrenceInput weekly = input('generate');
    weekly.frequency = 'weekly';
    weekly.interval = 2;
    ChronoRecurrenceRule weeklyRule = new ChronoRecurrenceRule(weekly);
    Date monday = Date.newInstance(2026, 9, 7);
    Assert.isTrue(weeklyRule.matches(monday, monday));
    Assert.isFalse(
      weeklyRule.matches(Date.newInstance(2026, 9, 14), monday),
      'Every second week skips the intervening week'
    );
    Assert.isFalse(
      weeklyRule.matches(Date.newInstance(2026, 9, 8), monday),
      'Default weekly rule keeps the anchor weekday'
    );

    weekly.weekdays = 'TU,TH';
    ChronoRecurrenceRule weekdayRule = new ChronoRecurrenceRule(weekly);
    Assert.isTrue(weekdayRule.matches(Date.newInstance(2026, 9, 8), monday));
    Assert.isFalse(weekdayRule.matches(Date.newInstance(2026, 9, 9), monday));

    ChronoRecurrenceInput monthly = input('generate');
    monthly.frequency = 'monthly';
    ChronoRecurrenceRule monthlyRule = new ChronoRecurrenceRule(monthly);
    Assert.isTrue(monthlyRule.matches(Date.newInstance(2026, 10, 7), monday));
    Assert.isFalse(monthlyRule.matches(Date.newInstance(2026, 10, 8), monday));

    ChronoRecurrenceInput yearly = input('generate');
    yearly.frequency = 'yearly';
    ChronoRecurrenceRule yearlyRule = new ChronoRecurrenceRule(yearly);
    Assert.isTrue(yearlyRule.matches(Date.newInstance(2027, 9, 7), monday));
    Assert.isFalse(yearlyRule.matches(Date.newInstance(2027, 10, 7), monday));
    yearly.weekdays = 'TU';
    ChronoRecurrenceRule yearlyWeekdayRule = new ChronoRecurrenceRule(yearly);
    Assert.isTrue(
      yearlyWeekdayRule.matches(Date.newInstance(2027, 10, 5), monday)
    );

    ChronoRecurrenceInput monthDay = input('rrule');
    monthDay.rule = 'FREQ=MONTHLY;BYMONTHDAY=-1';
    ChronoRecurrenceRule monthDayRule = new ChronoRecurrenceRule(monthDay);
    Assert.isTrue(
      monthDayRule.matches(
        Date.newInstance(2026, 2, 28),
        Date.newInstance(2026, 1, 31)
      )
    );
    Assert.isFalse(
      monthDayRule.matches(
        Date.newInstance(2026, 2, 27),
        Date.newInstance(2026, 1, 31)
      )
    );
  }

  @IsTest
  static void rejectsAmbiguousOrUnsupportedRules() {
    ChronoRecurrenceInput duplicate = input('rrule');
    duplicate.rule = 'FREQ=DAILY;FREQ=WEEKLY';
    expectFailure(duplicate, 'unique NAME=VALUE');

    ChronoRecurrenceInput malformed = input('rrule');
    malformed.rule = 'FREQ';
    expectFailure(malformed, 'unique NAME=VALUE');

    ChronoRecurrenceInput unsupported = input('rrule');
    unsupported.rule = 'FREQ=DAILY;BYSETPOS=1';
    expectFailure(unsupported, 'Unsupported RRULE part');

    ChronoRecurrenceInput bothStops = input('rrule');
    bothStops.rule = 'FREQ=DAILY;COUNT=2;UNTIL=20260103';
    expectFailure(bothStops, 'cannot combine COUNT and UNTIL');

    ChronoRecurrenceInput badWeekday = input('rrule');
    badWeekday.rule = 'FREQ=WEEKLY;BYDAY=MO,1FR';
    expectFailure(badWeekday, 'plain weekday codes');

    ChronoRecurrenceInput badWeekStart = input('rrule');
    badWeekStart.rule = 'FREQ=WEEKLY;WKST=XX';
    expectFailure(badWeekStart, 'Invalid WKST');

    ChronoRecurrenceInput badNumbers = input('rrule');
    badNumbers.rule = 'FREQ=MONTHLY;BYMONTHDAY=0';
    expectFailure(badNumbers, 'Invalid RRULE numeric list');

    ChronoRecurrenceInput badMonth = input('rrule');
    badMonth.rule = 'FREQ=MONTHLY;BYMONTH=-1';
    expectFailure(badMonth, 'Invalid RRULE numeric list');

    ChronoRecurrenceInput weeklyMonthDay = input('rrule');
    weeklyMonthDay.rule = 'FREQ=WEEKLY;BYMONTHDAY=1';
    expectFailure(weeklyMonthDay, 'not valid with WEEKLY');

    ChronoRecurrenceInput badInterval = input('generate');
    badInterval.frequency = 'daily';
    badInterval.interval = 0;
    expectFailure(badInterval, 'Use interval');

    ChronoRecurrenceInput badCount = input('generate');
    badCount.frequency = 'daily';
    badCount.count = 1001;
    expectFailure(badCount, 'Use interval');

    ChronoRecurrenceInput wrongUntil = input('rrule');
    wrongUntil.valueType = 'Instant';
    wrongUntil.rule = 'FREQ=DAILY;UNTIL=20260103T120000';
    expectFailure(wrongUntil, 'RRULE UNTIL for this value type');
  }

  @IsTest
  static void weekdayAndNumericHelpersValidateValues() {
    Assert.areEqual(
      new Set<Integer>{ 1, 3, 7 },
      ChronoRecurrenceRule.weekdaySet('MO,WE,SU')
    );
    Assert.areEqual(
      1,
      ChronoRecurrenceRule.weekday(Date.newInstance(2026, 9, 7))
    );
    try {
      ChronoRecurrenceRule.weekdaySet('MO,XX');
      Assert.fail('Expected invalid weekday to fail');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('plain weekday codes'));
    }
  }
}
