// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import catalogue from "c/chronoCatalogueSchema";
import getTimeZones from "@salesforce/apex/ChronoPickerController.getTimeZones";
const sourceNames = ["value", "dateValue", "timeValue", "instantValue"];
const labels = {
  PlainDate: "Date",
  PlainDateTime: "Local date and time",
  PlainTime: "Time",
  PlainYearMonth: "Year and month",
  PlainMonthDay: "Month and day",
  Instant: "Instant",
  ZonedDateTime: "Zoned date and time",
  Duration: "Duration",
  fromEpoch: "From Unix timestamp",
  toEpoch: "To Unix timestamp",
  reject: "Reject invalid or ambiguous values",
  constrain: "Constrain to a valid date",
  earlier: "First occurrence",
  later: "Second occurrence"
};
/** Schema-driven configuration using the shared Salesforce literal/resource controls. */
export default class ChronoCatalogueEditor extends LightningElement {
  @api kind;
  @api fixedOperation;
  @api collection = false;
  @api builderContext;
  @api automaticOutputVariables;
  @api elementInfo;
  inputs = [];
  formatChoice;
  endFormatChoice;
  scheduleChoice;
  auxiliaryChoices = {};
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
        this.zones = (values || []).map((value) => ({ label: value, value }));
      })
      .catch((error) => {
        this.zoneError = error.body?.message || error.message;
      });
  }
  get definition() {
    const definition = catalogue.find((item) => item.family === this.kind);
    if (!definition || !this.fixedOperation) return definition;
    return {
      ...definition,
      fields: [
        ...definition.fields,
        {
          name: "label",
          type: "String",
          label: "Screen label",
          help: "Label shown above the appointment lookup.",
          group: "Screen"
        },
        {
          name: "required",
          type: "Boolean",
          label: "Require an appointment",
          help: "The user must choose an available appointment to continue.",
          group: "Screen"
        },
        {
          name: "disabled",
          type: "Boolean",
          label: "Read only",
          help: "Disable appointment changes.",
          group: "Screen"
        }
      ]
    };
  }
  get title() {
    return this.definition?.title;
  }
  get collectionType() {
    return `skel__Chrono${this.kind}Input`;
  }
  get collectionValue() {
    return this.value("items");
  }
  input(name) {
    return this.inputs.find((item) => item.name === name);
  }
  value(name) {
    return name === "operation" && this.fixedOperation
      ? this.fixedOperation
      : this.input(name)?.value;
  }
  reference(name) {
    return this.input(name)?.valueDataType === "reference";
  }
  get type() {
    return this.reference("valueType") ? "" : this.value("valueType");
  }
  get format() {
    return (
      this.formatChoice ||
      (this.value("instantValue") || this.value("datetimes")
        ? "datetime"
        : this.value("dateValue") || this.value("dates")
          ? "date"
          : "iso")
    );
  }
  get formatOptions() {
    return [
      { value: "iso", label: "ISO text" },
      ...(["Instant", "ZonedDateTime"].includes(this.type) || !this.type
        ? [{ value: "datetime", label: "Salesforce Datetime" }]
        : []),
      ...([
        "PlainDate",
        "PlainDateTime",
        "PlainYearMonth",
        "PlainMonthDay"
      ].includes(this.type) || !this.type
        ? [{ value: "date", label: "Salesforce Date" }]
        : [])
    ];
  }
  get hasSource() {
    if (this.kind === "CollectionTools") return true;
    return this.definition?.fields.some(
      (field) => field.sourceFormat && this.condition(field)
    );
  }
  condition(field) {
    return (
      (!field.appliesTo || !this.type || field.appliesTo.includes(this.type)) &&
      Object.entries(field.when || {}).every(
        ([name, values]) =>
          this.reference(name) || values.includes(this.value(name))
      )
    );
  }
  get hasEndSource() {
    return this.definition?.fields.some(
      (field) => field.endpointFormat && this.condition(field)
    );
  }
  get endFormat() {
    return (
      this.endFormatChoice ||
      (this.value("endInstant")
        ? "datetime"
        : this.value("endDate")
          ? "date"
          : "iso")
    );
  }
  changeEndFormat(event) {
    this.endFormatChoice = event.detail.value;
    for (const name of ["endValue", "endDate", "endInstant", "endTime"])
      this.remove(name);
  }
  get hasSchedule() {
    return (
      this.kind === "Availability" ||
      (this.kind === "Recurrence" &&
        (this.value("operation") === "nthWorkingDay" ||
          this.reference("closedPolicy") ||
          ["skip", "next", "previous"].includes(this.value("closedPolicy"))))
    );
  }
  get scheduleMode() {
    return (
      this.scheduleChoice || (this.value("operatingHours") ? "records" : "id")
    );
  }
  get scheduleOptions() {
    return [
      { label: "Saved OperatingHours ID", value: "id" },
      { label: "Supplied native records", value: "records" }
    ];
  }
  changeScheduleMode(event) {
    this.scheduleChoice = event.detail.value;
    for (const name of [
      "operatingHoursId",
      "operatingHours",
      "timeSlots",
      "holidays"
    ])
      this.remove(name);
  }
  auxiliaryFormat(group) {
    if (this.auxiliaryChoices[group]) return this.auxiliaryChoices[group];
    const fields = this.definition.fields.filter(
      (field) => field.auxiliaryGroup === group
    );
    return (
      fields.find(
        (field) =>
          ["date", "datetime"].includes(field.auxiliaryFormat) &&
          this.value(field.name)
      )?.auxiliaryFormat || "iso"
    );
  }
  get auxiliarySources() {
    return this.definition?.fields
      .filter(
        (field) => field.auxiliaryFormat === "iso" && this.condition(field)
      )
      .map((field) => ({
        name: field.auxiliaryGroup,
        label: `${field.sourceLabel} input format`,
        value: this.auxiliaryFormat(field.auxiliaryGroup),
        options: this.formatOptions
      }));
  }
  changeAuxiliaryFormat(event) {
    const group = event.target.dataset.group;
    this.auxiliaryChoices = {
      ...this.auxiliaryChoices,
      [group]: event.detail.value
    };
    for (const field of this.definition.fields.filter(
      (item) => item.auxiliaryGroup === group
    ))
      this.remove(field.name);
  }
  fieldOptions(field) {
    if (field.optionsByOperation && !this.reference("operation"))
      return (
        field.optionsByOperation[this.value("operation")] || field.options || []
      );
    return field.options || [];
  }
  visible(field) {
    if (this.kind === "TimeAllocation" && field.name === "holidays")
      return true;
    if (
      ["operatingHoursId", "operatingHours", "timeSlots", "holidays"].includes(
        field.name
      )
    )
      return (
        this.hasSchedule &&
        (this.scheduleMode === "id"
          ? field.name === "operatingHoursId"
          : field.name !== "operatingHoursId")
      );
    if (
      this.kind === "CollectionTools" &&
      ["values", "dates", "datetimes"].includes(field.name)
    )
      return (
        field.name ===
        { iso: "values", date: "dates", datetime: "datetimes" }[this.format]
      );

    if (field.hidden) return false;
    if (field.auxiliaryGroup) {
      const format = this.auxiliaryFormat(field.auxiliaryGroup);
      return (
        this.condition(field) &&
        (field.auxiliaryFormat === format ||
          (format === "date" &&
            field.auxiliaryFormat === "dateTime" &&
            (!this.type || this.type === "PlainDateTime")))
      );
    }
    if (field.endpointFormat)
      return (
        this.condition(field) &&
        (field.endpointFormat === this.endFormat ||
          (field.endpointFormat === "dateTime" &&
            this.endFormat === "date" &&
            (!this.type || this.type === "PlainDateTime")))
      );

    if (!this.condition(field)) return false;
    if (field.sourceFormat)
      return (
        field.sourceFormat === this.format ||
        (field.sourceFormat === "dateTime" &&
          this.format === "date" &&
          (this.type === "PlainDateTime" || !this.type))
      );
    return true;
  }
  get fields() {
    return (this.definition?.fields || [])
      .filter(
        (field) =>
          this.visible(field) &&
          !(this.fixedOperation && field.name === "operation")
      )
      .map((field) => ({
        ...field,
        value:
          this.value(field.name) ??
          this.value(field.textAlternative) ??
          field.default,
        reference: this.reference(field.name),
        dataType:
          {
            Integer: "Number",
            Decimal: "Number",
            Long: "Number",
            Datetime: "DateTime"
          }[field.type] ||
          (field.objectType
            ? field.type.startsWith("List<")
              ? "SObject[]"
              : "SObject"
            : null) ||
          (field.type.startsWith("List<")
            ? `${{ Datetime: "DateTime", Integer: "Number", Long: "Number", Decimal: "Number" }[field.type.slice(5, -1)] || field.type.slice(5, -1)}[]`
            : field.type),
        referenceOnly:
          Boolean(field.objectType) ||
          (field.type.startsWith("List<") && !field.textAlternative),
        options: field.searchable
          ? this.zones
          : this.fieldOptions(field).map((value) => ({
              value,
              label:
                labels[value] ||
                value
                  .replace(/([a-z])([A-Z])/g, "$1 $2")
                  .replace(/^./, (c) => c.toUpperCase())
            })),
        helpText: field.help,
        lookupMessage: field.searchable ? this.zoneError : "",
        required:
          field.required ||
          ["operatingHoursId", "operatingHours"].includes(field.name) ||
          (this.kind === "CollectionTools" &&
            ["values", "dates", "datetimes"].includes(field.name)) ||
          Boolean(field.sourceFormat) ||
          (Boolean(field.endpointFormat) &&
            field.endpointFormat !== "dateTime") ||
          field.name === "valueType",
        literalType:
          field.literalType ||
          (field.textAlternative
            ? "textarea"
            : field.name === "timeValue"
              ? "time"
              : field.name === "value" && this.type === "PlainDate"
                ? "date"
                : "")
      }));
  }
  changeFormat(event) {
    this.formatChoice = event.detail.value;
    for (const name of this.kind === "CollectionTools"
      ? ["values", "valuesText", "dates", "datetimes"]
      : sourceNames)
      this.remove(name);
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
  handleValue(event) {
    let { name, dataType } = event.detail;
    const { value, reference } = event.detail;
    const descriptor = this.definition.fields.find(
      (field) => field.name === name
    );
    if (descriptor?.auxiliaryGroup)
      this.auxiliaryChoices = {
        ...this.auxiliaryChoices,
        [descriptor.auxiliaryGroup]: this.auxiliaryFormat(
          descriptor.auxiliaryGroup
        )
      };
    if (descriptor?.textAlternative) {
      const other = reference ? descriptor.textAlternative : name;
      name = reference ? name : descriptor.textAlternative;
      this.remove(other);
      if (!reference) dataType = "String";
    }
    if (
      [...sourceNames, "values", "valuesText", "dates", "datetimes"].includes(
        name
      )
    )
      this.formatChoice = this.format;
    if (value === null || value === "") this.remove(name);
    else {
      this.inputs = [
        ...this.inputs.filter((item) => item.name !== name),
        { name, value, valueDataType: reference ? "reference" : dataType }
      ];
      this.notify("configuration_editor_input_value_changed", {
        name,
        newValue: value,
        newValueDataType: reference ? "reference" : dataType
      });
    }
    if (name === "valueType") {
      this.auxiliaryChoices = {};
      for (const field of this.definition.fields.filter(
        (item) => item.auxiliaryGroup
      ))
        this.remove(field.name);
    }
    if (["valueType", "operation"].includes(name)) {
      this.formatChoice = undefined;
      const typeField = this.definition.fields.find(
        (field) => field.name === "valueType"
      );
      if (
        name === "operation" &&
        typeField &&
        this.type &&
        !this.fieldOptions(typeField).includes(this.type)
      ) {
        this.remove("valueType");
        this.auxiliaryChoices = {};
        for (const field of this.definition.fields)
          if (
            field.sourceFormat ||
            field.endpointFormat ||
            field.auxiliaryGroup ||
            ["values", "valuesText", "dates", "datetimes"].includes(field.name)
          )
            this.remove(field.name);
      }
      if (name === "valueType")
        for (const previous of this.kind === "CollectionTools"
          ? ["values", "valuesText", "dates", "datetimes"]
          : sourceNames)
          this.remove(previous);
      for (const field of this.definition.fields)
        if (!this.condition(field)) this.remove(field.name);
    }
    this.errors = [];
  }
  remove(name) {
    if (!this.input(name)) return;
    this.inputs = this.inputs.filter((item) => item.name !== name);
    this.notify("configuration_editor_input_value_deleted", { name });
  }
  notify(eventName, detail) {
    // Flow Builder requires configuration events to cross the editor shadow roots.
    // prettier-ignore
    this.dispatchEvent(new CustomEvent(eventName,{detail,bubbles:true,composed:true})); // NOPMD
  }
  @api validate() {
    const fields = this.collection
      ? [{ name: "items", label: "Input collection", required: true }]
      : this.fields;
    this.errors = fields
      .filter(
        (field) =>
          field.required &&
          ((field.value ?? this.value(field.name)) == null ||
            (field.value ?? this.value(field.name)) === "")
      )
      .map((field) => ({
        key: field.name,
        errorString: `Choose ${field.label.toLowerCase()}.`
      }));
    for (const field of fields)
      if (
        field.type === "Integer" &&
        !this.reference(field.name) &&
        this.value(field.name) != null &&
        !Number.isInteger(Number(this.value(field.name)))
      )
        this.errors.push({
          key: field.name,
          errorString: `${field.label} must be a whole number.`
        });
    for (const editor of this.template.querySelectorAll(
      "c-chrono-flow-value-editor"
    )) {
      const message = editor.validate();
      if (message && !this.errors.some((error) => error.key === editor.name))
        this.errors.push({ key: editor.name, errorString: message });
    }
    return this.errors;
  }
}
