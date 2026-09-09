// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import getTimeZones from "@salesforce/apex/ChronoPickerController.getTimeZones";
import {
  types,
  formats,
  sourceFormats,
  sourceFields,
  operationFields
} from "./fields";
import {
  operationTitles,
  allowedTypes,
  operationSources,
  additionalFields
} from "./operationFields";
/** Shared custom property editor for Chrono actions. Persists only declared invocable inputs. */
export default class ChronoFlowActionEditor extends LightningElement {
  @api kind;
  @api collection = false;
  @api builderContext;
  @api automaticOutputVariables;
  @api elementInfo;
  inputs = [];
  formatChoices = {};
  amountChoice;
  scheduleChoice;
  zones = [];
  zoneError = "";
  errors = [];
  @api get inputVariables() {
    return this.inputs;
  }
  set inputVariables(value) {
    this.inputs = JSON.parse(JSON.stringify(value || []));
  }
  connectedCallback() {
    getTimeZones()
      .then((values) => {
        this.zones = (values || []).map((value) => ({ value, label: value }));
      })
      .catch((error) => {
        this.zoneError = error.body?.message || error.message;
      });
  }
  input(name) {
    return this.inputs.find((item) => item.name === name);
  }
  value(name) {
    return this.input(name)?.value;
  }
  reference(name) {
    return this.input(name)?.valueDataType === "reference";
  }
  get title() {
    return (
      operationTitles[this.kind] ||
      {
        Convert: "Convert date/time",
        Adjust: "Add or subtract time",
        Difference: "Elapsed or working difference",
        WorkingTime: "Add or subtract working time"
      }[this.kind]
    );
  }
  get hasType() {
    return (
      ["Convert", "Adjust"].includes(this.kind) ||
      Boolean(operationTitles[this.kind])
    );
  }
  get isAdjust() {
    return this.kind === "Adjust";
  }
  get type() {
    return this.reference("valueType") ? "" : this.value("valueType");
  }
  get typeOptions() {
    if (operationTitles[this.kind]) return allowedTypes(this.kind);
    return this.kind === "Adjust"
      ? types.filter((item) => item.value !== "PlainMonthDay")
      : types;
  }
  get typeField() {
    return this.view({
      name: "valueType",
      label: "Value type",
      dataType: "String",
      options: this.typeOptions
    });
  }
  get sourceGroups() {
    if (operationTitles[this.kind]) return operationSources(this);
    const prefixes = this.hasType
      ? [""]
      : this.kind === "Difference"
        ? ["start", "end"]
        : ["start"];
    return prefixes.map((prefix) => {
      const native = prefix ? `${prefix}Instant` : "instantValue";
      const selected =
        this.formatChoices[prefix] ||
        (this.value(native)
          ? "datetime"
          : this.value(prefix ? `${prefix}Date` : "dateValue")
            ? "date"
            : "iso");
      return {
        key: prefix || "source",
        prefix,
        format: selected,
        label: prefix
          ? `${prefix === "start" ? "Start" : "End"} input format`
          : "Input format",
        options: prefix ? formats : sourceFormats(this.type),
        fields: sourceFields(selected, prefix, this.type).map((item) =>
          this.view(item)
        )
      };
    });
  }
  get amountMode() {
    return this.amountChoice || (this.value("duration") ? "duration" : "units");
  }
  get amountOptions() {
    return [
      { label: "Amount and unit", value: "units" },
      { label: "ISO duration", value: "duration" }
    ];
  }
  get fields() {
    if (operationTitles[this.kind])
      return additionalFields(this).map((item) => this.view(item));
    return operationFields(
      this.kind,
      this.type,
      this.value("targetType") || this.type,
      this.amountMode,
      this.value("scheduleType"),
      this.reference("valueType")
    ).map((item) => this.view(item));
  }
  get hasSchedule() {
    return [
      "WorkingTime",
      "Difference",
      "CheckWorkingTime",
      "FindWorkingTime"
    ].includes(this.kind);
  }
  get scheduleIdName() {
    return this.kind === "WorkingTime" ? "scheduleId" : "operatingHoursId";
  }
  get savedOnly() {
    return (
      this.kind === "WorkingTime" &&
      (this.reference("scheduleType") ||
        this.value("scheduleType") === "BusinessHours")
    );
  }
  get scheduleMode() {
    if (this.savedOnly) return "saved";
    return (
      this.scheduleChoice ||
      (["operatingHours", "timeSlots", "holidays"].some((name) =>
        this.value(name)
      )
        ? "records"
        : this.value(this.scheduleIdName) || this.kind !== "Difference"
          ? "saved"
          : "none")
    );
  }
  get scheduleOptions() {
    return [
      ...(this.kind === "Difference"
        ? [{ label: "All elapsed time", value: "none" }]
        : []),
      { label: "Saved schedule ID", value: "saved" },
      ...(!this.savedOnly
        ? [{ label: "OperatingHours and related records", value: "records" }]
        : [])
    ];
  }
  get scheduleFields() {
    if (!this.hasSchedule || this.scheduleMode === "none") return [];
    const fields =
      this.scheduleMode === "saved"
        ? [
            {
              name: this.scheduleIdName,
              label: this.savedOnly
                ? "Schedule record ID"
                : "OperatingHours ID",
              dataType: "String",
              required: true,
              helpText:
                "Saved readable schedule. Slots and holidays are loaded together for the batch."
            }
          ]
        : [
            {
              name: "operatingHours",
              label: "OperatingHours record",
              dataType: "SObject",
              objectType: "OperatingHours",
              required: true
            },
            {
              name: "timeSlots",
              label: "Time slots",
              dataType: "SObject[]",
              objectType: "TimeSlot",
              required: true
            },
            {
              name: "holidays",
              label: "Holidays (optional)",
              dataType: "SObject[]",
              objectType: "Holiday"
            }
          ].map((item) => ({
            ...item,
            referenceOnly: true,
            helpText:
              "Use native Flow records, including unsaved records. The schedule supplies its own timezone; no queries or DML."
          }));
    return fields.map((item) => this.view(item));
  }
  changeSchedule(event) {
    this.scheduleChoice = event.detail.value;
    for (const name of [
      this.scheduleIdName,
      "operatingHours",
      "timeSlots",
      "holidays"
    ])
      this.remove(name);
  }
  get collectionType() {
    return `Chrono${this.kind === "WorkingTime" ? "WorkingTime" : this.kind}Input`;
  }
  get collectionValue() {
    return this.value("items");
  }
  get errorList() {
    return this.errors.map((item, index) => ({ ...item, id: String(index) }));
  }
  needsLocalZone(prefix) {
    const group = this.sourceGroups.find((item) => item.prefix === prefix);
    if (group?.format === "date") return true;
    if (this.reference(`${prefix}Value`)) return false;
    const text = String(this.value(`${prefix}Value`) || "");
    return /^\d{4}-\d{2}-\d{2}(?:T[\d:.]+)?$/.test(text);
  }
  view(field) {
    return {
      ...field,
      required:
        field.required ||
        (this.kind === "Difference" &&
          field.name === "timeZoneId" &&
          (this.needsLocalZone("start") ||
            (this.needsLocalZone("end") && !this.value("endTimeZoneId")))),
      value: this.value(field.name),
      reference: this.reference(field.name),
      options: field.searchable ? this.zones : field.options || [],
      lookupMessage: field.searchable ? this.zoneError : ""
    };
  }
  changeFormat(event) {
    const prefix = event.target.dataset.prefix;
    this.formatChoices = {
      ...this.formatChoices,
      [prefix]: event.detail.value
    };
    for (const name of prefix
      ? [`${prefix}Value`, `${prefix}Instant`, `${prefix}Date`, `${prefix}Time`]
      : ["value", "instantValue", "dateValue", "timeValue"])
      this.remove(name);
  }
  changeAmount(event) {
    this.amountChoice = event.detail.value;
    for (const name of this.amountChoice === "duration"
      ? ["amount", "unit"]
      : ["duration"])
      this.remove(name);
  }
  handleValue(event) {
    const { name, value, reference, dataType } = event.detail;
    // Preserve the representation when Flow removes an old reference. An empty
    // native binding is still a native input until the admin changes its format.
    for (const group of this.sourceGroups)
      if (group.fields.some((field) => field.name === name))
        this.formatChoices = {
          ...this.formatChoices,
          [group.prefix]: group.format
        };

    if (value === null || value === "") this.remove(name);
    else this.change(name, value, reference ? "reference" : dataType);
    if (name === "endValueType") {
      this.formatChoices = { ...this.formatChoices, end: undefined };
      for (const old of ["endValue", "endInstant", "endDate", "endTime"])
        this.remove(old);
    }
    if (name === "valueType") {
      this.formatChoices = {};
      if (this.kind === "Compare" && !reference) {
        if (
          !["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"].includes(
            value
          )
        ) {
          this.remove("comparisonPeriod");
          this.remove("weekStartsOn");
        }
        if (["PlainMonthDay", "PlainYearMonth"].includes(value))
          this.remove("toleranceMilliseconds");
      }
      for (const old of [
        "value",
        "instantValue",
        "dateValue",
        "timeValue",
        ...(operationTitles[this.kind] && !this.value("endValueType")
          ? ["endValue", "endInstant", "endDate", "endTime"]
          : [])
      ])
        this.remove(old);
    }
    if (name === "scheduleType" && (reference || value === "BusinessHours")) {
      this.scheduleChoice = "saved";
      for (const old of ["operatingHours", "timeSlots", "holidays"])
        this.remove(old);
    }
    this.errors = [];
  }
  chooseCollection(event) {
    this.handleValue({
      detail: {
        name: "items",
        value: event.detail.value,
        reference: true,
        dataType: "Apex"
      }
    });
  }
  // Flow Builder requires these configuration events to bubble across shadow roots.
  change(name, value, dataType) {
    this.inputs = [
      ...this.inputs.filter((item) => item.name !== name),
      { name, value, valueDataType: dataType }
    ];
    const eventName = "configuration_editor_input_value_changed";
    // prettier-ignore
    this.dispatchEvent(
      new CustomEvent(eventName, { // NOPMD -- Required Flow Builder event propagation.
        detail: { name, newValue: value, newValueDataType: dataType },
        bubbles: true,
        composed: true
      })
    );
  }
  remove(name) {
    if (!this.input(name)) return;
    this.inputs = this.inputs.filter((item) => item.name !== name);
    const eventName = "configuration_editor_input_value_deleted";
    // prettier-ignore
    this.dispatchEvent(
      new CustomEvent(eventName, { // NOPMD -- Required Flow Builder event propagation.
        detail: { name },
        bubbles: true,
        composed: true
      })
    );
  }
  @api validate() {
    const required = this.collection
      ? [{ name: "items", label: "Input collection", required: true }]
      : [
          ...(this.hasType
            ? [{ name: "valueType", label: "Value type", required: true }]
            : []),
          ...this.sourceGroups.flatMap((group) => group.fields),
          ...this.fields,
          ...this.scheduleFields
        ];
    this.errors = required
      .filter(
        (field) =>
          field.required &&
          (this.value(field.name) == null || this.value(field.name) === "")
      )
      .map((field) => ({
        key: field.name,
        errorString: `Choose ${field.label.toLowerCase()}.`
      }));
    const amount = this.value("amount");
    if (
      !this.collection &&
      !this.reference("amount") &&
      amount != null &&
      amount !== "" &&
      !Number.isInteger(Number(amount))
    )
      this.errors = [
        ...this.errors,
        { key: "amount", errorString: "Enter a whole-number amount." }
      ];
    for (const name of ["increment", "weekStartsOn"]) {
      const value = this.value(name);
      if (
        !this.reference(name) &&
        value != null &&
        value !== "" &&
        (!Number.isInteger(Number(value)) ||
          Number(value) < 1 ||
          (name === "weekStartsOn" && Number(value) > 7))
      )
        this.errors = [
          ...this.errors,
          {
            key: name,
            errorString:
              name === "weekStartsOn"
                ? "Enter a weekday from 1 to 7."
                : "Enter a positive whole-number increment."
          }
        ];
    }
    return this.errors;
  }
}
