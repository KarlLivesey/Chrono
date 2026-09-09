// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoPickerConsumerTest {
  @IsTest
  static void unsavedScheduleWorksAcrossNamespace() {
    OperatingHours hours = new OperatingHours(
      Name = 'Subscriber',
      TimeZone = 'Europe/London'
    );
    List<TimeSlot> slots = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      slots.add(
        new TimeSlot(
          DayOfWeek = day,
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0),
          Type = 'Normal'
        )
      );
    }
    List<Holiday> holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 8, 31), IsAllDay = true)
    };
    Datetime start = Datetime.newInstanceGmt(2026, 8, 28, 15, 30, 0);
    Integer queries = Limits.getQueries();
    Integer dml = Limits.getDmlStatements();
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      skel.ChronoZonedDateTimeService.toDatetime(
        skel.ChronoZonedDateTimeService.addHours(
          start,
          'Europe/London',
          1,
          hours,
          slots,
          holidays
        )
      )
    );
    Assert.areEqual(queries, Limits.getQueries());
    Assert.areEqual(dml, Limits.getDmlStatements());
    Assert.isNull(hours.Id);
  }
}
