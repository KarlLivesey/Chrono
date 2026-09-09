// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description User-mode operating-hours selection with structured, bound criteria. */
public with sharing class ChronoPickerScheduleQuery {
  private final List<Id> allowedIds;
  private final String filterJSON;
  public ChronoPickerScheduleQuery(List<Id> ids, String filter) {
    allowedIds = ids;
    filterJSON = filter;
  }
  public List<OperatingHours> selectHours(String searchTerm, Id selectedId) {
    List<String> clauses = new List<String>();
    Map<String, Object> bindings = new Map<String, Object>();
    if (allowedIds != null) {
      clauses.add('Id IN :allowed');
      bindings.put('allowed', allowedIds);
    }
    if (selectedId != null) {
      clauses.add('Id = :selected');
      bindings.put('selected', selectedId);
    }
    if (String.isNotBlank(searchTerm)) {
      clauses.add('Name LIKE :search');
      bindings.put('search', '%' + escapeLike(searchTerm) + '%');
    }
    addFilter(filterJSON, clauses, bindings);
    String query =
      'SELECT Id, Name, TimeZone FROM OperatingHours' +
      (clauses.isEmpty() ? '' : ' WHERE ' + String.join(clauses, ' AND ')) +
      ' ORDER BY Name, Id LIMIT 50';
    return Database.queryWithBinds(query, bindings, AccessLevel.USER_MODE);
  }
  private static void addFilter(
    String filterJSON,
    List<String> clauses,
    Map<String, Object> bindings
  ) {
    if (String.isBlank(filterJSON)) {
      return;
    }
    Map<String, Object> filter = (Map<String, Object>) JSON.deserializeUntyped(
      filterJSON
    );
    List<Object> criteria = filterCriteria(filter);
    List<String> expressions = new List<String>();
    for (Object raw : criteria) {
      expressions.add(criterion((Map<String, Object>) raw, bindings));
    }
    clauses.add('(' + String.join(expressions, ' AND ') + ')');
  }
  private static List<Object> filterCriteria(Map<String, Object> filter) {
    if (
      filter == null ||
      filter.size() != 1 ||
      !filter.containsKey('criteria')
    ) {
      throw new ChronoException(
        'OperatingHours filter requires criteria combined with AND.'
      );
    }
    List<Object> criteria = (List<Object>) filter.get('criteria');
    if (criteria == null || criteria.isEmpty() || criteria.size() > 10) {
      throw new ChronoException(
        'Provide between 1 and 10 OperatingHours filter criteria.'
      );
    }
    return criteria;
  }
  private static String criterion(
    Map<String, Object> item,
    Map<String, Object> bindings
  ) {
    String field = (String) item.get('fieldPath');
    String operator = (String) item.get('operator');
    String value = (String) item.get('value');
    if (
      !new Set<String>{ 'Name', 'TimeZone' }.contains(field) ||
      !new Set<String>{ 'eq', 'ne', 'contains', 'startsWith' }
        .contains(operator) ||
      value == null
    ) {
      throw new ChronoException(
        'OperatingHours filters support Name/TimeZone and eq, ne, contains or startsWith with a string value.'
      );
    }
    String bindName = 'criterion' + bindings.size();
    String comparison = operator == 'eq'
      ? ' = '
      : operator == 'ne' ? ' != ' : ' LIKE ';
    String bound = operator == 'contains'
      ? '%' + escapeLike(value) + '%'
      : operator == 'startsWith' ? escapeLike(value) + '%' : value;
    String expression = field + comparison + ':' + bindName;
    bindings.put(bindName, bound);
    return expression;
  }
  private static String escapeLike(String value) {
    return value.replace('\\', '\\\\').replace('%', '\\%').replace('_', '\\_');
  }
}
