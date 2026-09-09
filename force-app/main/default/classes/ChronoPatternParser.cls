// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit numeric-pattern parsing; no locale guessing or rollover. */
public with sharing class ChronoPatternParser {
  private static final List<String> PATTERN_PARTS = new List<String>{
    'yyyy',
    'SSS',
    'MM',
    'dd',
    'HH',
    'mm',
    'ss'
  };
  public static ChronoOperationResult parse(ChronoValueFields input) {
    ChronoSupport.requireValue(input.text, 'Text');
    ChronoSupport.requireValue(input.pattern, 'Input pattern');
    List<String> captures = new List<String>();
    String regex = compile(input.pattern, captures);
    Matcher matched = Pattern.compile(regex + '$').matcher(input.text);
    if (!matched.matches()) {
      throw new ChronoException(
        'Text does not match the specified input pattern.'
      );
    }
    Map<String, Integer> values = new Map<String, Integer>();
    for (Integer i = 0; i < captures.size(); i++) {
      values.put(captures[i], Integer.valueOf(matched.group(i + 1)));
    }
    input.year = values.get('yyyy');
    input.month = values.get('MM');
    input.day = values.get('dd');
    input.hour = values.get('HH');
    input.minute = values.get('mm');
    input.second = values.get('ss');
    input.millisecond = values.get('SSS');
    return ChronoValueConstruction.create(input);
  }
  private static String compile(String pattern, List<String> captures) {
    PatternState state = new PatternState(pattern, captures);
    while (state.index < pattern.length()) {
      state.next();
    }
    return state.regex;
  }
  private class PatternState {
    private final String pattern;
    private final List<String> captures;
    private Integer index = 0;
    private String regex = '^';
    private PatternState(String pattern, List<String> captures) {
      this.pattern = pattern;
      this.captures = captures;
    }
    private void next() {
      String part = tokenAt(pattern, index);
      if (part != null) {
        if (captures.contains(part)) {
          throw new ChronoException('Duplicate pattern token: ' + part);
        }
        captures.add(part);
        regex += '(\\d{' + part.length() + '})';
        index += part.length();
        return;
      }
      String literal = pattern.substring(index, index + 1);
      if (literal == '\'') {
        quoted();
        return;
      }
      if (System.Pattern.matches('[A-Za-z]', literal)) {
        throw new ChronoException(
          'Unsupported pattern token; quote literal letters.'
        );
      }
      regex += escaped(literal);
      index++;
    }
    private void quoted() {
      index++;
      if (
        index < pattern.length() &&
        pattern.substring(index, index + 1) == '\''
      ) {
        regex += escaped('\'');
        index++;
        return;
      }
      while (index < pattern.length()) {
        String literal = pattern.substring(index, index + 1);
        index++;
        if (literal == '\'') {
          if (
            index >= pattern.length() ||
            pattern.substring(index, index + 1) != '\''
          ) {
            return;
          }
          index++;
        }
        regex += escaped(literal);
      }
      throw new ChronoException('Unclosed quoted pattern literal.');
    }
  }
  private static String tokenAt(String pattern, Integer index) {
    for (String token : PATTERN_PARTS) {
      if (pattern.substring(index).startsWith(token)) {
        return token;
      }
    }
    return null;
  }
  private static String escaped(String value) {
    return '\\.^$|?*+()[]{}'.contains(value) ? '\\' + value : value;
  }
}
