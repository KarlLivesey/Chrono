// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoNumericBoundaryTest {
  @IsTest
  static void signedDurationsRoundTrip() {
    for (
      String text : new List<String>{
        'P2147483647M',
        '-P2147483648M',
        '-P2147483648D',
        'PT9223372036854775.807S',
        '-PT9223372036854775.808S',
        '-PT0.001S'
      }
    ) {
      Assert.areEqual(
        text,
        ChronoDurationService.toIsoString(ChronoDurationService.parseIso(text)),
        'Signed boundaries must retain all digits'
      );
    }
    Assert.areEqual(
      'PT0S',
      ChronoDurationService.toIsoString(
        ChronoDurationService.parseIso('-PT0.0009S')
      )
    );
  }
  @IsTest
  static void rejectsOverflowBeforeCasting() {
    for (
      String text : new List<String>{
        'P2147483647Y',
        'P2147483647W',
        'P2147483648M',
        'PT9223372036854775.808S',
        '-PT9223372036854775.809S',
        'PT99999999999999999999999999999S'
      }
    ) {
      try {
        ChronoDurationService.parseIso(text);
        Assert.fail('Expected rejection: ' + text);
      } catch (ChronoException expected) {
        Assert.isTrue(expected.getMessage().contains('range'));
      }
    }
    try {
      ChronoDurationService.negate(
        ChronoDurationService.parseIso('-P2147483648M')
      );
      Assert.fail('Unrepresentable positive magnitude');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
    ChronoDurationToolsInput input = new ChronoDurationToolsInput();
    input.operation = 'multiply';
    input.value = 'PT1S';
    input.factor = Decimal.valueOf('18446744073709551616');
    try {
      ChronoDurationMath.execute(input);
      Assert.fail('Scaling must not wrap');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
  }
  @IsTest
  static void epochErrorsAreIsolatedAcrossInterviews() {
    ChronoEpochValueAction.Request bad = new ChronoEpochValueAction.Request();
    bad.operation = 'fromEpoch';
    bad.epochUnit = 'millisecond';
    bad.epochValue = Decimal.valueOf('18446744073709551616');
    ChronoEpochValueAction.Request good = new ChronoEpochValueAction.Request();
    good.operation = 'fromEpoch';
    good.epochUnit = 'millisecond';
    good.epochValue = -1.9;
    List<ChronoEpochResult> results = ChronoEpochValueAction.run(
      new List<ChronoEpochValueAction.Request>{ bad, good }
    );
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual('1969-12-31T23:59:59.999Z', results[1].value);
  }
  @IsTest
  static void calendarArithmeticDoesNotWrap() {
    Date value = Date.newInstance(2026, 1, 31);
    Assert.areEqual(
      Date.newInstance(2026, 2, 28),
      ChronoPlainDateService.addMonths(value, 1).value
    );
    for (
      Integer amount : new List<Integer>{ 2147483647, -2147483647 - 1, 10000 }
    ) {
      try {
        ChronoPlainDateService.addYears(value, amount);
        Assert.fail('Oversized year arithmetic');
      } catch (ChronoException expected) {
        Assert.isTrue(expected.getMessage().contains('range'));
      }
    }
    try {
      ChronoPlainDateService.addDays(Date.newInstance(9999, 12, 31), 1);
      Assert.fail('Beyond ISO range');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
    try {
      ChronoInstantService.addMilliseconds(
        Datetime.newInstanceGmt(2026, 1, 1, 0, 0, 0),
        9223372036854775807L
      );
      Assert.fail('Elapsed overflow');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
  }
  @IsTest
  static void rejectsInstantsAndProjectionsOutsideCalendarRange() {
    Datetime first = Datetime.newInstanceGmt(1, 1, 1, 0, 0, 0);
    Datetime last = Datetime.newInstanceGmt(9999, 12, 31, 23, 59, 59);
    ChronoDates.validateInstant(first);
    ChronoDates.validateInstant(last.addSeconds(0));
    for (
      Datetime invalid : new List<Datetime>{
        Datetime.newInstance(first.getTime() - 1),
        Datetime.newInstance(last.getTime() + 1000)
      }
    ) {
      try {
        ChronoDates.validateInstant(invalid);
        Assert.fail('An instant outside the four-digit calendar must fail');
      } catch (ChronoException expected) {
        Assert.isTrue(expected.getMessage().contains('range'));
      }
    }
    try {
      ChronoSupport.localValue(first, 'America/New_York');
      Assert.fail('A local projection before year 1 must fail');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
    try {
      ChronoPickerController.resolveLocal(
        '0001-01-01',
        '00:00:00.000',
        'Asia/Tokyo'
      );
      Assert.fail('A local clock requiring an instant before year 1 must fail');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('range'));
    }
  }
}
