// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import {
  scheduleModes,
  validDate,
  validTime,
  parseOffset
} from "c/chronoPickerEngine";

import { fields } from "./fieldDefinitions";
import { choices, hoursSetup, hoursModeFor } from "./editorState";
import getTimeZones from "@salesforce/apex/ChronoPickerController.getTimeZones";
import searchHours from "@salesforce/apex/ChronoPickerSchedules.searchHours";

const initialFixed = () => ({
  definition: { name: "Custom operating hours", timeZoneId: "Europe/London" },
  slots: [],
  holidays: []
});
export default class ChronoFlowDateTimeEditor extends LightningElement {
  _inputs = [];
  @api builderContext;
  @api automaticOutputVariables;
  @api elementInfo;
  errorMessage = "";
  fixed = initialFixed();
  filterRows = [];
  @api get inputVariables() {
    return this._inputs;
  }
  set inputVariables(value) {
    this._inputs = JSON.parse(JSON.stringify(value || []));
    try {
      this.fixed = this.value("fixedHours")
        ? JSON.parse(this.value("fixedHours"))
        : initialFixed();
    } catch {
      this.errorMessage = "The fixed-hours configuration is invalid.";
    }
    try {
      this.filterRows =
        JSON.parse(this.value("operatingHoursFilter") || '{"criteria":[]}')
          .criteria || [];
    } catch {
      this.filterRows = [];
    }
  }
  zoneIds = [];
  zoneSearch = "";
  zoneError = "";
  savedChoices = [];
  savedLabels = {};
  savedError = "";
  savedPending = false;
  _savedRevision = 0;
  _savedTimer;
  _zoneSourceChoice;
  _hoursSourceChoice;
  _hoursDataChoice;
  connectedCallback() {
    getTimeZones()
      .then((values) => {
        this.zoneIds = values || [];
      })
      .catch((error) => {
        this.zoneError = error.body?.message || error.message;
      });
    this.loadSavedLabels();
  }
  disconnectedCallback() {
    clearTimeout(this._savedTimer);
    this._savedRevision++;
  }
  get isDateTime() {
    return this.value("mode") !== "date" || this.reference("mode");
  }
  get zonePolicy() {
    return this.reference("allowTimeZoneSelection")
      ? "dynamic"
      : this.value("allowTimeZoneSelection")
        ? this.value("timeZoneSelectionMode") === "list"
          ? "list"
          : "all"
        : "fixed";
  }
  get zonePolicyOptions() {
    return choices([
      ["fixed", "Fixed timezone"],
      ["list", "Choose from a list"],
      ["all", "Any supported timezone"],
      ...(this.reference("allowTimeZoneSelection")
        ? [["dynamic", "Selection controlled by Flow"]]
        : [])
    ]);
  }
  get zoneSource() {
    return (
      this._zoneSourceChoice ||
      (this.reference(
        this.zonePolicy === "fixed" ? "timeZoneId" : "timeZoneIds"
      )
        ? "flow"
        : "here")
    );
  }
  get sourceOptions() {
    return choices([
      ["here", "Set here"],
      ["flow", "Flow resource"]
    ]);
  }
  get showZoneSource() {
    return ["fixed", "list"].includes(this.zonePolicy);
  }
  get showZoneList() {
    return this.showZoneSource && this.zoneSource === "here";
  }
  get zoneListLabel() {
    return this.zonePolicy === "fixed" ? "Timezone" : "Allowed timezones";
  }
  get selectedZoneItems() {
    return (
      this.zonePolicy === "fixed"
        ? [this.value("timeZoneId")].filter(Boolean)
        : this.fixedZoneIds
    ).map((value) => ({ value, label: value }));
  }
  get fixedZoneIds() {
    return String(this.value("timeZoneIdsText") || "")
      .split(/[\s,;]+/)
      .filter(Boolean);
  }
  get zoneChoices() {
    return this.zoneIds
      .filter((value) =>
        value.toLowerCase().includes(this.zoneSearch.toLowerCase())
      )
      .map((value) => ({ value, label: value }));
  }
  searchZones(event) {
    this.zoneSearch = event.detail.value;
  }
  addZone(event) {
    const value = event.detail.value;
    if (this.zonePolicy === "fixed") this.change("timeZoneId", value);
    else
      this.change(
        "timeZoneIdsText",
        [...new Set([...this.fixedZoneIds, value])].join("\n")
      );
  }
  removeZone(event) {
    if (this.zonePolicy === "fixed") this.removeInput("timeZoneId");
    else
      this.change(
        "timeZoneIdsText",
        this.fixedZoneIds
          .filter((value) => value !== event.detail.value)
          .join("\n")
      );
  }
  changeZonePolicy(event) {
    this._zoneSourceChoice = undefined;
    const policy = event.detail.value;
    this.change("allowTimeZoneSelection", policy !== "fixed", "Boolean");
    this.change("timeZoneSelectionMode", policy === "list" ? "list" : "all");
  }
  changeZoneSource(event) {
    this._zoneSourceChoice = event.detail.value;
    if (this.zonePolicy === "fixed")
      this.handleValue({
        detail: {
          name: "timeZoneId",
          value: null,
          reference: this.zoneSource === "flow",
          dataType: "String"
        }
      });
    else if (this.zoneSource === "flow") {
      this.removeInput("timeZoneIdsText");
      this.handleValue({
        detail: {
          name: "timeZoneIds",
          value: null,
          reference: true,
          dataType: "String[]"
        }
      });
    } else this.removeInput("timeZoneIds");
  }
  get timezoneFields() {
    const names =
      this.zonePolicy === "dynamic"
        ? [
            "allowTimeZoneSelection",
            "timeZoneId",
            "timeZoneIds",
            "timeZoneIdsText"
          ]
        : this.zonePolicy === "fixed"
          ? this.zoneSource === "flow"
            ? ["timeZoneId"]
            : []
          : [
              ...(this.zonePolicy === "list" && this.zoneSource === "flow"
                ? ["timeZoneIds"]
                : []),
              "timeZoneId"
            ];
    return this.fieldViews("timezone")
      .filter((field) => names.includes(field.name))
      .map((field) => ({
        ...field,
        searchable: field.name === "timeZoneId",
        lookupMessage: field.name === "timeZoneId" ? this.zoneError : "",
        options:
          field.name === "timeZoneId"
            ? this.zoneIds
                .filter(
                  (id) =>
                    this.zonePolicy !== "list" ||
                    this.zoneSource !== "here" ||
                    this.fixedZoneIds.includes(id)
                )
                .map((value) => ({ value, label: value }))
            : field.options,
        referenceOnly:
          field.name === "timeZoneIds" ||
          (this.zonePolicy === "fixed" && this.zoneSource === "flow"),
        label:
          field.name === "timeZoneId" && this.zonePolicy !== "fixed"
            ? "Default timezone (optional)"
            : field.label,
        helpText:
          field.name === "timeZoneId"
            ? "Blank uses the running user's timezone. A restricted list still applies."
            : field.helpText
      }));
  }
  get hoursSetup() {
    return {
      ...hoursSetup(this.hoursMode, (name) => this.reference(name)),
      ...(this._hoursSourceChoice ? { source: this._hoursSourceChoice } : {}),
      ...(this._hoursDataChoice ? { data: this._hoursDataChoice } : {})
    };
  }
  get hoursPolicy() {
    return this.hoursSetup.policy;
  }
  get hoursSource() {
    return this.hoursSetup.source;
  }
  get hoursData() {
    return this.hoursSetup.data;
  }
  get dynamicHours() {
    return this.reference("operatingHoursMode");
  }
  get hoursPolicyOptions() {
    return choices([
      ["none", "No operating-hours restriction"],
      ["fixed", "Fixed operating hours"],
      ["list", "Choose from a list"],
      ["all", "Any accessible saved schedule"]
    ]);
  }
  get hoursSourceOptions() {
    return choices([
      ["here", "Set here"],
      ["flow", "Flow resource"],
      ...(this.hoursPolicy === "fixed"
        ? [["entered", "Enter weekly hours and holidays"]]
        : [["filter", "Filter saved schedules"]])
    ]);
  }
  get hoursDataOptions() {
    return choices([
      [
        "records",
        this.hoursPolicy === "fixed"
          ? "An OperatingHours record"
          : "OperatingHours records"
      ],
      ["ids", this.hoursPolicy === "fixed" ? "A record ID" : "Record IDs"],
      ...(this.hoursPolicy === "fixed"
        ? [["supplied", "Unsaved records with slots and holidays"]]
        : [])
    ]);
  }
  get showHoursSource() {
    return !this.dynamicHours && ["fixed", "list"].includes(this.hoursPolicy);
  }
  get showHoursData() {
    return this.showHoursSource && this.hoursSource === "flow";
  }
  get showSavedList() {
    return this.showHoursSource && this.hoursSource === "here";
  }
  get savedListLabel() {
    return this.hoursPolicy === "fixed"
      ? "Operating hours"
      : "Allowed operating hours";
  }
  get selectedSavedIds() {
    return (
      this.hoursPolicy === "fixed"
        ? [this.value("operatingHoursId")]
        : String(this.value("operatingHoursIdsText") || "").split(/[\s,;]+/)
    ).filter(Boolean);
  }
  get selectedSavedItems() {
    return this.selectedSavedIds.map((value) => ({
      value,
      label: this.savedLabels[value] || value
    }));
  }
  changeHoursSetup(event) {
    const part = event.target.dataset.part;
    const setup = { ...this.hoursSetup, [part]: event.detail.value };
    if (["none", "all"].includes(setup.policy)) setup.source = "here";
    if (setup.policy === "list" && setup.source === "entered")
      setup.source = "here";
    if (setup.policy === "fixed" && setup.source === "filter")
      setup.source = "here";
    if (setup.policy === "list" && setup.data === "supplied")
      setup.data = "records";
    this._hoursSourceChoice = setup.source;
    this._hoursDataChoice = setup.data;
    this.change("operatingHoursMode", hoursModeFor(setup));
    if (part === "source") {
      if (setup.source === "here") {
        this.removeInput("operatingHoursIds");
        if (this.reference("operatingHoursId"))
          this.removeInput("operatingHoursId");
      }
      if (setup.source === "flow") {
        this.removeInput("operatingHoursIdsText");
        if (setup.data === "ids" && setup.policy === "fixed")
          this.handleValue({
            detail: {
              name: "operatingHoursId",
              value: null,
              reference: true,
              dataType: "String"
            }
          });
      }
    }
    if (setup.source === "entered" && !this.value("fixedHours"))
      this.saveFixed();
  }
  async loadSavedLabels() {
    const ids = this.selectedSavedIds;
    if (!ids.length || ids.some((value) => !/^[a-zA-Z0-9]{15,18}$/.test(value)))
      return;
    try {
      const values = await searchHours({
        searchTerm: "",
        allowedIds: ids,
        useIdFilter: true,
        filterJSON: null
      });
      this.savedLabels = {
        ...this.savedLabels,
        ...Object.fromEntries(values.map((item) => [item.value, item.label]))
      };
    } catch (error) {
      this.savedError = error.body?.message || error.message;
    }
  }
  searchSaved(event) {
    clearTimeout(this._savedTimer);
    const term = event.detail.value;
    const revision = ++this._savedRevision;
    this.savedPending = true;
    this.savedError = "";
    this._savedTimer = setTimeout(async () => {
      try {
        const values = await searchHours({
          searchTerm: term,
          allowedIds: null,
          useIdFilter: false,
          filterJSON: null
        });
        if (revision !== this._savedRevision) return;
        this.savedChoices = values.map((item) => ({
          ...item,
          detail: item.timeZoneId
        }));
        this.savedLabels = {
          ...this.savedLabels,
          ...Object.fromEntries(values.map((item) => [item.value, item.label]))
        };
      } catch (error) {
        if (revision === this._savedRevision)
          this.savedError = error.body?.message || error.message;
      } finally {
        if (revision === this._savedRevision) this.savedPending = false;
      }
    }, 200);
  }
  addSaved(event) {
    const value = event.detail.value;
    if (this.hoursPolicy === "fixed") this.change("operatingHoursId", value);
    else
      this.change(
        "operatingHoursIdsText",
        [...new Set([...this.selectedSavedIds, value])].join("\n")
      );
  }
  removeSaved(event) {
    if (this.hoursPolicy === "fixed") this.removeInput("operatingHoursId");
    else
      this.change(
        "operatingHoursIdsText",
        this.selectedSavedIds
          .filter((value) => value !== event.detail.value)
          .join("\n")
      );
  }
  removeInput(name) {
    this.handleValue({
      detail: { name, value: null, reference: false, dataType: "String" }
    });
  }
  get outputPrefix() {
    return this.elementInfo?.apiName || "YourComponent";
  }
  value(name) {
    return this._inputs.find((item) => item.name === name)?.value;
  }
  reference(name) {
    return (
      this._inputs.find((item) => item.name === name)?.valueDataType ===
        "reference" ||
      this._inputs.find((item) => item.name === name)?.dataType === "reference"
    );
  }
  get hoursMode() {
    return this.value("operatingHoursMode") || "none";
  }
  get showFixed() {
    return this.hoursMode === "fixed";
  }
  get showFilter() {
    return (
      this.hoursMode === "filter" && !this.reference("operatingHoursFilter")
    );
  }
  get generalFields() {
    return this.fieldViews("general").filter(
      (field) => !["dateValue", "dateTimeValue"].includes(field.name)
    );
  }
  get initialTypes() {
    return [
      { valueType: "Date" },
      { valueType: "DateTime" },
      { valueType: "String" }
    ];
  }
  get initialField() {
    const name =
      ["initialChronoValue", "dateTimeValue", "dateValue"].find(
        (key) => this.value(key) || this.reference(key)
      ) || (this.isDateTime ? "dateTimeValue" : "dateValue");
    return {
      name,
      value: this.value(name),
      reference: this.reference(name),
      dataType:
        name === "dateValue"
          ? "Date"
          : name === "dateTimeValue"
            ? "DateTime"
            : "String"
    };
  }
  handleInitialValue(event) {
    const { value, reference, dataType } = event.detail;
    const name = {
      Date: "dateValue",
      DateTime: "dateTimeValue",
      String: "initialChronoValue"
    }[dataType];
    if (!name) return;
    for (const key of ["initialChronoValue", "dateTimeValue", "dateValue"])
      if (key !== name && (this.value(key) || this.reference(key)))
        this.removeInput(key);
    this.handleValue({ detail: { name, value, reference, dataType } });
  }
  get interactionFields() {
    return this.fieldViews("interaction");
  }
  get hoursFields() {
    const all = this.fieldViews("hours");
    if (this.dynamicHours) return all;
    const permitted = {
      none: [],
      id: this.hoursSource === "flow" ? ["operatingHoursId"] : [],
      ids: [
        ...(this.hoursSource === "flow" ? ["operatingHoursIds"] : []),
        "operatingHoursId",
        "lockOperatingHoursSelection"
      ],
      record: ["operatingHoursRecord"],
      records: [
        "operatingHoursRecords",
        "operatingHoursId",
        "lockOperatingHoursSelection"
      ],
      filter: [
        "operatingHoursFilter",
        "operatingHoursId",
        "lockOperatingHoursSelection"
      ],
      all: ["operatingHoursId", "lockOperatingHoursSelection"],
      supplied: ["operatingHoursRecord", "timeSlots", "holidays"],

      fixed: []
    };
    return all
      .filter((field) => (permitted[this.hoursMode] || []).includes(field.name))
      .map((field) => ({
        ...field,
        referenceOnly:
          field.referenceOnly ||
          (field.name === "operatingHoursId" &&
            this.hoursPolicy === "fixed" &&
            this.hoursSource === "flow"),
        label:
          field.name === "operatingHoursId" && this.hoursPolicy !== "fixed"
            ? "Default operating hours ID (optional)"
            : field.label
      }));
  }
  fieldViews(group) {
    const basic = [
      "mode",
      "label",
      "dateStyle",
      "helpText",
      "required",
      "dateValue",
      ...(this.isDateTime ? ["dateTimeValue"] : [])
    ];
    const interaction = [
      "disabled",
      ...(this.isDateTime
        ? [
            "allowOffsetOverride",
            ...(this.value("allowOffsetOverride") ||
            this.reference("allowOffsetOverride") ||
            this.value("offsetOverride")
              ? ["offsetOverride"]
              : [])
          ]
        : [])
    ];
    const zone = [
      "allowTimeZoneSelection",
      "timeZoneId",
      "timeZoneIds",
      "timeZoneIdsText"
    ];
    return fields
      .filter((item) =>
        group === "general"
          ? basic.includes(item[0])
          : group === "interaction"
            ? interaction.includes(item[0])
            : group === "timezone"
              ? zone.includes(item[0])
              : !basic.includes(item[0]) &&
                !interaction.includes(item[0]) &&
                !zone.includes(item[0]) &&
                item[3] !== "general"
      )
      .map(([name, label, dataType, section, fallback, extra]) => ({
        name,
        label,
        dataType,
        value: this.value(name) ?? fallback,
        reference: this.reference(name),
        referenceOnly: [
          "SObject",
          "SObject[]",
          "Apex",
          "Apex[]",
          "String[]"
        ].includes(dataType),
        objectType: typeof extra === "string" ? extra : "",
        options:
          name === "operatingHoursMode"
            ? scheduleModes
            : Array.isArray(extra)
              ? extra.map(([value, choice]) => ({ value, label: choice }))
              : [],
        helpText:
          name === "dateTimeValue"
            ? "An exact instant. Displayed in the chosen timezone; when present it takes precedence over the initial date."
            : name === "dateValue"
              ? "In date/time mode, a date without an instant starts at local midnight."
              : name === "dateStyle"
                ? "Choose the length. The running user's locale determines its format."
                : name === "operatingHoursFilter"
                  ? "Use the criteria below, or bind a Flow text resource."
                  : ""
      }));
  }
  handleValue(event) {
    const { name, value, reference, dataType } = event.detail;
    if (value === null || value === "") {
      this._inputs = this._inputs.filter((item) => item.name !== name);
      // Keep source selection locally when a reference has not yet been chosen.
      if (reference)
        this._inputs = [
          ...this._inputs,
          { name, value: "", valueDataType: "reference" }
        ];
      this.dispatchEvent(
        new CustomEvent("configuration_editor_input_value_deleted", {
          detail: { name },
          bubbles: true,
          composed: true
        })
      );
      return;
    }
    this.change(name, value, reference ? "reference" : dataType);
  }
  change(name, value, dataType = "String") {
    this._inputs = [
      ...this._inputs.filter((item) => item.name !== name),
      { name, value, valueDataType: dataType }
    ];
    this.dispatchEvent(
      new CustomEvent("configuration_editor_input_value_changed", {
        detail: { name, newValue: value, newValueDataType: dataType },
        bubbles: true,
        composed: true
      })
    );
  }
  get weekdays() {
    return [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ].map((value) => ({ value, label: value }));
  }
  get slots() {
    return (this.fixed.slots || []).map((item, index) => ({
      ...item,
      key: `slot-${index}`,
      removeLabel: `Remove ${item.dayOfWeek} hours, row ${index + 1}`,
      index
    }));
  }
  get holidays() {
    return (this.fixed.holidays || []).map((item, index) => ({
      ...item,
      key: `holiday-${index}`,
      removeLabel: `Remove holiday ${item.dateValue || index + 1}`,
      index,
      partial: item.allDay === false,
      startTime: this.minuteText(item.startTimeInMinutes),
      endTime: this.minuteText(item.endTimeInMinutes)
    }));
  }
  minuteText(value) {
    return value == null
      ? ""
      : `${String(Math.floor(value / 60) % 24).padStart(2, "0")}:${String(value % 60).padStart(2, "0")}`;
  }
  get noSlots() {
    return !this.fixed.slots?.length;
  }
  get noHolidays() {
    return !this.fixed.holidays?.length;
  }
  get scheduleZoneOptions() {
    return this.zoneIds.map((value) => ({ value, label: value }));
  }
  chooseScheduleZone(event) {
    this.fixed = {
      ...this.fixed,
      definition: { ...this.fixed.definition, timeZoneId: event.detail.value }
    };
    this.saveFixed();
  }
  get fixedName() {
    return this.fixed.definition?.name || "";
  }
  get fixedZone() {
    return this.fixed.definition?.timeZoneId || "";
  }
  editDefinition(event) {
    this.fixed = {
      ...this.fixed,
      definition: {
        ...this.fixed.definition,
        [event.target.dataset.field]: event.detail?.value ?? event.target.value
      }
    };
    this.saveFixed();
  }
  addSlot() {
    this.fixed = {
      ...this.fixed,
      slots: [
        ...(this.fixed.slots || []),
        { dayOfWeek: "Monday", startTime: "09:00", endTime: "17:00" }
      ]
    };
    this.saveFixed();
  }
  addWeekdays() {
    this.fixed = {
      ...this.fixed,
      slots: [
        ...(this.fixed.slots || []),
        ...this.weekdays.slice(0, 5).map((day) => ({
          dayOfWeek: day.value,
          startTime: "09:00",
          endTime: "17:00"
        }))
      ]
    };
    this.saveFixed();
  }
  addHoliday() {
    this.fixed = {
      ...this.fixed,
      holidays: [
        ...(this.fixed.holidays || []),
        { dateValue: "", allDay: true }
      ]
    };
    this.saveFixed();
  }
  editRow(event) {
    const { group, index, field } = event.target.dataset;
    let value =
      event.target.type === "checkbox"
        ? event.target.checked
        : event.target.type === "number"
          ? Number(event.target.value)
          : (event.detail?.value ?? event.target.value);
    if (
      group === "holidays" &&
      ["startTimeInMinutes", "endTimeInMinutes"].includes(field)
    ) {
      const pieces = String(value).split(":").map(Number);
      value = value ? pieces[0] * 60 + pieces[1] : null;
      if (field === "endTimeInMinutes" && value === 0) value = 1440;
    }
    this.fixed = {
      ...this.fixed,
      [group]: this.fixed[group].map((item, i) =>
        i === Number(index) ? { ...item, [field]: value } : item
      )
    };
    this.saveFixed();
  }
  removeRow(event) {
    const { group, index } = event.target.dataset;
    this.fixed = {
      ...this.fixed,
      [group]: this.fixed[group].filter((item, i) => i !== Number(index))
    };
    this.saveFixed();
  }
  saveFixed() {
    this.change("fixedHours", JSON.stringify(this.fixed));
  }
  get criteria() {
    return this.filterRows.map((item, index) => ({
      ...item,
      index,
      key: `filter-${index}`
    }));
  }
  get filterFields() {
    return [
      { label: "Name", value: "Name" },
      { label: "Time zone", value: "TimeZone" }
    ];
  }
  get filterOperators() {
    return [
      ["eq", "Equals"],
      ["ne", "Does not equal"],
      ["contains", "Contains"],
      ["startsWith", "Starts with"]
    ].map(([value, label]) => ({ value, label }));
  }
  addCriterion() {
    this.filterRows = [
      ...this.filterRows,
      { fieldPath: "TimeZone", operator: "eq", value: "" }
    ];
    this.saveFilter();
  }
  editCriterion(event) {
    const { index, field } = event.target.dataset;
    this.filterRows = this.filterRows.map((item, i) =>
      i === Number(index)
        ? { ...item, [field]: event.detail?.value ?? event.target.value }
        : item
    );
    this.saveFilter();
  }
  removeCriterion(event) {
    this.filterRows = this.filterRows.filter(
      (item, i) => i !== Number(event.target.dataset.index)
    );
    this.saveFilter();
  }
  saveFilter() {
    this.change(
      "operatingHoursFilter",
      JSON.stringify({ criteria: this.filterRows })
    );
  }
  @api validate() {
    const errors = [];
    if (
      this.zonePolicy === "list" &&
      !this.fixedZoneIds.length &&
      !this.value("timeZoneIds")
    )
      errors.push({
        key: "timeZoneIds",
        errorString:
          "Add at least one timezone or choose a Flow text collection."
      });
    if (
      this.zonePolicy === "fixed" &&
      this.zoneSource === "flow" &&
      !this.value("timeZoneId")
    )
      errors.push({
        key: "timeZoneId",
        errorString: "Choose the Flow resource supplying the fixed timezone."
      });
    if (
      this.zonePolicy === "list" &&
      this.zoneSource === "here" &&
      this.value("timeZoneId") &&
      !this.reference("timeZoneId") &&
      !this.fixedZoneIds.includes(this.value("timeZoneId"))
    )
      errors.push({
        key: "timeZoneId",
        errorString: "The default timezone must be in the allowed list."
      });
    if (this.zoneIds.length)
      for (const zone of this.fixedZoneIds)
        if (!this.zoneIds.includes(zone))
          errors.push({
            key: "timeZoneIdsText",
            errorString: "Choose a supported timezone: " + zone
          });

    if (this.value("offsetOverride") && !this.reference("offsetOverride")) {
      try {
        parseOffset(this.value("offsetOverride"));
      } catch (error) {
        errors.push({ key: "offsetOverride", errorString: error.message });
      }
      if (
        !this.reference("allowOffsetOverride") &&
        !this.value("allowOffsetOverride")
      )
        errors.push({
          key: "allowOffsetOverride",
          errorString: "Enable offset overrides to supply an offset."
        });
    }
    if (
      this.value("lockOperatingHoursSelection") === true &&
      ["ids", "records", "filter", "all"].includes(this.hoursMode) &&
      !this.value("operatingHoursId")
    )
      errors.push({
        key: "operatingHoursId",
        errorString:
          "Supply the selected OperatingHours ID before locking selection."
      });
    const requireInput = (name, message) => {
      if (!this.value(name)) errors.push({ key: name, errorString: message });
    };
    if (!this.reference("operatingHoursMode")) {
      const inputs = {
        id: ["operatingHoursId"],
        ids: [],
        record: ["operatingHoursRecord"],
        records: ["operatingHoursRecords"],
        supplied: ["operatingHoursRecord", "timeSlots"],

        filter: ["operatingHoursFilter"]
      };
      for (const name of inputs[this.hoursMode] || [])
        requireInput(
          name,
          `Configure ${fields.find((field) => field[0] === name)?.[1] || name}.`
        );
    }
    if (
      this.hoursMode === "ids" &&
      !this.value("operatingHoursIds") &&
      !this.value("operatingHoursIdsText")
    )
      errors.push({
        key: "operatingHoursIds",
        errorString: "Supply an ID collection or fixed IDs."
      });
    if (this.showFixed) {
      if (!this.fixedZone || !this.fixed.slots?.length)
        errors.push({
          key: "fixedHours",
          errorString:
            "Fixed hours require a timezone and at least one time slot."
        });
      for (const slot of this.fixed.slots || [])
        if (
          !validTime(slot.startTime) ||
          !validTime(slot.endTime) ||
          slot.startTime >= slot.endTime
        )
          errors.push({
            key: "fixedHours",
            errorString:
              "Each time slot needs a start time before its end time."
          });
      for (const day of this.fixed.holidays || [])
        if (
          !validDate(day.dateValue) ||
          (day.allDay === false &&
            !(
              day.startTimeInMinutes >= 0 &&
              day.endTimeInMinutes <= 1440 &&
              day.endTimeInMinutes > day.startTimeInMinutes
            ))
        )
          errors.push({
            key: "fixedHours",
            errorString:
              "Enter a valid holiday date and, for partial days, a valid minute range."
          });
    }
    if (
      this.showFilter &&
      (!this.filterRows.length || this.filterRows.some((row) => !row.value))
    )
      errors.push({
        key: "operatingHoursFilter",
        errorString: "Add complete filter criteria."
      });
    this.errorMessage = errors.map((item) => item.errorString).join(" ");
    return errors;
  }
}
