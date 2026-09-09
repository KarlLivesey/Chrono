// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal ISO parsing and serialisation at native millisecond precision. */
public with sharing class ChronoIso {
  public static String pad(Integer value, Integer size) {
    return String.valueOf(value).leftPad(size, '0');
  }
  public static String dateText(Date value) {
    ChronoDates.validate(value);
    return pad(value.year(), 4) +
      '-' +
      pad(value.month(), 2) +
      '-' +
      pad(value.day(), 2);
  }
  public static String timeText(Time value) {
    return pad(value.hour(), 2) +
      ':' +
      pad(value.minute(), 2) +
      ':' +
      pad(value.second(), 2) +
      '.' +
      pad(value.millisecond(), 3);
  }
  public static Date parseDate(String value) {
    ChronoSupport.requireMatch(value, '\\d{4}-\\d{2}-\\d{2}', 'ISO date');
    List<String> pieces = value.split('-');
    Date result = Date.newInstance(
      Integer.valueOf(pieces[0]),
      Integer.valueOf(pieces[1]),
      Integer.valueOf(pieces[2])
    );
    if (dateText(result) != value) {
      throw new ChronoException('Invalid calendar date: ' + value);
    }
    return result;
  }
  public static Time parseTime(String value) {
    ChronoSupport.requireMatch(
      value,
      '\\d{2}:\\d{2}(:\\d{2}(\\.\\d+)?)?',
      'ISO time'
    );
    List<String> pieces = value.split(':');
    List<String> seconds = pieces.size() == 3
      ? pieces[2].split('\\.')
      : new List<String>{ '0' };
    Integer millis = seconds.size() == 2
      ? Integer.valueOf(seconds[1].rightPad(3, '0').left(3))
      : 0;
    Integer hour = Integer.valueOf(pieces[0]);
    Integer minute = Integer.valueOf(pieces[1]);
    Integer second = Integer.valueOf(seconds[0]);
    if (hour > 23 || minute > 59 || second > 59) {
      throw new ChronoException('Time components are out of range.');
    }
    return Time.newInstance(hour, minute, second, millis);
  }

  public static Datetime parseLocal(String value) {
    ChronoSupport.requireValue(value, 'Local datetime');
    List<String> pieces = value.split('T');
    if (pieces.size() != 2) {
      throw new ChronoException(
        'Expected dateTtime without an offset or zone.'
      );
    }
    return Datetime.newInstanceGmt(parseDate(pieces[0]), parseTime(pieces[1]));
  }
  public static Datetime parseInstant(String value) {
    ChronoSupport.requireValue(value, 'Instant');
    Matcher parts = Pattern.compile('^(.+T.+)(Z|[+-]\\d{2}:\\d{2})$')
      .matcher(value);
    if (!parts.matches()) {
      throw new ChronoException(
        'An instant requires Z or a numeric UTC offset.'
      );
    }
    return parseLocal(parts.group(1))
      .addSeconds(-offsetSeconds(parts.group(2)));
  }
  public static Integer offsetSeconds(String value) {
    if (value == 'Z') {
      return 0;
    }
    ChronoSupport.requireMatch(value, '[+-]\\d{2}:\\d{2}', 'UTC offset');
    Integer hours = Integer.valueOf(value.substring(1, 3));
    Integer minutes = Integer.valueOf(value.substring(4, 6));
    if (hours > 23 || minutes > 59) {
      throw new ChronoException('UTC offset out of range.');
    }
    return (value.startsWith('-') ? -1 : 1) * (hours * 3600 + minutes * 60);
  }
}
