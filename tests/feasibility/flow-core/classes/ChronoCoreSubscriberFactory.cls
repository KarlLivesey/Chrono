public class ChronoCoreSubscriberFactory {
  public class Result {
    @InvocableVariable(label='PlainDate ISO text')
    public String dateValue;
    @InvocableVariable(label='PlainTime ISO text')
    public String timeValue;
    @InvocableVariable(label='PlainDateTime ISO text')
    public String dateTimeValue;
    @InvocableVariable(label='Instant ISO text')
    public String instantValue;
    @InvocableVariable(label='ZonedDateTime ISO text')
    public String zonedValue;
    @InvocableVariable(label='PlainYearMonth ISO text')
    public String yearMonthValue;
    @InvocableVariable(label='PlainMonthDay ISO text')
    public String monthDayValue;
    @InvocableVariable(label='Duration ISO text')
    public String durationValue;
  }
  @InvocableMethod(label='Create Chrono example values' category='Chrono')
  public static List<Result> make() {
    Result result = new Result();
    result.dateValue = '2026-10-25';
    result.timeValue = '01:30:00.000';
    result.dateTimeValue = '2026-10-25T01:30:00.000';
    result.instantValue = '2026-10-25T00:30:00.000Z';
    result.zonedValue = '2026-10-25T01:30:00.000+01:00[Europe/London]';
    result.yearMonthValue = '2026-10';
    result.monthDayValue = '--10-25';
    result.durationValue = 'P1M2DT3.000S';
    return new List<Result>{ result };
  }
}
