// Demo data for ChronoExampleWorkingHours. Re-running does not duplicate the schedule.
List<OperatingHours> existing = [
  SELECT Id
  FROM OperatingHours
  WHERE Name = 'Chrono demo - London weekdays'
];
if (existing.isEmpty()) {
  OperatingHours hours = new OperatingHours(
    Name = 'Chrono demo - London weekdays',
    TimeZone = 'Europe/London'
  );
  insert hours;
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
        OperatingHoursId = hours.Id,
        DayOfWeek = day,
        Type = 'Normal',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      )
    );
  }
  insert slots;
  Holiday holiday = [
    SELECT Id
    FROM Holiday
    WHERE Name = 'Chrono demo - August bank holiday'
    LIMIT 1
  ];
  insert new OperatingHoursHoliday(
    OperatingHoursId = hours.Id,
    HolidayId = holiday.Id
  );
}

// A second zone lets the demo change hours independently of the display zone.
List<OperatingHours> newYork = [
  SELECT Id
  FROM OperatingHours
  WHERE Name = 'Chrono demo - New York weekdays'
];
if (newYork.isEmpty()) {
  OperatingHours hours = new OperatingHours(
    Name = 'Chrono demo - New York weekdays',
    TimeZone = 'America/New_York'
  );
  insert hours;
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
        OperatingHoursId = hours.Id,
        DayOfWeek = day,
        Type = 'Normal',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      )
    );
  }
  insert slots;
}
