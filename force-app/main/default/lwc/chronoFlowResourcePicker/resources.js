// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
export function normalType(type = "") {
  const names = {
    string: "String",
    text: "String",
    boolean: "Boolean",
    date: "Date",
    datetime: "DateTime",
    sobject: "SObject",
    apex: "Apex",
    apexdefined: "Apex",
    number: "Number",
    integer: "Number",
    double: "Number"
  };
  return names[type.toLowerCase()] || type;
}
function className(name = "") {
  return name.replace(/^apex:\/\//, "").replace(/^skel[.__]+/, "");
}
export function matches(item, valueType, objectType) {
  if (Boolean(item.isCollection) !== valueType.endsWith("[]")) return false;
  const kind = normalType(valueType.replace("[]", ""));
  return (
    normalType(item.dataType) === kind &&
    (!objectType ||
      (kind === "Apex"
        ? className(item.objectType || item.apexClass) === className(objectType)
        : item.objectType === objectType))
  );
}
export function roots(context = {}, outputs = {}) {
  const result = [];
  for (const [key, group] of [
    ["variables", "Variables"],
    ["formulas", "Formulas"],
    ["constants", "Constants"]
  ]) {
    for (const item of context[key] || [])
      result.push({
        ...item,
        value: item.name,
        label: item.label || item.name,
        group,
        objectType: item.objectType || item.apexClass
      });
  }
  for (const item of context.recordLookups || []) {
    if (item.storeOutputAutomatically === false) continue;
    result.push({
      value: item.name,
      label: item.label || item.name,
      group: "Get Records",
      dataType: "SObject",
      objectType: item.object,
      isCollection: !item.getFirstRecordOnly
    });
  }
  for (const [key, values] of Object.entries(outputs || {})) {
    if (Array.isArray(values) && !key.includes("."))
      result.push({
        value: key,
        label: key,
        group: "Element outputs",
        children: true
      });
  }
  result.push({
    value: "$User",
    label: "Running user",
    group: "Global resources",
    dataType: "SObject",
    objectType: "User"
  });
  if (context.start?.object)
    result.push({
      value: "$Record",
      label: "Triggering record",
      group: "Global resources",
      dataType: "SObject",
      objectType: context.start.object
    });
  result.push(
    {
      value: "$Flow.CurrentDate",
      label: "Current date",
      dataType: "Date",
      group: "Global resources"
    },
    {
      value: "$Flow.CurrentDateTime",
      label: "Current date/time",
      dataType: "DateTime",
      group: "Global resources"
    }
  );
  return [...new Map(result.map((item) => [item.value, item])).values()];
}
export function outputChildren(path, outputs) {
  return (outputs[path] || []).map((item) => {
    const value = `${path}.${item.apiName || item.name}`;
    return {
      value,
      label: item.label || item.apiName || item.name,
      dataType: normalType(item.dataType),
      objectType: item.sobjectType || item.subtype,
      isCollection:
        item.maxOccurs === -1 ||
        item.maxOccurs > 1 ||
        item.isCollection === true,
      children: Array.isArray(outputs[value]),
      group: path
    };
  });
}
