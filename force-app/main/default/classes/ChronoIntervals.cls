// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Pure half-open interval set operations shared by ranges and availability. */
public with sharing class ChronoIntervals { // NOPMD -- Aggregate covers independent interval-set operations; method complexity rules remain active.
  public class Span {
    public Long start;
    public Long finish;
  }
  public static Span span(Long start, Long finish) {
    if (start == null || finish == null || finish < start) {
      throw new ChronoException('Range end must be on or after its start.');
    }
    Span result = new Span();
    result.start = start;
    result.finish = finish;
    return result;
  }
  private class SpanComparator implements Comparator<Span> {
    public Integer compare(Span left, Span right) {
      ChronoSupport.requireValue(left, 'Interval');
      ChronoSupport.requireValue(right, 'Interval');
      Integer compared = ChronoFlowCompare.compareLong(left.start, right.start);
      return compared == 0
        ? ChronoFlowCompare.compareLong(left.finish, right.finish)
        : compared;
    }
  }
  public static List<Span> unionSpans(List<Span> input) {
    List<Span> sorted = new List<Span>();
    ChronoSupport.requireValue(input, 'Intervals');
    for (Span item : input) {
      ChronoSupport.requireValue(item, 'Interval');
      sorted.add(span(item.start, item.finish));
    }
    sorted.sort(new SpanComparator());
    List<Span> result = new List<Span>();
    for (Span item : sorted) {
      if (item.start == item.finish) {
        continue;
      }
      if (result.isEmpty() || item.start > result[result.size() - 1].finish) {
        result.add(span(item.start, item.finish));
      } else {
        result[result.size() - 1].finish = Math.max(
          result[result.size() - 1].finish,
          item.finish
        );
      }
    }
    return result;
  }
  public static List<Span> intersect(List<Span> a, List<Span> b) {
    a = unionSpans(a);
    b = unionSpans(b);
    List<Span> result = new List<Span>();
    Integer i = 0;
    Integer j = 0;
    while (i < a.size() && j < b.size()) {
      Long lower = Math.max(a[i].start, b[j].start);
      Long upper = Math.min(a[i].finish, b[j].finish);
      if (lower < upper) {
        result.add(span(lower, upper));
      }
      if (a[i].finish < b[j].finish) {
        i++;
      } else {
        j++;
      }
    }
    return result;
  }
  public static List<Span> subtract(List<Span> available, List<Span> busy) {
    available = unionSpans(available);
    busy = unionSpans(busy);
    List<Span> result = new List<Span>();
    Integer index = 0;
    for (Span item : available) {
      Long cursor = item.start;
      while (index < busy.size() && busy[index].finish <= cursor) {
        index++;
      }
      Integer next = index;
      while (next < busy.size() && busy[next].start < item.finish) {
        if (busy[next].start > cursor) {
          result.add(span(cursor, Math.min(busy[next].start, item.finish)));
        }
        cursor = Math.max(cursor, busy[next].finish);
        next++;
      }
      if (cursor < item.finish) {
        result.add(span(cursor, item.finish));
      }
    }
    return result;
  }
  public static Long length(List<Span> input) {
    Long total = 0;
    for (Span item : unionSpans(input)) {
      total += item.finish - item.start;
    }
    return total;
  }
  /** @description A slash inside a bracketed zone ID does not separate endpoints. */
  public static List<String> endpoints(String value) {
    ChronoSupport.requireValue(value, 'ISO interval');
    Integer separator = findSeparator(value);
    if (separator < 1 || separator == value.length() - 1) {
      throw new ChronoException('Use an ISO start/end interval.');
    }
    return new List<String>{
      value.substring(0, separator),
      value.substring(separator + 1)
    };
  }
  private static Integer findSeparator(String value) {
    Map<String, Integer> brackets = new Map<String, Integer>{
      '[' => 1,
      ']' => -1
    };
    Integer nesting = 0;
    Integer separator = -1;
    for (Integer i = 0; i < value.length(); i++) {
      String character = value.substring(i, i + 1);
      nesting += brackets.containsKey(character) ? brackets.get(character) : 0;
      if (character == '/' && nesting == 0) {
        if (separator >= 0) {
          throw new ChronoException(
            'Supply exactly two ISO interval endpoints.'
          );
        }
        separator = i;
      }
    }
    if (nesting != 0) {
      throw new ChronoException('Unbalanced timezone brackets.');
    }
    return separator;
  }
  public static Integer resultLimit(Integer value) {
    Integer result = value == null ? 100 : value;
    if (result < 1 || result > 1000) {
      throw new ChronoException('Maximum results must be 1–1000.');
    }
    return result;
  }
}
