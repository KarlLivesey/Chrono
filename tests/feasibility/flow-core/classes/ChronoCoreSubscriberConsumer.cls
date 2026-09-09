public class ChronoCoreSubscriberConsumer {
  public class Request {
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
  public class Result {
    @InvocableVariable(label='Validated Chrono values')
    public String summary;
  }
  @InvocableMethod(label='Read Chrono ISO values')
  public static List<Result> read(List<Request> inputs) {
    List<Result> results = new List<Result>();
    for (Request input : inputs) {
      Map<String, String> observed = new Map<String, String>();
      observed.put(
        'dateValue',
        skel.ChronoPlainDate.parse(input.dateValue).toString()
      );
      observed.put(
        'timeValue',
        skel.ChronoPlainTime.parse(input.timeValue).toString()
      );
      observed.put(
        'dateTimeValue',
        skel.ChronoPlainDateTime.parse(input.dateTimeValue).toString()
      );
      observed.put(
        'instantValue',
        skel.ChronoInstant.parse(input.instantValue).toString()
      );
      observed.put(
        'zonedValue',
        skel.ChronoZonedDateTime.parse(input.zonedValue).toString()
      );
      observed.put(
        'yearMonthValue',
        skel.ChronoPlainYearMonth.parse(input.yearMonthValue).toString()
      );
      observed.put(
        'monthDayValue',
        skel.ChronoPlainMonthDay.parse(input.monthDayValue).toString()
      );
      observed.put(
        'durationValue',
        skel.ChronoDuration.parse(input.durationValue).toString()
      );
      Result result = new Result();
      result.summary = JSON.serialize(observed);
      results.add(result);
    }
    return results;
  }
}
