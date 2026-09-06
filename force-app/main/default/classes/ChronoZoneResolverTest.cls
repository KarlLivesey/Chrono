// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoZoneResolverTest {
  @SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveAsserts'
  ) // Assertions are in assertOverlap.
  @IsTest
  static void knownOverlapsIncludingHalfHourTransition() {
    assertOverlap(
      '2026-11-01T01:30',
      'America/New_York',
      '2026-11-01T05:30Z',
      '2026-11-01T06:30Z'
    );
    assertOverlap(
      '2026-10-25T02:30',
      'Europe/Paris',
      '2026-10-25T00:30Z',
      '2026-10-25T01:30Z'
    );
    assertOverlap(
      '2026-10-25T01:30',
      'Europe/London',
      '2026-10-25T00:30Z',
      '2026-10-25T01:30Z'
    );
    assertOverlap(
      '2026-04-05T01:45',
      'Australia/Lord_Howe',
      '2026-04-04T14:45Z',
      '2026-04-04T15:15Z'
    );
  }
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // One input pair and its two expected UTC results.
  private static void assertOverlap(
    String localText,
    String zoneId,
    String earlier,
    String later
  ) {
    ChronoPlainDateTime local = ChronoPlainDateTime.parse(localText);
    Assert.areEqual(
      ChronoInstant.parse(earlier).toDatetime(),
      local.toZonedDateTime(zoneId, 'earlier').toDatetime(),
      'Earlier occurrence'
    );
    Assert.areEqual(
      ChronoInstant.parse(later).toDatetime(),
      local.toZonedDateTime(zoneId, 'later').toDatetime(),
      'Later occurrence'
    );
    try {
      local.toZonedDateTime(zoneId);
      Assert.fail('Overlap must reject by default');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('repeated'),
        'Overlap diagnostic'
      );
    }
  }
  @IsTest
  static void knownGapsRejectForEveryPolicy() {
    Map<String, String> gaps = new Map<String, String>{
      'America/New_York' => '2026-03-08T02:30',
      'Europe/Paris' => '2026-03-29T02:30',
      'Europe/London' => '2026-03-29T01:30',
      'Australia/Lord_Howe' => '2026-10-04T02:15'
    };
    for (String zoneId : gaps.keySet()) {
      for (String policy : new List<String>{ 'reject', 'earlier', 'later' }) {
        try {
          ChronoPlainDateTime.parse(gaps.get(zoneId))
            .toZonedDateTime(zoneId, policy);
          Assert.fail('Gap must reject');
        } catch (ChronoException expected) {
          Assert.isTrue(
            expected.getMessage().contains('does not exist'),
            'Gap diagnostic'
          );
        }
      }
    }
  }
  @IsTest
  static void normalOffsetsAndFractionalSeconds() {
    ChronoPlainDateTime local = ChronoPlainDateTime.parse(
      '2026-07-01T09:30:00.123'
    );
    Assert.areEqual(
      '2026-07-01T07:30:00.123Z',
      local.toZonedDateTime('Europe/Paris').toInstant().toString(),
      'Paris summer'
    );
    Assert.areEqual(
      '2026-06-30T23:00:00.123Z',
      local.toZonedDateTime('Australia/Lord_Howe').toInstant().toString(),
      'Half-hour standard offset'
    );
    try {
      local.toZonedDateTime('UTC', 'compatible');
      Assert.fail('Unknown policy');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('Disambiguation'),
        'Policy diagnostic'
      );
    }
  }
}
