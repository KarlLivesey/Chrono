import { createElement } from "lwc";
import Duration from "c/chronoDurationInput";
import Partial from "c/chronoPartialDateInput";
import Range from "c/chronoRangePicker";
import FlowRange from "c/chronoFlowRange";
import Availability from "c/chronoAvailabilityPicker";
import Recurrence from "c/chronoRecurrenceBuilder";
import FlowRecurrence from "c/chronoFlowRecurrence";
import Display from "c/chronoZoneDisplay";
import Record from "c/chronoRecordDateTime";
import { getRecord, updateRecord } from "lightning/uiRecordApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import available from "@salesforce/apex/ChronoComponentActions.availability";
import recur from "@salesforce/apex/ChronoComponentActions.recurrence";
import initial from "@salesforce/apex/ChronoPickerController.readInitialValue";
import zones from "@salesforce/apex/ChronoPickerController.getTimeZones";
import project from "@salesforce/apex/ChronoPickerController.projectInstant";
jest.mock(
  "@salesforce/apex/ChronoComponentActions.availability",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoComponentActions.recurrence",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.readInitialValue",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.getTimeZones",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.projectInstant",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.resolveLocal",
  () => ({ default: jest.fn().mockResolvedValue([]) }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.describeZones",
  () => ({ default: jest.fn().mockResolvedValue({}) }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.searchHours",
  () => ({ default: jest.fn().mockResolvedValue([]) }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.checkHours",
  () => ({ default: jest.fn().mockResolvedValue({ isOpen: true }) }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.checkSupplied",
  () => ({ default: jest.fn().mockResolvedValue({ isOpen: true }) }),
  { virtual: true }
);
const flush = async () => {
  for (let i = 0; i < 40; i++) await Promise.resolve();
};
async function mount(Component, props = {}) {
  const el = createElement("c-test-control", { is: Component });
  Object.assign(el, props);
  document.body.appendChild(el);
  await flush();
  return el;
}
function edit(el, selector, value) {
  const field = el.shadowRoot.querySelector(selector);
  field.value = value;
  field.dispatchEvent(new CustomEvent("change", { detail: { value } }));
}
function valueEvent(control, name, value) {
  control.dispatchEvent(
    new CustomEvent("valuechange", { detail: { name, value } })
  );
}
beforeEach(() => {
  zones.mockResolvedValue(["UTC", "Europe/London"]);
  initial.mockImplementation(async ({ value }) => ({
    valueType: "PlainDate",
    dateValue: value.slice(0, 10)
  }));
  project.mockImplementation(async ({ instantValue }) => ({
    instantValue,
    localValue: instantValue.replace(/Z$/, ""),
    choice: "exact",
    offsetSeconds: 0
  }));
});
afterEach(() => {
  while (document.body.firstChild)
    document.body.removeChild(document.body.firstChild);
  jest.clearAllMocks();
});
it("edits a duration through ordinary unit fields and reports invalid input", async () => {
  const el = await mount(Duration, { value: "P1DT2H", required: true });
  const change = jest.fn();
  el.addEventListener("valuechange", change);
  edit(el, '[data-field="minutes"]', "30");
  await flush();
  expect(change.mock.calls.at(-1)[0].detail.value).toBe("P1DT9000S");
  edit(el, '[data-field="days"]', "-1");
  expect(el.validate().isValid).toBe(false);
  expect(change.mock.calls.at(-1)[0].detail.value).toBeNull();
});
it("rejects invalid month/day combinations in the rendered control", async () => {
  const el = await mount(Partial, { kind: "monthday", value: "--02-29" });
  expect(el.validate().isValid).toBe(true);
  edit(el, '[data-field="month"]', "4");
  edit(el, '[data-field="day"]', "31");
  expect(el.validate().isValid).toBe(false);
});
it("checks range ordering and never restores an initial value after clearing", async () => {
  const el = await mount(Range, {
    mode: "date",
    startValue: "2026-09-07",
    endValue: "2026-09-09",
    required: true
  });
  const change = jest.fn();
  el.addEventListener("valuechange", change);
  const controls = el.shadowRoot.querySelectorAll("c-chrono-date-time-control");
  valueEvent(controls[1], "chronoDateValue", "2026-09-06");
  await flush();
  expect(el.validate().isValid).toBe(false);
  valueEvent(controls[0], "chronoDateValue", null);
  await flush();
  expect(change.mock.calls.at(-1)[0].detail.startValue).toBeNull();
  expect(change.mock.calls.at(-1)[0].detail.rangeValue).toBeNull();
});
it("ignores obsolete availability responses and emits native and ISO outputs", async () => {
  let finish;
  available.mockImplementationOnce(
    () =>
      new Promise((resolve) => {
        finish = resolve;
      })
  );
  const el = await mount(Availability, {
    input: { value: "old" },
    required: true
  });
  const change = jest.fn();
  el.addEventListener("valuechange", change);
  available.mockResolvedValueOnce({
    success: true,
    ranges: ["range"],
    openingValues: ["2026-09-08T09:00:00+01:00[Europe/London]"],
    closingValues: ["2026-09-08T09:30:00+01:00[Europe/London]"]
  });
  el.input = { value: "new" };
  await flush();
  finish({ success: false, errorMessage: "obsolete" });
  await flush();
  const lookup = el.shadowRoot.querySelector("c-chrono-choice-lookup");
  expect(lookup.options).toHaveLength(1);
  lookup.dispatchEvent(
    new CustomEvent("choose", { detail: { value: "range" } })
  );
  await flush();
  expect(el.validate().isValid).toBe(true);
  expect(change.mock.calls.at(-1)[0].detail.startDateTime).toBe(
    "2026-09-08T08:00:00.000Z"
  );
});
it("does not silently truncate appointment results or hide server failures", async () => {
  available.mockResolvedValue({
    success: false,
    errorMessage: "Appointment result limit exceeded."
  });
  const el = await mount(Availability, { input: { duration: "PT30M" } });
  expect(el.validate()).toEqual({
    isValid: false,
    errorMessage: "Appointment result limit exceeded."
  });
});
it("builds a weekly rule and invalidates an outdated recurrence preview", async () => {
  const el = await mount(Recurrence, {
    untilDate: "2026-12-31",
    timeZoneId: "UTC"
  });
  const control = el.shadowRoot.querySelector("c-chrono-date-time-control");
  valueEvent(
    control,
    "chronoZonedDateTimeValue",
    "2026-09-08T09:00:00+00:00[UTC]"
  );
  edit(el, '[data-field="weekdays"]', ["TU", "TH"]);
  await flush();
  expect(el.rule).toBe("FREQ=WEEKLY;INTERVAL=1;COUNT=6;BYDAY=TU,TH");
  let finish;
  recur.mockImplementation(
    () =>
      new Promise((resolve) => {
        finish = resolve;
      })
  );
  el.shadowRoot.querySelector("lightning-button").click();
  await flush();
  edit(el, '[data-field="interval"]', 2);
  finish({ success: true, values: ["2026-09-08T09:00:00+00:00[UTC]"] });
  await flush();
  expect(el.validate().isValid).toBe(false);
  expect(el.shadowRoot.querySelectorAll("li")).toHaveLength(0);
});
it("calculates display offsets at the supplied date instead of today", async () => {
  const winter = await mount(Display, {
    value: "2026-01-08T10:00:00Z",
    timeZoneIds: ["Europe/London"]
  });
  expect(winter.shadowRoot.textContent).toContain("UTC");
  expect(winter.shadowRoot.textContent).not.toContain("UTC+01:00");
  winter.value = "2026-07-08T10:00:00Z";
  await flush();
  expect(winter.shadowRoot.textContent).toContain("UTC+01:00");
});
it("saves only configured fields and checks the record version", async () => {
  const el = await mount(Record, {
    recordId: "001000000000001AAA",
    objectApiName: "Account",
    dateTimeField: "Renewal__c"
  });
  getObjectInfo.emit({
    updateable: true,
    fields: { Renewal__c: { dataType: "Date", updateable: true } }
  });
  await flush();
  getRecord.emit({
    id: "001000000000001AAA",
    fields: {
      LastModifiedDate: { value: "2026-09-08T10:00:00Z" },
      Renewal__c: { value: "2026-09-08" }
    }
  });
  await flush();
  const control = el.shadowRoot.querySelector("c-chrono-date-time-control");
  expect(control).not.toBeNull();
  valueEvent(control, "dateValue", "2026-09-09");
  await flush();
  updateRecord.mockResolvedValue({ id: "001000000000001AAA" });
  el.shadowRoot.querySelector("lightning-button").click();
  await flush();
  expect(updateRecord).toHaveBeenCalledWith(
    { fields: { Id: "001000000000001AAA", Renewal__c: "2026-09-09" } },
    { ifUnmodifiedSince: "2026-09-08T10:00:00Z" }
  );
});
it("keeps inaccessible fields read-only", async () => {
  const el = await mount(Record, {
    recordId: "001000000000001AAA",
    objectApiName: "Account",
    dateTimeField: "Renewal__c"
  });
  getObjectInfo.emit({
    updateable: true,
    fields: { Renewal__c: { dataType: "Date", updateable: false } }
  });
  await flush();
  getRecord.emit({
    id: "001000000000001AAA",
    fields: {
      LastModifiedDate: { value: "2026-09-08T10:00:00Z" },
      Renewal__c: { value: "2026-09-08" }
    }
  });
  await flush();
  expect(el.shadowRoot.querySelector("lightning-button").disabled).toBe(true);
  expect(updateRecord).not.toHaveBeenCalled();
});
it("leaves the date editable when only the timezone field is read-only", async () => {
  const el = await mount(Record, {
    recordId: "001000000000001AAA",
    objectApiName: "Account",
    dateTimeField: "Renewal__c",
    timeZoneField: "Zone__c",
    allowTimeZoneSelection: true
  });
  getObjectInfo.emit({
    updateable: true,
    fields: {
      Renewal__c: { dataType: "Date", updateable: true },
      Zone__c: { dataType: "String", updateable: false }
    }
  });
  await flush();
  getRecord.emit({
    id: "001000000000001AAA",
    fields: {
      LastModifiedDate: { value: "2026-09-08T10:00:00Z" },
      Renewal__c: { value: "2026-09-08" },
      Zone__c: { value: "UTC" }
    }
  });
  await flush();
  const control = el.shadowRoot.querySelector("c-chrono-date-time-control");
  expect(control.disabled).toBe(false);
  expect(control.allowTimeZoneSelection).toBe(false);
  el.recordId = "001000000000002AAA";
  await flush();
  expect(el.shadowRoot.querySelector("c-chrono-date-time-control")).toBeNull();
});
it("restores only an appointment that is still available and clears failed refreshes", async () => {
  const start = "2026-09-08T09:00:00+01:00[Europe/London]";
  const end = "2026-09-08T09:30:00+01:00[Europe/London]";
  const range = `${start}/${end}`;
  available.mockResolvedValue({
    success: true,
    ranges: [range],
    openingValues: [start],
    closingValues: [end]
  });
  const el = await mount(Availability, {
    value: range,
    required: true,
    input: { duration: "PT30M" }
  });
  expect(el.validate().isValid).toBe(true);
  expect(el.shadowRoot.querySelector("c-chrono-choice-lookup").value).toBe(
    range
  );
  const change = jest.fn();
  el.addEventListener("valuechange", change);
  available.mockRejectedValue(new Error("Schedule unavailable"));
  el.input = { duration: "PT60M" };
  await flush();
  expect(el.validate().isValid).toBe(false);
  expect(change.mock.calls.at(-1)[0].detail.rangeValue).toBeNull();
});
it("rechecks a range after its supplied schedule changes", async () => {
  available.mockResolvedValue({ success: true, containsRange: true });
  const el = await mount(Range, {
    mode: "date",
    startValue: "2026-09-07",
    endValue: "2026-09-09",
    operatingHoursId: "old"
  });
  const change = jest.fn();
  el.addEventListener("valuechange", change);
  available.mockResolvedValue({ success: true, containsRange: false });
  el.operatingHoursId = "changed";
  await flush();
  expect(available.mock.calls.at(-1)[0].input.operatingHoursId).toBe("changed");
  expect(el.validate().errorMessage).toContain("outside operating hours");
  expect(change.mock.calls.at(-1)[0].detail.rangeValue).toBeNull();
});

it("keeps Flow range outputs available when navigating away", async () => {
  const el = await mount(FlowRange, {
    mode: "date",
    startValue: "2026-09-07",
    endValue: "2026-09-09"
  });
  expect(el.rangeValue).toBe("2026-09-07/2026-09-09");
  expect(el.duration).toBe("P2D");
  el.endValue = "2026-09-10";
  await flush();
  expect(el.rangeValue).toBe("2026-09-07/2026-09-10");
  expect(el.duration).toBe("P3D");
});

it("keeps recurrence outputs without resetting the starting control", async () => {
  const el = await mount(FlowRecurrence, {
    timeZoneId: "UTC",
    untilDate: "2026-12-31",
    closedPolicy: "skip"
  });
  const builder = el.shadowRoot.querySelector("c-chrono-recurrence-builder");
  expect(builder.closedPolicy).toBe("skip");
  valueEvent(
    builder.shadowRoot.querySelector("c-chrono-date-time-control"),
    "chronoZonedDateTimeValue",
    "2026-09-08T09:00:00+00:00[UTC]"
  );
  await flush();
  recur.mockResolvedValue({
    success: true,
    values: ["2026-09-08T09:00:00+00:00[UTC]"]
  });
  builder.shadowRoot.querySelector("lightning-button").click();
  await flush();
  expect(el.startValue).toBe("2026-09-08T09:00:00+00:00[UTC]");
  expect(el.values).toHaveLength(1);
  expect(el.validate().isValid).toBe(true);
  el.untilDate = "2026-10-01";
  await flush();
  expect(el.values).toHaveLength(0);
  expect(el.validate().isValid).toBe(false);
});

it("keeps appointments selectable after a required-field validation error", async () => {
  const start = "2026-09-08T09:00:00.000+01:00[Europe/London]";
  const end = "2026-09-08T09:30:00.000+01:00[Europe/London]";
  const range = `${start}/${end}`;
  available.mockResolvedValue({
    success: true,
    ranges: [range],
    openingValues: [start],
    closingValues: [end]
  });
  const el = await mount(Availability, {
    required: true,
    input: { duration: "PT30M" }
  });
  expect(el.reportValidity()).toBe(false);
  await flush();
  const lookup = el.shadowRoot.querySelector("c-chrono-choice-lookup");
  expect(lookup).not.toBeNull();
  lookup.dispatchEvent(new CustomEvent("choose", { detail: { value: range } }));
  await flush();
  expect(el.validate().isValid).toBe(true);
  expect(el.shadowRoot.querySelector('[role="alert"]')).toBeNull();
});
