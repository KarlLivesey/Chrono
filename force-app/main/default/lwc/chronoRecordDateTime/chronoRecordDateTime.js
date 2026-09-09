// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api, wire } from "lwc";
import {
  getRecord,
  updateRecord,
  notifyRecordUpdateAvailable
} from "lightning/uiRecordApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import userTimeZone from "@salesforce/i18n/timeZone";
/** Record-page adapter. LDS enforces access and Save checks the loaded modification date. */
export default class ChronoRecordDateTime extends LightningElement {
  @api recordId;
  @api objectApiName;
  @api dateTimeField;
  @api timeZoneField;
  @api operatingHoursField;
  @api label = "Date and time";
  @api fixedTimeZone;
  @api fixedOperatingHoursId;
  @api allowTimeZoneSelection = false;
  @api dateStyle = "short";
  info;
  error = "";
  notice = "";
  initialDate;
  initialInstant;
  zone = userTimeZone;
  hours;
  modified;
  loadedRecord;
  draft = {};
  dirty = false;
  saving = false;
  @wire(getObjectInfo, { objectApiName: "$objectApiName" }) objectInfo({
    data,
    error
  }) {
    if (data) this.info = data;
    if (error) this.error = this.message(error);
  }
  get configurationError() {
    if (!this.info) return "";
    const fields = [
      this.dateTimeField,
      this.timeZoneField,
      this.operatingHoursField
    ].filter(Boolean);
    if (!this.dateTimeField)
      return "Choose a Date or DateTime field in App Builder.";
    if (
      fields.some(
        (name) =>
          !/^[A-Za-z][A-Za-z0-9_]*$/.test(name) || !this.info.fields[name]
      )
    )
      return "A configured field is unavailable. Check its API name and field access.";
    if (
      !["Date", "DateTime"].includes(
        this.info.fields[this.dateTimeField].dataType
      )
    )
      return "The value field must be a Date or DateTime field.";
    if (
      this.timeZoneField &&
      !["String", "Picklist"].includes(
        this.info.fields[this.timeZoneField].dataType
      )
    )
      return "The timezone field must store text.";
    if (
      this.operatingHoursField &&
      this.info.fields[this.operatingHoursField].dataType !== "Reference"
    )
      return "The operating-hours field must be a lookup.";
    return "";
  }
  get fields() {
    if (!this.info || this.configurationError) return undefined;
    return [
      ...new Set(
        [
          "Id",
          "LastModifiedDate",
          this.dateTimeField,
          this.timeZoneField,
          this.operatingHoursField
        ].filter(Boolean)
      )
    ].map((name) => `${this.objectApiName}.${name}`);
  }
  @wire(getRecord, { recordId: "$recordId", fields: "$fields" }) record({
    data,
    error
  }) {
    if (error) {
      this.error = this.message(error);
      return;
    }
    if (
      !data ||
      (this.dirty &&
        data.id === this.loadedRecord &&
        this.loadedMapping === this.mapping)
    )
      return;
    this.loadedRecord = data.id;
    this.loadedMapping = this.mapping;
    this.draft = {};
    this.dirty = false;
    this.modified = data.fields.LastModifiedDate?.value;
    const value = data.fields[this.dateTimeField]?.value;
    this.initialDate = this.mode === "date" ? value : null;
    this.initialInstant = this.mode === "datetime" ? value : null;
    this.zone =
      (this.timeZoneField && data.fields[this.timeZoneField]?.value) ||
      this.fixedTimeZone ||
      userTimeZone;
    this.hours =
      (this.operatingHoursField &&
        data.fields[this.operatingHoursField]?.value) ||
      this.fixedOperatingHoursId ||
      null;
    this.error = "";
  }
  get mode() {
    return this.info?.fields[this.dateTimeField]?.dataType === "Date"
      ? "date"
      : "datetime";
  }
  get scheduleMode() {
    return this.hours ? "id" : "none";
  }
  get mapping() {
    return JSON.stringify([
      this.dateTimeField,
      this.timeZoneField,
      this.operatingHoursField
    ]);
  }
  get readOnly() {
    return (
      this.saving ||
      this.loadedRecord !== this.recordId ||
      this.loadedMapping !== this.mapping ||
      !this.info?.updateable ||
      !this.info?.fields[this.dateTimeField]?.updateable
    );
  }
  get canSelectZone() {
    return (
      this.allowTimeZoneSelection &&
      !this.readOnly &&
      (!this.timeZoneField || this.info?.fields[this.timeZoneField]?.updateable)
    );
  }
  get canRender() {
    return (
      this.loadedRecord === this.recordId &&
      this.loadedMapping === this.mapping &&
      !this.configurationError
    );
  }
  get saveDisabled() {
    return this.readOnly || !this.dirty;
  }
  get displayedError() {
    return this.configurationError || this.error;
  }
  changed(event) {
    event.stopPropagation();
    const { name, value } = event.detail;
    if (
      ![
        "dateValue",
        "dateTimeValue",
        "timeZoneId",
        "operatingHoursId"
      ].includes(name)
    )
      return;
    this.draft = { ...this.draft, [name]: value };
    const initial =
      name === "dateValue"
        ? this.initialDate
        : name === "dateTimeValue"
          ? this.initialInstant
          : name === "timeZoneId"
            ? this.zone
            : this.hours;
    if ((value || null) !== (initial || null)) this.dirty = true;
  }
  async save() {
    if (this.saveDisabled) return;
    const validation = this.refs.control.validate();
    if (!validation.isValid) {
      this.refs.control.reportValidity();
      this.error = validation.errorMessage;
      return;
    }
    const name = this.mode === "date" ? "dateValue" : "dateTimeValue";
    const fields = {
      Id: this.recordId,
      [this.dateTimeField]: Object.prototype.hasOwnProperty.call(
        this.draft,
        name
      )
        ? this.draft[name]
        : this.mode === "date"
          ? this.initialDate
          : this.initialInstant
    };
    if (this.timeZoneField && this.info?.fields[this.timeZoneField]?.updateable)
      fields[this.timeZoneField] = this.draft.timeZoneId ?? this.zone;
    if (
      this.operatingHoursField &&
      this.info?.fields[this.operatingHoursField]?.updateable
    )
      fields[this.operatingHoursField] =
        this.draft.operatingHoursId ?? this.hours;
    if (!this.modified) {
      this.error =
        "Reload the record before saving; its modification date is unavailable.";
      return;
    }
    this.saving = true;
    this.error = "";
    try {
      await updateRecord({ fields }, { ifUnmodifiedSince: this.modified });
      this.dirty = false;
      await notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
      this.notice = "Saved.";
      this.dispatchEvent(
        new CustomEvent("saved", { detail: { recordId: this.recordId } })
      );
    } catch (error) {
      this.error = this.message(error);
    } finally {
      this.saving = false;
    }
  }
  message(error) {
    return (
      error?.body?.message ||
      error?.message ||
      "The record could not be loaded or saved."
    );
  }
}
