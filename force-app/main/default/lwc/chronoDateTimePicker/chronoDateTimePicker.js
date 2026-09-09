// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";

/** Controlled, reusable UI. Values and async resolution are owned by the parent. */
export default class ChronoDateTimePicker extends LightningElement {
  @api mode = "datetime";
  @api label = "Date and time";
  @api helpText = "";
  @api required = false;
  @api disabled = false;
  @api dateValue = "";
  @api dateStyle = "medium";
  @api timeValue = "";
  @api timeZoneId = "";
  @api allowTimeZoneSelection = false;
  @api timeZoneOptions = [];
  @api zonePending = false;
  @api zoneMessage = "";
  @api candidates = [];
  @api selectedInstant = "";
  @api candidate;
  @api selectionMode = "auto";
  @api allowOffsetOverride = false;
  @api pending = false;
  @api errorMessage = "";
  @api notice = "";
  @api showScheduleSelection = false;
  @api showScheduleSearch = false;
  @api hasSchedule = false;
  @api operatingHoursId = "";
  @api operatingHoursOptions = [];
  @api scheduleMessage = "";
  @api scheduleChoices = [];
  get isDateTime() {
    return this.mode === "datetime";
  }
  get activeCandidate() {
    return (
      this.candidate ||
      this.candidates?.find(
        (item) => item.instantValue === this.selectedInstant
      )
    );
  }
  get zoneLabel() {
    return this.timeZoneId?.split("/").pop().replace(/_/g, " ") || "Timezone";
  }
  get scheduleVisible() {
    return this.hasSchedule || this.showScheduleSelection;
  }
  get hasScheduleChoices() {
    return this.scheduleChoices?.length > 0;
  }
  get fieldsClass() {
    return this.isDateTime ? "fields" : "fields date-only";
  }
  get offsetDisabled() {
    return this.disabled || this.pending;
  }
  emit(name, detail) {
    this.dispatchEvent(new CustomEvent(name, { detail }));
  }
  handleEdit(event) {
    const values = {
      dateValue: this.dateValue,
      timeValue: this.timeValue,
      timeZoneId: this.timeZoneId
    };
    values[event.target.dataset.field] =
      event.detail?.value ?? event.target.value ?? "";
    const valid = [
      ...this.template.querySelectorAll("lightning-input[data-field]")
    ].every((input) => input.validity?.valid !== false);
    this.emit("edit", { ...values, valid });
  }
  handleZone(event) {
    if (!this.allowTimeZoneSelection || this.disabled) return;
    this.emit("edit", {
      dateValue: this.dateValue,
      timeValue: this.timeValue,
      timeZoneId: event.detail.value,
      valid: true
    });
    this.refs.zone.close();
  }
  openZones() {
    this.emit("zonesearch", { value: "" });
  }
  searchZones(event) {
    this.emit("zonesearch", { value: event.detail.value });
  }
  handleSchedule(event) {
    if (!this.showScheduleSelection || this.disabled) return;
    this.emit("schedulechange", { value: event.detail.value });
    this.refs.hours.close();
  }
  searchHours(event) {
    this.emit("schedulesearch", { value: event.detail.value });
  }
  handleChoice(event) {
    this.emit("resolvechoice", { instantValue: event.detail.instantValue });
  }
  handleOffset(event) {
    this.emit("offsetchange", { value: event.detail.value });
  }
  handleOpenChoice(event) {
    this.emit("openchoice", { value: event.detail.value });
    this.refs.openTimes.close();
  }
  @api reportValidity() {
    return (
      [...this.template.querySelectorAll("lightning-input[data-field]")]
        .map((input) => input.reportValidity())
        .every((valid) => valid !== false) && !this.errorMessage
    );
  }
}
