// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowAccessTest {
  @IsTest
  static void configurationPickerUsesSalesforceZones() {
    ChronoTimeZonePicklist picker = new ChronoTimeZonePicklist();
    VisualEditor.DynamicPickListRows rows = picker.getValues();
    Assert.isTrue(rows.size() > 100, 'Full Salesforce zone selection');
    Assert.isTrue(rows.size() <= 500, 'Flow helper limit');
    Assert.areEqual(
      '',
      picker.getDefaultValue().getValue(),
      'No implicit time zone'
    );
  }
  @IsTest
  static void restrictedUserCannotReadSchedules() {
    OperatingHours hours = new OperatingHours(
      Name = 'Restricted configuration',
      TimeZone = 'Europe/London'
    );
    insert hours;
    insert new TimeSlot(
      OperatingHoursId = hours.Id,
      DayOfWeek = 'Friday',
      Type = 'Normal',
      StartTime = Time.newInstance(9, 0, 0, 0),
      EndTime = Time.newInstance(17, 0, 0, 0)
    );
    Profile minimal = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Minimum Access - Salesforce'
      LIMIT 1
    ];
    User restricted = new User(
      Alias = 'chronof',
      Email = 'chrono-flow@example.invalid',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Chrono Flow',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'Europe/London',
      ProfileId = minimal.Id,
      Username = 'chrono-flow-' +
        UserInfo.getOrganizationId() +
        '@example.invalid'
    );
    ChronoWorkingTimeInput item = new ChronoWorkingTimeInput();
    item.startValue = '2026-08-28T15:30Z';
    item.timeZoneId = 'Europe/London';
    item.amount = 1;
    item.unit = 'hours';
    item.scheduleType = 'OperatingHours';
    item.scheduleId = hours.Id;
    Test.startTest();
    System.runAs(restricted) {
      ChronoFlowResult result = runWorkingTime(
        new List<ChronoWorkingTimeInput>{ item }
      )[0];
      Assert.isFalse(
        result.success,
        'Read permissions are enforced despite the global entry point'
      );
      Assert.isTrue(
        result.errorMessage.contains(
          'Cannot read operating-hour configuration'
        ),
        'Permission failure is reported'
      );
      ChronoConvertInput plain = new ChronoConvertInput();
      plain.valueType = 'PlainDate';
      plain.value = '2026-09-01';
      Assert.isTrue(
        runConvert(new List<ChronoConvertInput>{ plain })[0].success,
        'Pure conversions need no schedule permissions'
      );
    }
    Test.stopTest();
  }
  private static List<ChronoFlowResult> runConvert(
    List<ChronoConvertInput> items
  ) {
    if (items == null) {
      return ChronoConvertAction.run(null);
    }
    List<ChronoConvertAction.Request> wrappers = new List<ChronoConvertAction.Request>();
    for (ChronoConvertInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoConvertAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoConvertAction.Request.class
            )
      );
    }
    return ChronoConvertAction.run(wrappers);
  }
  private static List<ChronoFlowResult> runWorkingTime(
    List<ChronoWorkingTimeInput> items
  ) {
    if (items == null) {
      return ChronoWorkingTimeAction.run(null);
    }
    List<ChronoWorkingTimeAction.Request> wrappers = new List<ChronoWorkingTimeAction.Request>();
    for (ChronoWorkingTimeInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoWorkingTimeAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoWorkingTimeAction.Request.class
            )
      );
    }
    return ChronoWorkingTimeAction.run(wrappers);
  }
}
