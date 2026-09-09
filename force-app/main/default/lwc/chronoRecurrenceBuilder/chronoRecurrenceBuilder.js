// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import recurrence from "@salesforce/apex/ChronoComponentActions.recurrence";
import locale from "@salesforce/i18n/locale";
import { exactMillis } from "c/chronoInputValues";
/** Calendar recurrence editor. Preview uses the same bounded Apex engine as Flow actions. */
export default class ChronoRecurrenceBuilder extends LightningElement {
  @api label = "Repeat";
  @api initialValue;
  @api timeZoneId;
  @api allowTimeZoneSelection = false;
  @api operatingHoursId;
  @api operatingHoursRecord;
  @api timeSlots;
  @api holidays;
  @api disabled = false;
  @api untilDate;
  @api maximumResults = 100;
  _rule = "FREQ=WEEKLY;INTERVAL=1;COUNT=6";
  frequency = "WEEKLY";
  interval = 1;
  count = 6;
  weekdays = [];
  start;
  @api closedPolicy = "keep";
  error = "";
  pending = false;
  previewed = false;
  rows = [];
  revision = 0;
  connected = false;
  @api get rule() {
    return this._rule;
  }
  set rule(value) {
    if (!value || value === this._rule) return;
    try {
      const parts = Object.fromEntries(
        value
          .replace(/^RRULE:/, "")
          .split(";")
          .map((part) => part.split("="))
      );
      if (
        Object.keys(parts).some(
          (key) => !["FREQ", "INTERVAL", "COUNT", "BYDAY"].includes(key)
        )
      )
        throw new Error(
          "This editor supports frequency, interval, count and weekly weekdays. Keep advanced rules in a recurrence action."
        );
      if (!["DAILY", "WEEKLY", "MONTHLY", "YEARLY"].includes(parts.FREQ))
        throw new Error("Choose a supported frequency.");
      this.frequency = parts.FREQ;
      this.interval = Number(parts.INTERVAL || 1);
      this.count = Number(parts.COUNT || 6);
      this.weekdays = parts.BYDAY ? parts.BYDAY.split(",") : [];
      this._rule = value;
      this.error = "";
      this.invalidate();
    } catch (error) {
      this.error = error.message;
    }
  }
  connectedCallback() {
    this.connected = true;
  }
  renderedCallback() {
    const configuration = JSON.stringify([
      this.initialValue,
      this.timeZoneId,
      this.operatingHoursId,
      this.operatingHoursRecord,
      this.timeSlots,
      this.holidays,
      this.maximumResults,
      this.untilDate,
      this.closedPolicy
    ]);
    if (configuration === this._configuration) return;
    const changed = this._configuration !== undefined;
    this._configuration = configuration;
    if (changed) {
      this.invalidate();
      this.emit([]);
    }
  }
  disconnectedCallback() {
    this.connected = false;
    this.revision++;
  }
  get frequencies() {
    return ["DAILY", "WEEKLY", "MONTHLY", "YEARLY"].map((value, index) => ({
      value,
      label: ["Daily", "Weekly", "Monthly", "Yearly"][index]
    }));
  }
  get weekly() {
    return this.frequency === "WEEKLY";
  }
  get weekdayOptions() {
    return ["MO", "TU", "WE", "TH", "FR", "SA", "SU"].map((value, index) => ({
      value,
      label: new Intl.DateTimeFormat(locale.replace(/_/g, "-"), {
        weekday: "short",
        timeZone: "UTC"
      }).format(new Date(Date.UTC(2026, 8, 7 + index)))
    }));
  }
  get schedule() {
    return !!(this.operatingHoursId || this.operatingHoursRecord);
  }
  get closedOptions() {
    return [
      { value: "keep", label: "Keep the scheduled clock" },
      { value: "skip", label: "Skip closed occurrences" },
      { value: "next", label: "Move to the next opening" },
      { value: "previous", label: "Move to the previous opening" }
    ];
  }
  get previewDisabled() {
    return this.disabled || this.pending;
  }
  startChanged(event) {
    event.stopPropagation();
    if (event.detail.name === "chronoZonedDateTimeValue") {
      if (this.start === event.detail.value) return;
      this.start = event.detail.value;
      this.invalidate();
      this.emit([]);
    }
  }
  change(event) {
    const name = event.target.dataset.field;
    this[name] = event.detail?.value ?? event.target.value;
    this.invalidate();
    try {
      this._rule = this.buildRule();
      this.error = "";
    } catch (error) {
      this.error = error.message;
    }
    this.emit([]);
  }
  invalidate() {
    this.revision++;
    this.previewed = false;
    this.rows = [];
    this.pending = false;
  }
  buildRule() {
    const interval = Number(this.interval),
      count = Number(this.count);
    if (
      !Number.isInteger(interval) ||
      interval < 1 ||
      !Number.isInteger(count) ||
      count < 1 ||
      count > Math.min(Number(this.maximumResults) || 100, 1000)
    )
      throw new Error(
        "Use a positive repeat interval and an occurrence count within the configured result limit."
      );
    return `FREQ=${this.frequency};INTERVAL=${interval};COUNT=${count}${this.weekly && this.weekdays.length ? `;BYDAY=${this.weekdays.join(",")}` : ""}`;
  }
  async preview() {
    const revision = ++this.revision;
    this.pending = true;
    this.previewed = false;
    this.error = "";
    this.rows = [];
    try {
      this._rule = this.buildRule();
      if (!this.start)
        throw new Error("Choose a valid starting date and time.");
      if (!this.untilDate) throw new Error("Choose a search-through date.");
      const result = await recurrence({
        input: {
          operation: "rrule",
          valueType: "ZonedDateTime",
          value: this.start,
          rule: this._rule,
          untilDate: this.untilDate,
          maximumResults: Number(this.maximumResults) || 100,
          closedPolicy: this.closedPolicy,
          operatingHoursId: this.operatingHoursId || null,
          operatingHours: this.operatingHoursRecord || null,
          timeSlots: this.timeSlots || null,
          holidays: this.holidays || null
        }
      });
      if (revision !== this.revision || !this.connected) return;
      if (!result.success) throw new Error(result.errorMessage);
      this.rows = (result.values || []).map((value, index) => {
        const zone =
          /\[([^\]]+)\]$/.exec(value)?.[1] || this.timeZoneId || "UTC";
        return {
          key: String(index),
          label: new Intl.DateTimeFormat(locale.replace(/_/g, "-"), {
            year: "numeric",
            month: "short",
            day: "numeric",
            hour: "numeric",
            minute: "2-digit",
            timeZoneName: "shortOffset",
            timeZone: zone
          }).format(new Date(exactMillis(value)))
        };
      });
      this.previewed = true;
      this.emit(result.values || []);
    } catch (error) {
      if (revision === this.revision) {
        this.error = error?.body?.message || error.message;
        this.emit([]);
      }
    } finally {
      if (revision === this.revision) this.pending = false;
    }
  }
  emit(values) {
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          rule: this._rule,
          values,
          startValue: this.start || null,
          untilDate: this.untilDate || null,
          closedPolicy: this.closedPolicy
        }
      })
    );
  }
  @api validate() {
    const errorMessage =
      this.error ||
      (this.pending
        ? "The preview is loading."
        : !this.previewed
          ? "Preview the recurrence before continuing."
          : "");
    return { isValid: !errorMessage, errorMessage };
  }
  @api reportValidity() {
    this.error = this.validate().errorMessage;
    return !this.error;
  }
}
