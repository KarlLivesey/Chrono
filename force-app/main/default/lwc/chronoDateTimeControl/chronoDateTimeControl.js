// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import searchHours from "@salesforce/apex/ChronoPickerSchedules.searchHours";
import checkHours from "@salesforce/apex/ChronoPickerSchedules.checkHours";
import checkSupplied from "@salesforce/apex/ChronoPickerSchedules.checkSupplied";
import {
  allowedScheduleIds,
  scheduleConfigError,
  suppliedSchedule,
  choiceLabel
} from "c/chronoPickerEngine";
import userTimeZone from "@salesforce/i18n/timeZone";
import { chronoDate, chronoValues } from "./chronoValues";
import readInitialValue from "@salesforce/apex/ChronoPickerController.readInitialValue";
import apexResolve from "@salesforce/apex/ChronoPickerController.resolveLocal";
import apexProject from "@salesforce/apex/ChronoPickerController.projectInstant";
import getTimeZones from "@salesforce/apex/ChronoPickerController.getTimeZones";
import apexDescribeZones from "@salesforce/apex/ChronoPickerController.describeZones";
import {
  resolveLocal,
  projectInstant,
  validDate,
  validTime,
  describeZones,
  overrideCandidate,
  projectOverride
} from "c/chronoPickerEngine";

/** Reusable controller: owns asynchronous resolution and emits native/ISO value changes. */
export default class ChronoDateTimeControl extends LightningElement {
  _initialChrono = null;
  _initialChronoDirty = false;
  _hasHydrated = false;
  _initialTime;
  @api get initialChronoValue() {
    return this._initialChrono;
  }
  set initialChronoValue(value) {
    this._initialChrono = value || null;
    this._initialChronoDirty = true;
    this.scheduleHydrate();
  }
  async readChronoInitial(revision) {
    if (!this._initialChronoDirty) return;
    // On return navigation Flow restores the edited native outputs as inputs.
    // Use those ahead of the original initial value, regardless of setter order.
    if (!this._hasHydrated && (this._date || this._instant)) {
      this._initialChronoDirty = false;
      return;
    }
    if (!this._initialChrono) {
      this.publish("dateValue", null);
      this.publish("dateTimeValue", null);
      this._initialTime = null;
      this._initialChronoDirty = false;
      return;
    }
    const resolved = await readInitialValue({ value: this._initialChrono });
    if (revision !== this._revision || !this._connected) return;
    this._date = resolved.dateValue || null;
    this._instant = resolved.instantValue || null;
    this._initialTime =
      resolved.valueType === "PlainDateTime" ? resolved.timeValue : null;
    this._initialChronoDirty = false;
  }
  _chronoOutputs = {};
  @api get chronoDateValue() {
    return this._chronoOutputs.chronoDateValue || null;
  }
  @api get chronoPlainDateTimeValue() {
    return this._chronoOutputs.chronoPlainDateTimeValue || null;
  }
  @api get chronoTimeValue() {
    return this._chronoOutputs.chronoTimeValue || null;
  }
  @api get chronoInstantValue() {
    return this._chronoOutputs.chronoInstantValue || null;
  }
  @api get chronoZonedDateTimeValue() {
    return this._chronoOutputs.chronoZonedDateTimeValue || null;
  }
  publishChrono(values) {
    for (const [name, value] of Object.entries(values)) {
      this._chronoOutputs = { ...this._chronoOutputs, [name]: value };
      this.dispatchEvent(
        new CustomEvent("valuechange", {
          detail: { name, value: value || null }
        })
      );
    }
  }
  clearChrono() {
    this.publishChrono(
      Object.fromEntries(
        Object.entries(this._chronoOutputs)
          .filter(([, value]) => value != null)
          .map(([name]) => [name, null])
      )
    );
  }
  @api label = "Date and time";
  @api dateStyle = "medium";
  _timeZoneSelectionMode = "all";
  _timeZoneIds = null;
  _timeZoneIdsText = "";
  @api get timeZoneSelectionMode() {
    return this._timeZoneSelectionMode;
  }
  set timeZoneSelectionMode(value) {
    this._timeZoneSelectionMode = value || "all";
    this.scheduleHydrate();
  }
  @api get timeZoneIds() {
    return this._timeZoneIds;
  }
  set timeZoneIds(value) {
    this._timeZoneIds = value;
    this.scheduleHydrate();
  }
  @api get timeZoneIdsText() {
    return this._timeZoneIdsText;
  }
  set timeZoneIdsText(value) {
    this._timeZoneIdsText = value || "";
    this.scheduleHydrate();
  }
  get allowedTimeZoneIds() {
    return [
      ...new Set(
        [
          ...(this._timeZoneIds || []),
          ...this._timeZoneIdsText.split(/[\s,;]+/)
        ].filter(Boolean)
      )
    ];
  }
  get timezoneRestrictionError() {
    if (this.mode !== "datetime") return "";
    if (!["all", "list"].includes(this.timeZoneSelectionMode))
      return "The Flow has an unsupported timezone selection setting.";
    if (this.timeZoneSelectionMode === "list") {
      if (!this.allowedTimeZoneIds.length)
        return "No allowed timezones were supplied. Contact the Flow administrator.";
      if (!this.allowedTimeZoneIds.includes(this._zone))
        return "Choose a timezone from the allowed list.";
    }
    return "";
  }
  @api helpText = "";
  @api required = false;
  @api disabled = false;
  @api allowOffsetOverride = false;
  @api lockOperatingHoursSelection = false;
  _offsetOverride = "";
  _offsetMode = "auto";
  @api get offsetOverride() {
    return this._offsetOverride;
  }
  set offsetOverride(value) {
    if ((value || "") === this._offsetOverride) return;
    this._offsetOverride = value || "";
    this.scheduleHydrate();
  }
  @api get offsetMode() {
    return this._offsetMode;
  }
  set offsetMode(value) {
    this._offsetMode = ["auto", "selected", "override"].includes(value)
      ? value
      : "auto";
  }
  candidate = null;
  zonePending = false;
  zoneOffsets = {};
  _zoneSearch = "";
  _zoneRevision = 0;
  _zoneTimer;
  _zonesViewed = false;
  _mode = "datetime";
  _zone = userTimeZone;
  _allowZone = false;
  _date = null;
  _instant = null;
  _connected = false;
  _scheduled = false;
  _revision = 0;
  _externalError = "";
  _renderedExternalError = "";
  _showErrors = false;
  _inputValid = true;
  localDate = "";
  localTime = "";
  candidates = [];
  selectedInstant = "";
  pending = false;
  failure = "";
  zoneFailure = "";
  zoneIds = [];
  notice = "";

  scheduleOptions = [];
  scheduleFailure = "";
  availability = null;
  _scheduleRevision = 0;
  _scheduleSearch = "";
  _scheduleTimer;
  _operatingHoursMode = "none";
  @api get operatingHoursMode() {
    return this._operatingHoursMode;
  }
  set operatingHoursMode(value) {
    if (value === this._operatingHoursMode) return;
    this._operatingHoursMode = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursId = "";
  @api get operatingHoursId() {
    return this._operatingHoursId;
  }
  set operatingHoursId(value) {
    if (value === this._operatingHoursId) return;
    this._operatingHoursId = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursIds = null;
  @api get operatingHoursIds() {
    return this._operatingHoursIds;
  }
  set operatingHoursIds(value) {
    if (value === this._operatingHoursIds) return;
    this._operatingHoursIds = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursIdsText = "";
  @api get operatingHoursIdsText() {
    return this._operatingHoursIdsText;
  }
  set operatingHoursIdsText(value) {
    if (value === this._operatingHoursIdsText) return;
    this._operatingHoursIdsText = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursFilter = "";
  @api get operatingHoursFilter() {
    return this._operatingHoursFilter;
  }
  set operatingHoursFilter(value) {
    if (value === this._operatingHoursFilter) return;
    this._operatingHoursFilter = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursRecord = null;
  @api get operatingHoursRecord() {
    return this._operatingHoursRecord;
  }
  set operatingHoursRecord(value) {
    if (value === this._operatingHoursRecord) return;
    this._operatingHoursRecord = value;
    this.scheduleConfigurationChanged();
  }
  _operatingHoursRecords = null;
  @api get operatingHoursRecords() {
    return this._operatingHoursRecords;
  }
  set operatingHoursRecords(value) {
    if (value === this._operatingHoursRecords) return;
    this._operatingHoursRecords = value;
    this.scheduleConfigurationChanged();
  }
  _timeSlots = null;
  @api get timeSlots() {
    return this._timeSlots;
  }
  set timeSlots(value) {
    if (value === this._timeSlots) return;
    this._timeSlots = value;
    this.scheduleConfigurationChanged();
  }
  _holidays = null;
  @api get holidays() {
    return this._holidays;
  }
  set holidays(value) {
    if (value === this._holidays) return;
    this._holidays = value;
    this.scheduleConfigurationChanged();
  }
  _fixedHours = "";
  @api get fixedHours() {
    return this._fixedHours;
  }
  set fixedHours(value) {
    if (value === this._fixedHours) return;
    this._fixedHours = value;
    this.scheduleConfigurationChanged();
  }
  @api get mode() {
    return this._mode;
  }
  set mode(value) {
    this._mode = value || "datetime";
    this.scheduleHydrate();
  }
  @api get timeZoneId() {
    return this._zone;
  }
  set timeZoneId(value) {
    const next = value || userTimeZone;
    if (next !== this._zone) {
      this._zone = next;
      this.scheduleHydrate();
    }
  }
  @api get allowTimeZoneSelection() {
    return this._allowZone;
  }
  set allowTimeZoneSelection(value) {
    this._allowZone = value === true || value === "true";
    if (this._connected && this._allowZone) this.loadZones();
  }
  @api get dateValue() {
    return this._date;
  }
  set dateValue(value) {
    if ((value || null) !== this._date) {
      this._date = value || null;
      this.scheduleHydrate();
    }
  }
  @api get dateTimeValue() {
    return this._instant;
  }
  set dateTimeValue(value) {
    if ((value || null) !== this._instant) {
      this._instant = value || null;
      this.scheduleHydrate();
    }
  }
  connectedCallback() {
    this._connected = true;
    this.loadSchedules();
    this.scheduleHydrate();
  }
  disconnectedCallback() {
    this._connected = false;
    this._revision++;
    this._scheduleRevision++;
    clearTimeout(this._scheduleTimer);
    clearTimeout(this._zoneTimer);
    this._zoneRevision++;
  }

  // Coalesce Flow setters: their order is unspecified. Invalidate any previous
  // request immediately so a late response cannot restore stale outputs.
  scheduleHydrate() {
    this._revision++;
    this._zoneRevision++;
    this.zoneOffsets = {};
    if (!this._connected || this._scheduled) return;
    this.pending = true;
    this._scheduled = true;
    Promise.resolve().then(() => {
      this._scheduled = false;
      if (this._connected) this.hydrate();
    });
  }
  async hydrate() {
    const revision = ++this._revision;
    this.clearChrono();
    this.failure = "";
    try {
      await this.readChronoInitial(revision);
      if (revision === this._revision) this._hasHydrated = true;
    } catch (error) {
      if (revision === this._revision) {
        this.failure = this.errorText(error);
        this.publish("dateValue", null);
        this.publish("dateTimeValue", null);
        this.pending = false;
      }
      return;
    }
    if (revision !== this._revision || !this._connected) return;
    this.availability = null;
    this.notice = "";
    this.candidates = [];
    this.candidate = null;
    this.selectedInstant = "";
    this._inputValid = true;
    this.localDate = this._date || "";
    this.localTime = "";
    if (this.mode === "date" && this._instant) {
      try {
        const projected = await projectInstant(
          this._instant,
          this._zone,
          apexProject
        );
        if (revision !== this._revision || !this._connected) return;
        this.localDate = projected.localValue.split("T")[0];
      } catch (error) {
        if (revision === this._revision) {
          this.failure = this.errorText(error);
          this.pending = false;
        }
        return;
      }
    }
    if (this.timezoneRestrictionError) {
      this.failure = this.timezoneRestrictionError;
      this.publish("dateTimeValue", null);
      this.pending = false;
      return;
    }
    if (this.mode === "datetime" && this._allowZone) this.loadZones();
    if (
      this.mode === "datetime" &&
      !this._instant &&
      validDate(this.localDate)
    ) {
      // A date supplied to datetime mode starts at local midnight. Resolve it
      // normally: some zones skip or repeat midnight, and hours may be closed.
      await this.resolveEdit({
        dateValue: this.localDate,
        timeValue: this._initialTime || "00:00:00.000",
        timeZoneId: this._zone,
        valid: true
      });
      return;
    }
    if (this.mode !== "datetime" || !this._instant) {
      if (this.mode === "date") this.publish("dateTimeValue", null);
      if (this.mode === "date" && validDate(this.localDate)) {
        await this.acceptDate(revision);
      }
      if (revision === this._revision) this.pending = false;
      return;
    }
    this.pending = true;
    try {
      const projected = await projectInstant(
        this._instant,
        this._zone,
        apexProject
      );
      if (this._offsetOverride && !this.allowOffsetOverride)
        throw new Error(
          "Offset overrides are disabled in this Flow configuration."
        );
      const candidate = this._offsetOverride
        ? projectOverride(this._instant, this._offsetOverride)
        : projected;
      if (this._offsetOverride) this.publish("offsetMode", "override");
      if (revision !== this._revision || !this._connected) return;
      [this.localDate, this.localTime] = candidate.localValue.split("T");
      // Resolve again to expose both occurrences while preserving the supplied instant.
      const options = await resolveLocal(
        this.localDate,
        this.localTime,
        this._zone,
        apexResolve
      );
      if (revision !== this._revision || !this._connected) return;
      this.candidates = options;
      await this.acceptCandidate(candidate, revision);
    } catch (error) {
      if (revision === this._revision) {
        this.failure = this.errorText(error);
        this.publish("dateTimeValue", null);
      }
    } finally {
      if (revision === this._revision) this.pending = false;
    }
  }
  async loadZones() {
    if (this.zoneIds.length) return;
    if (!this._loadingZones)
      this._loadingZones = getTimeZones()
        .then((values) => {
          this.zoneIds = values;
          this.zoneFailure = "";
        })
        .catch((error) => {
          this.zoneFailure = `Unable to load time zones. ${this.errorText(error)}`;
        })
        .finally(() => {
          this._loadingZones = null;
        });
    await this._loadingZones;
  }
  get timeZoneOptions() {
    return (
      this.timeZoneSelectionMode === "list"
        ? this.allowedTimeZoneIds
        : [...new Set([this._zone, ...this.zoneIds].filter(Boolean))]
    )
      .sort(
        (first, second) =>
          Number(second === this._zone) - Number(first === this._zone) ||
          first.localeCompare(second)
      )
      .filter((value) =>
        value
          .replace(/_/g, " ")
          .toLowerCase()
          .includes(this._zoneSearch.toLowerCase())
      )
      .slice(0, 12)
      .map((value) => ({
        value,
        label: value.replace(/_/g, " "),
        detail: this.zoneOffsets[value] || ""
      }));
  }
  get zoneMessage() {
    return validDate(this.localDate) && validTime(this.localTime)
      ? `Offsets for ${this.localDate}, ${this.localTime} in each timezone. Search to narrow the results.`
      : "Enter a date and time to see their offsets. Search to narrow the results.";
  }
  handleZoneSearch(event) {
    this._zonesViewed = true;
    this._zoneSearch = event.detail.value || "";
    this.zoneOffsets = {};
    this._zoneRevision++;
    clearTimeout(this._zoneTimer);
    this._zoneTimer = setTimeout(() => this.refreshZoneOffsets(), 250);
  }
  async refreshZoneOffsets() {
    const revision = ++this._zoneRevision;
    this.zonePending = true;
    try {
      await this.loadZones();
      const values = await describeZones(
        this.timeZoneOptions.map((item) => item.value),
        this.localDate,
        this.localTime,
        apexDescribeZones
      );
      if (revision === this._zoneRevision && this._connected) {
        this.zoneOffsets = values;
        this.zoneFailure = "";
      }
    } catch (error) {
      if (revision === this._zoneRevision)
        this.zoneFailure = this.errorText(error);
    } finally {
      if (revision === this._zoneRevision) this.zonePending = false;
    }
  }
  handleEdit(event) {
    if (this.disabled) return;
    return this.resolveEdit(event.detail);
  }
  async resolveEdit(detail) {
    this._initialTime = null;
    const revision = ++this._revision;
    const { dateValue, timeValue, timeZoneId, valid } = detail;
    this.localDate = dateValue || "";
    this.localTime = timeValue || "";
    this._inputValid = valid !== false;
    this._showErrors = true;
    this.failure = "";
    this.availability = null;
    this.notice = "";
    this.candidates = [];
    this.candidate = null;
    this.selectedInstant = "";
    this.zoneOffsets = {};
    this._zoneRevision++;
    this.zonePending = false;
    if (this._zonesViewed)
      this.handleZoneSearch({ detail: { value: this._zoneSearch } });
    this.pending = false;
    this.publish("timeZoneId", timeZoneId || this._zone);
    this.publish("dateTimeValue", null);
    if (this.timezoneRestrictionError) {
      this.failure = this.timezoneRestrictionError;
      return;
    }
    this.publish("offsetMode", this._offsetOverride ? "override" : "auto");
    this.publish(
      "dateValue",
      validDate(this.localDate) ? this.localDate : null
    );
    if (this.mode === "date" && validDate(this.localDate) && this._inputValid) {
      this.pending = true;
      await this.acceptDate(revision);
      if (revision === this._revision) this.pending = false;
      return;
    }
    if (
      this.mode !== "datetime" ||
      !validDate(this.localDate) ||
      !validTime(this.localTime) ||
      !this._inputValid
    )
      return;
    this.pending = true;
    try {
      const options = await resolveLocal(
        this.localDate,
        this.localTime,
        this._zone,
        apexResolve
      );
      if (revision !== this._revision || !this._connected) return;
      if (!options?.length)
        throw new Error(
          "No matching time was returned. Edit the date or time and try again."
        );
      this.candidates = options;
      if (this._offsetOverride) {
        if (!this.allowOffsetOverride)
          throw new Error(
            "Offset overrides are disabled in this Flow configuration."
          );
        await this.acceptCandidate(
          overrideCandidate(
            this.localDate,
            this.localTime,
            this._offsetOverride
          ),
          revision
        );
      } else if (options.length === 1 && options[0].choice === "exact")
        await this.acceptCandidate(options[0], revision);
    } catch (error) {
      if (revision === this._revision) this.failure = this.errorText(error);
    } finally {
      if (revision === this._revision) this.pending = false;
    }
  }
  async handleChoice(event) {
    if (this.pending || this.disabled) return;
    const candidate = this.candidates.find(
      (item) => item.instantValue === event.detail.instantValue
    );
    if (!candidate) return;
    const revision = ++this._revision;
    this.pending = true;
    this.publish("offsetOverride", "");
    this.publish("offsetMode", "selected");
    try {
      await this.acceptCandidate(candidate, revision);
      if (revision !== this._revision) return;
      if (candidate.choice === "backward" || candidate.choice === "forward") {
        this.notice = `Moved ${candidate.choice} to the nearest valid clock-change boundary.`;
        this.candidates = [{ ...candidate, choice: "exact" }];
      }
    } catch (error) {
      if (revision === this._revision) this.failure = this.errorText(error);
    } finally {
      if (revision === this._revision) this.pending = false;
    }
  }
  async applyCandidate(candidate, revision) {
    if (revision !== this._revision || !this._connected) return;
    [this.localDate, this.localTime] = candidate.localValue.split("T");
    // Supplied offsets preserve the entered wall clock. The zoned ISO output must
    // still use the named zone's actual offset for the resulting instant.
    const canonical =
      candidate.choice === "override"
        ? await projectInstant(candidate.instantValue, this._zone, apexProject)
        : candidate;
    if (revision !== this._revision || !this._connected) return;
    const values = chronoValues(candidate, this._zone, canonical);
    this.selectedInstant = candidate.instantValue;
    this.publish("dateValue", this.localDate);
    this.publish("dateTimeValue", candidate.instantValue);
    this.publishChrono(values);
    if (this._zonesViewed)
      this.handleZoneSearch({ detail: { value: this._zoneSearch } });
  }
  async handleOffset(event) {
    if (
      this.pending ||
      this.disabled ||
      (event.detail.value && !this.allowOffsetOverride)
    )
      return;
    this.publish("offsetOverride", event.detail.value || "");
    await this.handleEdit({
      detail: {
        dateValue: this.localDate,
        timeValue: this.localTime,
        timeZoneId: this._zone,
        valid: this._inputValid
      }
    });
  }
  get hasSchedule() {
    return this.operatingHoursMode && this.operatingHoursMode !== "none";
  }
  get showScheduleSelection() {
    return !this.lockOperatingHoursSelection && this.hasScheduleCollection;
  }
  get hasScheduleCollection() {
    return ["ids", "filter", "all", "records"].includes(
      this.operatingHoursMode
    );
  }
  get showScheduleSearch() {
    return this.showScheduleSelection;
  }
  get selectedHoursId() {
    return this.operatingHoursMode === "record"
      ? this.operatingHoursRecord?.Id
      : this.operatingHoursId;
  }
  get scheduleMessage() {
    if (!this.hasSchedule) return "";
    if (this.availability)
      return `${this.availability.scheduleName || "Operating hours"} · ${this.availability.timeZoneId}. ${this.availability.isOpen ? "Within operating hours." : "Closed at this time. Choose an open alternative or edit your value."}`;
    const selected = this.scheduleOptions.find(
      (item) => item.value === this.selectedHoursId
    );
    if (selected) return selected.label;
    try {
      if (["supplied", "fixed"].includes(this.operatingHoursMode)) {
        const hours = suppliedSchedule(this).operatingHours;
        return `${hours.Name || "Operating hours"} · ${hours.TimeZone}`;
      }
    } catch {
      /* Invalid supplied configuration is reported by Flow validation. */
    }
    return "Operating hours and holidays apply.";
  }
  get scheduleChoices() {
    if (!this.availability || this.availability.isOpen) return [];
    if (this.mode === "date")
      return [
        {
          label: `Previous open date · ${this.availability.previousDate}`,
          value: this.availability.previousDate
        },
        {
          label: `Next open date · ${this.availability.nextDate}`,
          value: this.availability.nextDate
        }
      ];
    return (this.availability.choices || []).map((item) => ({
      label: choiceLabel(item),
      value: item.instantValue
    }));
  }
  scheduleConfigurationChanged() {
    this._revision++;
    this.availability = null;
    if (!this._connected) return;
    this.pending = true;
    if (this._scheduleConfigurationQueued) return;
    this._scheduleConfigurationQueued = true;
    Promise.resolve().then(async () => {
      this._scheduleConfigurationQueued = false;
      if (!this._connected) return;
      this.loadSchedules();
      // Hours changes do not change which occurrence/override the user selected.
      if (this.candidate && this.mode === "datetime") {
        const revision = this._revision;
        this.failure = "";
        try {
          await this.acceptCandidate(this.candidate, revision);
        } catch (error) {
          if (revision === this._revision) this.failure = this.errorText(error);
        } finally {
          if (revision === this._revision) this.pending = false;
        }
      } else
        await this.resolveEdit({
          dateValue: this.localDate,
          timeValue: this.localTime,
          timeZoneId: this._zone,
          valid: this._inputValid
        });
    });
  }
  async loadSchedules() {
    const revision = ++this._scheduleRevision;
    this.scheduleFailure = "";
    this.scheduleOptions = [];
    if (
      !this.hasSchedule ||
      ["supplied", "fixed"].includes(this.operatingHoursMode)
    )
      return;
    if (!this.hasScheduleCollection && !this.selectedHoursId) return;
    const configError = scheduleConfigError(this);
    if (configError) {
      this.scheduleFailure = configError;
      return;
    }
    try {
      const values = await searchHours({
        searchTerm: this._scheduleSearch,
        useIdFilter: this.hasScheduleCollection
          ? allowedScheduleIds(this) !== null
          : true,
        allowedIds: this.hasScheduleCollection
          ? allowedScheduleIds(this)
          : [this.selectedHoursId],
        filterJSON:
          this.operatingHoursMode === "filter"
            ? this.operatingHoursFilter
            : null
      });
      if (revision === this._scheduleRevision && this._connected) {
        this.scheduleOptions = values.map((item) => ({
          value: item.value,
          label: `${item.label} · ${item.timeZoneId}`
        }));
        if (!values.length)
          this.scheduleFailure =
            "No operating hours match. Adjust the search or supplied configuration.";
      }
    } catch (error) {
      if (revision === this._scheduleRevision)
        this.scheduleFailure = this.errorText(error);
    }
  }
  handleScheduleSearch(event) {
    this._scheduleSearch = event.detail.value || "";
    clearTimeout(this._scheduleTimer);
    this._scheduleRevision++;
    this._scheduleTimer = setTimeout(() => this.loadSchedules(), 250);
  }
  handleSchedule(event) {
    if (this.disabled || !this.showScheduleSelection) return;
    this._operatingHoursId = event.detail.value;
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: { name: "operatingHoursId", value: this._operatingHoursId }
      })
    );
    this.scheduleConfigurationChanged();
  }
  async assessSchedule(instantValue, revision) {
    if (!this.hasSchedule) return true;
    const configError = scheduleConfigError(this);
    if (configError) throw new Error(configError);
    const args = {
      dateValue: this.localDate,
      instantValue,
      timeZoneId: this._zone
    };
    let result;
    if (["supplied", "fixed"].includes(this.operatingHoursMode)) {
      result = await checkSupplied({ ...args, ...suppliedSchedule(this) });
    } else {
      if (!this.selectedHoursId) throw new Error("Choose operating hours.");
      result = await checkHours({
        ...args,
        operatingHoursId: this.selectedHoursId,
        allowedIds: allowedScheduleIds(this),
        useIdFilter: allowedScheduleIds(this) !== null,
        filterJSON:
          this.operatingHoursMode === "filter"
            ? this.operatingHoursFilter
            : null
      });
    }
    if (revision !== this._revision || !this._connected) return false;
    this.availability = result;
    return result.isOpen;
  }
  async acceptCandidate(candidate, revision) {
    if (this.timezoneRestrictionError) {
      this.failure = this.timezoneRestrictionError;
      this.publish("dateTimeValue", null);
      return;
    }
    // Publish no instant until schedule eligibility is known.
    this.publish("dateTimeValue", null);
    this.selectedInstant = "";
    this.candidate = candidate;
    [this.localDate, this.localTime] = candidate.localValue.split("T");
    if (await this.assessSchedule(candidate.instantValue, revision)) {
      if (revision === this._revision && this._connected)
        await this.applyCandidate(candidate, revision);
    }
  }
  async acceptDate(revision) {
    this.publish("dateValue", null);
    try {
      if (
        (await this.assessSchedule(null, revision)) &&
        revision === this._revision &&
        this._connected
      ) {
        this.publish("dateValue", this.localDate);
        this.publishChrono({ chronoDateValue: chronoDate(this.localDate) });
      }
    } catch (error) {
      if (revision === this._revision) this.failure = this.errorText(error);
    }
  }
  async handleOpenChoice(event) {
    if (this.pending || this.disabled) return;
    if (this.mode === "date") {
      if (
        !this.scheduleChoices.some((item) => item.value === event.detail.value)
      )
        return;
      await this.handleEdit({
        detail: {
          dateValue: event.detail.value,
          timeValue: "",
          timeZoneId: this._zone,
          valid: true
        }
      });
      return;
    }
    const candidate = this.availability?.choices?.find(
      (item) => item.instantValue === event.detail.value
    );
    if (!candidate) return;
    const revision = ++this._revision;
    this.pending = true;
    this.failure = "";
    // Open alternatives are projected in the display zone by Apex. Return to
    // that zone's actual rules instead of silently retaining a conflicting override.
    this.publish("offsetOverride", "");
    this.publish("offsetMode", "selected");
    try {
      await this.acceptCandidate(candidate, revision);
      if (revision === this._revision)
        this.candidates = [{ ...candidate, choice: "exact" }];
    } catch (error) {
      if (revision === this._revision) this.failure = this.errorText(error);
    } finally {
      if (revision === this._revision) this.pending = false;
    }
  }
  publish(name, value) {
    if ((name === "dateTimeValue" || name === "dateValue") && value == null)
      this.clearChrono();
    // Internal state backs the public getter; never assign to an @api property.
    if (name === "dateValue") this._date = value;
    if (name === "dateTimeValue") this._instant = value;
    if (name === "timeZoneId") this._zone = value;
    if (name === "offsetOverride") this._offsetOverride = value;
    if (name === "offsetMode") this._offsetMode = value;
    this.dispatchEvent(
      new CustomEvent("valuechange", { detail: { name, value } })
    );
  }
  errorText(error) {
    return (
      error?.body?.message ||
      error?.message ||
      "Unable to check this time. Edit the value and try again."
    );
  }
  get internalError() {
    if (
      this.mode === "datetime" &&
      this._offsetOverride &&
      !this.allowOffsetOverride
    )
      return "Offset overrides are disabled in this Flow configuration.";
    if (!["date", "datetime"].includes(this.mode))
      return "Configure mode as date or datetime.";
    if (this.pending) return "Wait for the date and time check to finish.";
    if (this.failure) return this.failure;
    if (this.hasSchedule && scheduleConfigError(this))
      return scheduleConfigError(this);
    if (this.hasSchedule && this.showScheduleSelection && !this.selectedHoursId)
      return "Choose operating hours.";
    if (this.availability && !this.availability.isOpen)
      return "Choose an open date or time.";
    if (!this._inputValid) return "Enter a valid date and time.";
    if (!this.localDate && (!this.localTime || this.mode === "date"))
      return this.required
        ? "Enter a date" + (this.mode === "datetime" ? " and time." : ".")
        : "";
    if (!validDate(this.localDate)) return "Enter a valid date.";
    if (this.mode === "date") return "";
    if (!validTime(this.localTime)) return "Enter a valid time.";
    if (!this._zone) return "Choose a time zone.";
    if (!this.selectedInstant)
      return this.candidates[0]?.choice === "backward"
        ? "Choose a corrected time, or enter another date and time."
        : "Choose which occurrence of this time to use.";
    return "";
  }
  get displayedError() {
    return (
      this.scheduleFailure ||
      this.zoneFailure ||
      (this._showErrors ? this.internalError : "")
    );
  }
  get externalError() {
    return this._renderedExternalError;
  }
  @api validate() {
    const errorMessage = this.internalError;
    return { isValid: !errorMessage, errorMessage };
  }
  @api setCustomValidity(message) {
    this._externalError = message || "";
  }
  @api reportValidity() {
    this._showErrors = true;
    this._renderedExternalError = this._externalError;
    this.template.querySelector("c-chrono-date-time-picker")?.reportValidity();
  }
}
