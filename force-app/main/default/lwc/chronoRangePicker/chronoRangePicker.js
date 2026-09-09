// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import availability from "@salesforce/apex/ChronoComponentActions.availability";
import { exactMillis } from "c/chronoInputValues";
/** Reusable range controller. End is exclusive; the complete interval can be checked against operating hours. */
export default class ChronoRangePicker extends LightningElement {
  @api mode = "datetime";
  @api label = "Date and time range";
  @api timeZoneId;
  @api allowTimeZoneSelection = false;
  @api required = false;
  @api disabled = false;
  @api dateStyle = "short";
  @api startValue;
  @api endValue;
  @api operatingHoursId;
  @api operatingHoursRecord;
  @api timeSlots;
  @api holidays;
  error = "";
  pending = false;
  values = {};
  revision = 0;
  connected = false;
  connectedCallback() {
    this.connected = true;
  }
  renderedCallback() {
    const source = [this.startValue, this.endValue];
    const configuration = JSON.stringify([
      source,
      this.mode,
      this.timeZoneId,
      this.operatingHoursId,
      this.operatingHoursRecord,
      this.timeSlots,
      this.holidays
    ]);
    if (configuration === this._configuration) return;
    if (this._source) {
      const values = { ...this.values };
      for (const [index, side] of ["start", "end"].entries()) {
        if (source[index] !== this._source[index]) values[side] = source[index];
      }
      this.values = values;
    }
    this._source = source;
    this._configuration = configuration;
    Promise.resolve().then(() => {
      if (this.connected) this.resolveRange();
    });
  }
  disconnectedCallback() {
    this.connected = false;
    this.revision++;
  }
  get config() {
    return {
      mode: this.mode,
      timeZoneId: this.timeZoneId,
      allowTimeZoneSelection: this.allowTimeZoneSelection,
      required: this.required,
      disabled: this.disabled,
      dateStyle: this.dateStyle,
      operatingHoursMode: this.operatingHoursRecord
        ? "supplied"
        : this.operatingHoursId
          ? "id"
          : "none",
      operatingHoursId: this.operatingHoursId,
      operatingHoursRecord: this.operatingHoursRecord,
      timeSlots: this.timeSlots,
      holidays: this.holidays,
      lockOperatingHoursSelection: true
    };
  }
  changed(event) {
    event.stopPropagation();
    const name =
      this.mode === "date" ? "chronoDateValue" : "chronoZonedDateTimeValue";
    if (event.detail.name !== name) return;
    const side = event.target.dataset.side;
    const current = Object.prototype.hasOwnProperty.call(this.values, side)
      ? this.values[side]
      : side === "start"
        ? this.startValue
        : this.endValue;
    if (current === event.detail.value) return;
    this.values = { ...this.values, [side]: event.detail.value };
    this.resolveRange();
  }
  async resolveRange() {
    const revision = ++this.revision;
    this.error = "";
    this.pending = false;
    const start = Object.prototype.hasOwnProperty.call(this.values, "start")
        ? this.values.start
        : this.startValue,
      end = Object.prototype.hasOwnProperty.call(this.values, "end")
        ? this.values.end
        : this.endValue;
    if (!start || !end) {
      this.error = start || end ? "Complete both ends of the range." : "";
      this.emit(start, end, null);
      return;
    }
    try {
      const first =
          this.mode === "date"
            ? Date.parse(start + "T00:00:00Z")
            : exactMillis(start),
        last =
          this.mode === "date"
            ? Date.parse(end + "T00:00:00Z")
            : exactMillis(end);
      if (!Number.isFinite(first) || !Number.isFinite(last) || last <= first)
        throw new Error(
          "End must be after start. The end is excluded from the range."
        );
      if (this.operatingHoursId || this.operatingHoursRecord) {
        this.pending = true;
        this.emit(start, end, null);
        const result = await availability({
          input: {
            operation: "containsRange",
            valueType: this.mode === "date" ? "PlainDate" : "ZonedDateTime",
            value: start,
            endValue: end,
            timeZoneId: this.timeZoneId,
            operatingHoursId: this.operatingHoursId || null,
            operatingHours: this.operatingHoursRecord || null,
            timeSlots: this.timeSlots || null,
            holidays: this.holidays || null
          }
        });
        if (revision !== this.revision || !this.connected) return;
        if (!result.success) throw new Error(result.errorMessage);
        if (!result.containsRange)
          throw new Error("The range includes time outside operating hours.");
      }
      this.pending = false;
      this.emit(
        start,
        end,
        this.mode === "date"
          ? `P${(last - first) / 86400000}D`
          : `PT${((last - first) / 1000).toFixed(3)}S`
      );
    } catch (error) {
      if (revision !== this.revision || !this.connected) return;
      this.pending = false;
      this.error = error?.body?.message || error.message;
      this.emit(start, end, null);
    }
  }
  emit(startValue, endValue, duration) {
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          startValue: startValue || null,
          endValue: endValue || null,
          rangeValue: duration ? `${startValue}/${endValue}` : null,
          duration,
          valid: !this.pending && !this.error && !!duration
        }
      })
    );
  }
  @api validate() {
    const children = [
      ...this.template.querySelectorAll("c-chrono-date-time-control")
    ].map((control) => control.validate());
    const errorMessage = this.pending
      ? "The range is still being checked."
      : this.error ||
        children.find((result) => !result.isValid)?.errorMessage ||
        "";
    return { isValid: !errorMessage, errorMessage };
  }
  @api reportValidity() {
    for (const control of this.template.querySelectorAll(
      "c-chrono-date-time-control"
    ))
      control.reportValidity();
    return this.validate().isValid;
  }
}
