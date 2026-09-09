// Run before seed-example-hours.apex: Holiday setup DML needs its own transaction.
List<Holiday> existing = [
  SELECT Id
  FROM Holiday
  WHERE Name = 'Chrono demo - August bank holiday'
];
if (existing.isEmpty()) {
  insert new Holiday(
    Name = 'Chrono demo - August bank holiday',
    ActivityDate = Date.newInstance(2026, 8, 31),
    IsAllDay = true
  );
}
