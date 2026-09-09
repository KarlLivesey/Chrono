public class ChronoVariableInspector {
  public class Request {
    @InvocableVariable(label='PlainDate collection')
    public List<skel.ChronoPlainDate> dateValues;
    @InvocableVariable(label='PlainTime collection')
    public List<skel.ChronoPlainTime> timeValues;
    @InvocableVariable(label='PlainDateTime collection')
    public List<skel.ChronoPlainDateTime> localValues;
    @InvocableVariable(label='Instant collection')
    public List<skel.ChronoInstant> instantValues;
    @InvocableVariable(label='ZonedDateTime collection')
    public List<skel.ChronoZonedDateTime> zonedValues;
    @InvocableVariable(label='PlainYearMonth collection')
    public List<skel.ChronoPlainYearMonth> yearMonthValues;
    @InvocableVariable(label='PlainMonthDay collection')
    public List<skel.ChronoPlainMonthDay> monthDayValues;
    @InvocableVariable(label='Duration collection')
    public List<skel.ChronoDuration> durationValues;
  }
  public class Result {
    @InvocableVariable
    public String summary;
  }
  @InvocableMethod(label='Check Chrono variable behaviour')
  public static List<Result> inspect(List<Request> requests) {
    List<Result> results = new List<Result>();
    for (Request input : requests) {
      Map<String, List<String>> observed = new Map<String, List<String>>();
      List<String> dateText = new List<String>();
      for (skel.ChronoPlainDate item : input.dateValues) {
        try {
          dateText.add(item.toString());
        } catch (Exception error) {
          dateText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('date', dateText);
      List<String> timeText = new List<String>();
      for (skel.ChronoPlainTime item : input.timeValues) {
        try {
          timeText.add(item.toString());
        } catch (Exception error) {
          timeText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('time', timeText);
      List<String> localText = new List<String>();
      for (skel.ChronoPlainDateTime item : input.localValues) {
        try {
          localText.add(item.toString());
        } catch (Exception error) {
          localText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('local', localText);
      List<String> instantText = new List<String>();
      for (skel.ChronoInstant item : input.instantValues) {
        try {
          instantText.add(item.toString());
        } catch (Exception error) {
          instantText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('instant', instantText);
      List<String> zonedText = new List<String>();
      for (skel.ChronoZonedDateTime item : input.zonedValues) {
        try {
          zonedText.add(item.toString());
        } catch (Exception error) {
          zonedText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('zoned', zonedText);
      List<String> yearMonthText = new List<String>();
      for (skel.ChronoPlainYearMonth item : input.yearMonthValues) {
        try {
          yearMonthText.add(item.toString());
        } catch (Exception error) {
          yearMonthText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('yearMonth', yearMonthText);
      List<String> monthDayText = new List<String>();
      for (skel.ChronoPlainMonthDay item : input.monthDayValues) {
        try {
          monthDayText.add(item.toString());
        } catch (Exception error) {
          monthDayText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('monthDay', monthDayText);
      List<String> durationText = new List<String>();
      for (skel.ChronoDuration item : input.durationValues) {
        try {
          durationText.add(item.toString());
        } catch (Exception error) {
          durationText.add(error.getTypeName() + ': ' + error.getMessage());
        }
      }
      observed.put('duration', durationText);
      Result result = new Result();
      result.summary = JSON.serialize(observed);
      results.add(result);
    }
    return results;
  }
}
