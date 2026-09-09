import { createElement } from "lwc";
import Component from "c/chronoFlowDateTime";
import resolve from "@salesforce/apex/ChronoPickerController.resolveLocal";
import project from "@salesforce/apex/ChronoPickerController.projectInstant";
import zones from "@salesforce/apex/ChronoPickerController.getTimeZones";
import readInitial from "@salesforce/apex/ChronoPickerController.readInitialValue";
jest.mock(
  "@salesforce/apex/ChronoPickerController.readInitialValue",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
import describe from "@salesforce/apex/ChronoPickerController.describeZones";
jest.mock(
  "@salesforce/apex/ChronoPickerController.describeZones",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
import search from "@salesforce/apex/ChronoPickerSchedules.searchHours";
import check from "@salesforce/apex/ChronoPickerSchedules.checkHours";
import supplied from "@salesforce/apex/ChronoPickerSchedules.checkSupplied";
jest.mock(
  "@salesforce/apex/ChronoPickerController.resolveLocal",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.projectInstant",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerController.getTimeZones",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.searchHours",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.checkHours",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoPickerSchedules.checkSupplied",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
const flush = async () => {
  for (let i = 0; i < 25; i++) await Promise.resolve();
};
const option = (
  instantValue = "2026-10-25T00:30:00.000Z",
  choice = "exact",
  localValue = "2026-10-25T01:30:00.000"
) => ({
  instantValue,
  choice,
  localValue,
  offsetSeconds: choice === "later" ? 0 : 3600
});
const control = (el) =>
  el.shadowRoot.querySelector("c-chrono-date-time-control");
const ui = (el) =>
  control(el).shadowRoot.querySelector("c-chrono-date-time-picker");
async function mount(props = {}) {
  const el = createElement("c-chrono-flow-date-time", { is: Component });
  Object.assign(el, { timeZoneId: "Europe/London", ...props });
  document.body.appendChild(el);
  await flush();
  return el;
}
async function edit(el, detail = {}) {
  ui(el).dispatchEvent(
    new CustomEvent("edit", {
      detail: {
        dateValue: "2026-10-25",
        timeValue: "01:30",
        timeZoneId: "Europe/London",
        valid: true,
        ...detail
      }
    })
  );
  await flush();
}
// These tests exercise the Apex bridge. Native Temporal has separate conformance tests.
const temporalDescriptor = Object.getOwnPropertyDescriptor(
  globalThis,
  "Temporal"
);
beforeAll(() => {
  Object.defineProperty(globalThis, "Temporal", {
    value: undefined,
    configurable: true
  });
});
afterAll(() => {
  if (temporalDescriptor)
    Object.defineProperty(globalThis, "Temporal", temporalDescriptor);
  else delete globalThis.Temporal;
});
beforeEach(() => {
  describe.mockResolvedValue({});
  zones.mockResolvedValue(["Europe/London", "UTC"]);
  search.mockResolvedValue([]);
  resolve.mockResolvedValue([option()]);
  check.mockResolvedValue({ isOpen: true, timeZoneId: "Europe/London" });
  supplied.mockResolvedValue({ isOpen: true, timeZoneId: "Europe/London" });
});

it("returns ISO strings and clears them while an edit is unresolved", async () => {
  const el = await mount();
  await edit(el);
  expect(el.chronoDateValue).toBe("2026-10-25");
  expect(el.chronoPlainDateTimeValue).toBe("2026-10-25T01:30:00.000");
  expect(el.chronoTimeValue).toBe("01:30:00.000");
  expect(el.chronoInstantValue).toBe("2026-10-25T00:30:00.000Z");
  expect(el.chronoZonedDateTimeValue).toBe(
    "2026-10-25T01:30:00.000+01:00[Europe/London]"
  );
  expect(el.chronoDateValue).not.toBe(el.chronoPlainDateTimeValue);
  resolve.mockResolvedValue([
    option(),
    option("2026-10-25T01:30:00.000Z", "later")
  ]);
  await edit(el);
  expect(el.chronoInstantValue).toBeNull();
  expect(el.chronoDateValue).toBeNull();
});

it("keeps override wall outputs separate from the canonical zoned result", async () => {
  project.mockResolvedValue(
    option("2026-10-25T00:30:00.000Z", "exact", "2026-10-25T01:30:00.000")
  );
  const el = await mount({
    allowOffsetOverride: true,
    offsetOverride: "+02:00",
    dateTimeValue: "2026-10-25T00:30:00.000Z"
  });
  expect(el.chronoPlainDateTimeValue).toBe("2026-10-25T02:30:00.000");
  expect(el.chronoZonedDateTimeValue).toBe(
    "2026-10-25T01:30:00.000+01:00[Europe/London]"
  );
});

it("accepts an ISO local datetime and exposes only the date output in date mode", async () => {
  readInitial.mockResolvedValue({
    success: true,
    valueType: "PlainDateTime",
    dateValue: "2026-10-25",
    timeValue: "01:30:00.000"
  });
  const source = "2026-10-25T01:30:00.000";
  const el = await mount({ initialChronoValue: source });
  expect(readInitial).toHaveBeenCalledWith({ value: source });
  expect(resolve).toHaveBeenCalledWith(
    expect.objectContaining({ timeValue: "01:30:00.000" })
  );
  expect(el.chronoInstantValue).toBe("2026-10-25T00:30:00.000Z");
  const dated = await mount({ mode: "date", dateValue: "2026-10-25" });
  expect(dated.chronoDateValue).toBe("2026-10-25");
  expect(dated.chronoZonedDateTimeValue).toBeNull();
});

it("rejects malformed ISO input without publishing a result", async () => {
  readInitial.mockRejectedValueOnce({ body: { message: "Invalid ISO date" } });
  const el = await mount({ initialChronoValue: "not-a-date" });
  expect(el.validate().isValid).toBe(false);
  expect(el.chronoDateValue).toBeNull();
});
it("clears a removed core input and never leaves a stale result", async () => {
  readInitial.mockResolvedValue({
    valueType: "PlainDate",
    dateValue: "2026-10-25"
  });
  const el = await mount({
    mode: "date",
    initialChronoValue: "2026-10-25"
  });
  expect(el.chronoDateValue).toBe("2026-10-25");
  el.initialChronoValue = null;
  await flush();
  expect(el.chronoDateValue).toBeNull();
  expect(ui(el).dateValue).toBe("");
});

it("projects a core instant in date mode without returning an instant", async () => {
  readInitial.mockResolvedValue({
    valueType: "Instant",
    instantValue: "2026-10-25T00:30:00.000Z"
  });
  project.mockResolvedValue(option());
  const el = await mount({
    mode: "date",
    initialChronoValue: "2026-10-25T00:30:00.000Z"
  });
  expect(el.dateValue).toBe("2026-10-25");
  expect(el.dateTimeValue).toBeNull();
  expect(el.chronoDateValue).toBe("2026-10-25");
  expect(el.chronoInstantValue).toBeNull();
});

it("does not restore a core value from an obsolete request", async () => {
  let finish;
  readInitial.mockImplementationOnce(
    () =>
      new Promise((resolveValue) => {
        finish = resolveValue;
      })
  );
  const el = await mount({ initialChronoValue: "2026-10-25" });
  el.initialChronoValue = null;
  await flush();
  finish({ valueType: "PlainDate", dateValue: "2026-10-25" });
  await flush();
  expect(el.chronoDateValue).toBeNull();
  expect(el.dateTimeValue).toBeFalsy();
});

it("uses Flow's restored edit on return navigation before the original initial core value", async () => {
  readInitial.mockClear();
  const restored = "2026-10-25T01:30:00.000Z";
  project.mockResolvedValue(option(restored, "later"));
  const el = await mount({
    dateTimeValue: restored,
    initialChronoValue: "2026-10-25T00:30:00.000Z"
  });
  expect(readInitial).not.toHaveBeenCalled();
  expect(el.chronoInstantValue).toBe(restored);
});

it("keeps an empty timezone allowlist closed and rejects a timezone outside it", async () => {
  const el = await mount({
    allowTimeZoneSelection: true,
    timeZoneSelectionMode: "list",
    timeZoneIds: [],
    dateValue: "2026-10-25"
  });
  expect(el.dateTimeValue).toBeNull();
  expect(ui(el).timeZoneOptions).toEqual([]);
  expect(el.validate().isValid).toBe(false);
  el.timeZoneIds = ["Europe/London"];
  await flush();
  await edit(el, { timeZoneId: "America/New_York" });
  expect(el.dateTimeValue).toBeNull();
  expect(ui(el).timeZoneOptions.map((item) => item.value)).toEqual([
    "Europe/London"
  ]);
  expect(el.validate().isValid).toBe(false);
});
it("combines fixed and Flow timezone lists without letting the current zone escape the restriction", async () => {
  const el = await mount({
    allowTimeZoneSelection: true,
    timeZoneSelectionMode: "list",
    timeZoneIds: ["Asia/Tokyo", "Asia/Tokyo"],
    timeZoneIdsText: "Europe/London\nUTC"
  });
  expect(
    ui(el)
      .timeZoneOptions.map((item) => item.value)
      .sort()
  ).toEqual(["Asia/Tokyo", "Europe/London", "UTC"]);
});
it("selects an occurrence through the real slotted menu after focus moves from its trigger", async () => {
  const first = option();
  first.choice = "earlier";
  const second = option("2026-10-25T01:30:00.000Z", "later");
  resolve.mockResolvedValue([first, second]);
  const el = await mount();
  await edit(el);
  const offset = ui(el).shadowRoot.querySelector("c-chrono-offset-picker");
  const popover = offset.shadowRoot.querySelector("c-chrono-picker-popover");
  const trigger = popover.shadowRoot.querySelector("button");
  trigger.focus();
  trigger.click();
  await flush();
  const menu = offset.shadowRoot.querySelector("c-chrono-picker-menu");
  const secondButton = menu.shadowRoot.querySelectorAll("button")[1];
  secondButton.dispatchEvent(
    new Event("pointerdown", { bubbles: true, composed: true })
  );
  // Synthetic shadow can retarget the destination to the slot's owning host.
  trigger.dispatchEvent(
    new FocusEvent("focusout", { bubbles: true, relatedTarget: offset })
  );
  secondButton.focus();
  await new Promise((done) => setTimeout(done, 5));
  await flush();
  expect(popover.shadowRoot.querySelector("section")).not.toBeNull();
  secondButton.click();
  await flush();
  expect(el.dateTimeValue).toBe(second.instantValue);
  expect(el.offsetMode).toBe("selected");
});
it("resolves a supplied date at local midnight and passes through the admin date style", async () => {
  const midnight = option(
    "2026-10-24T23:00:00.000Z",
    "exact",
    "2026-10-25T00:00:00.000"
  );
  resolve.mockResolvedValue([midnight]);
  const el = await mount({ dateValue: "2026-10-25", dateStyle: "short" });
  expect(resolve).toHaveBeenCalledWith({
    dateValue: "2026-10-25",
    timeValue: "00:00:00.000",
    timeZoneId: "Europe/London"
  });
  expect(ui(el).timeValue).toBe("00:00:00.000");
  expect(el.dateTimeValue).toBe(midnight.instantValue);
  expect(ui(el).dateStyle).toBe("short");
});
it("does not silently correct a skipped midnight", async () => {
  resolve.mockResolvedValue([
    option("2011-12-30T09:59:59.999Z", "backward", "2011-12-29T23:59:59.999"),
    option("2011-12-30T10:00:00.000Z", "forward", "2011-12-31T00:00:00.000")
  ]);
  const el = await mount({
    dateValue: "2011-12-30",
    timeZoneId: "Pacific/Apia",
    required: true
  });
  expect(ui(el).timeValue).toBe("00:00:00.000");
  expect(ui(el).candidates).toHaveLength(2);
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
});
it("keeps offset overrides explicit, reopens automatic choices, and restores zone rules", async () => {
  const automatic = option(
    "2026-03-15T10:00:00.000Z",
    "exact",
    "2026-03-15T10:00:00.000"
  );
  automatic.offsetSeconds = 0;
  resolve.mockResolvedValue([automatic]);
  const el = await mount({ allowOffsetOverride: true });
  await edit(el, { dateValue: "2026-03-15", timeValue: "10:00" });
  ui(el).dispatchEvent(
    new CustomEvent("offsetchange", { detail: { value: "+01:00" } })
  );
  await flush();
  expect(el.dateTimeValue).toBe("2026-03-15T09:00:00.000Z");
  expect(ui(el).timeValue).toBe("10:00:00.000");
  expect(el.offsetMode).toBe("override");
  expect(el.offsetOverride).toBe("+01:00");
  expect(ui(el).candidates[0].instantValue).toBe(automatic.instantValue);
  ui(el).dispatchEvent(
    new CustomEvent("offsetchange", { detail: { value: "" } })
  );
  await flush();
  expect(el.dateTimeValue).toBe(automatic.instantValue);
  expect(el.offsetMode).toBe("auto");
  expect(el.offsetOverride).toBe("");
});
it("restores the original overridden wall time from Flow's instant and offset", async () => {
  project.mockResolvedValue(
    option("2026-03-15T09:00:00.000Z", "exact", "2026-03-15T09:00:00.000")
  );
  const el = await mount({
    allowOffsetOverride: true,
    offsetOverride: "+01:00",
    dateTimeValue: "2026-03-15T09:00:00.000Z"
  });
  expect(ui(el).timeValue).toBe("10:00:00.000");
  expect(el.dateTimeValue).toBe("2026-03-15T09:00:00.000Z");
  expect(el.offsetMode).toBe("override");
});
it("passes the overridden instant to an independent New York schedule and blocks closed results", async () => {
  resolve.mockResolvedValue([
    {
      ...option("2026-03-15T10:00:00.000Z", "exact", "2026-03-15T10:00:00.000"),
      offsetSeconds: 0
    }
  ]);
  const el = await mount({
    allowOffsetOverride: true,
    operatingHoursMode: "id",
    operatingHoursId: "0OH000000000001AAA"
  });
  await edit(el, { dateValue: "2026-03-15", timeValue: "10:00" });
  check.mockResolvedValue({
    isOpen: false,
    scheduleName: "New York weekdays",
    timeZoneId: "America/New_York",
    choices: []
  });
  ui(el).dispatchEvent(
    new CustomEvent("offsetchange", { detail: { value: "+01:00" } })
  );
  await flush();
  expect(check.mock.calls.at(-1)[0].instantValue).toBe(
    "2026-03-15T09:00:00.000Z"
  );
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
  expect(ui(el).scheduleMessage).toContain("America/New_York");
});
it("locks schedule selection independently and ignores disallowed offset edits", async () => {
  const el = await mount({
    allowTimeZoneSelection: true,
    lockOperatingHoursSelection: true,
    operatingHoursMode: "ids",
    operatingHoursIds: ["0OH000000000001AAA"],
    operatingHoursId: "0OH000000000001AAA"
  });
  expect(ui(el).showScheduleSelection).toBe(false);
  expect(ui(el).allowTimeZoneSelection).toBe(true);
  ui(el).dispatchEvent(
    new CustomEvent("schedulechange", {
      detail: { value: "0OH000000000002AAA" }
    })
  );
  ui(el).dispatchEvent(
    new CustomEvent("offsetchange", { detail: { value: "+01:00" } })
  );
  await flush();
  expect(el.operatingHoursId).toBe("0OH000000000001AAA");
  expect(el.offsetOverride).toBe("");
});
it("revalidates reactive schedule inputs even when user editing is disabled", async () => {
  const el = await mount({
    disabled: true,
    mode: "date",
    dateValue: "2026-09-07"
  });
  supplied.mockResolvedValue({
    isOpen: false,
    timeZoneId: "America/New_York",
    previousDate: "2026-09-04",
    nextDate: "2026-09-08"
  });
  el.operatingHoursMode = "supplied";
  el.operatingHoursRecord = { Name: "New York", TimeZone: "America/New_York" };
  el.timeSlots = [
    { DayOfWeek: "Monday", StartTime: "09:00", EndTime: "17:00" }
  ];
  await flush();
  expect(supplied).toHaveBeenCalledTimes(1);
  expect(el.validate().errorMessage).toBe("Choose an open date or time.");
  expect(ui(el).pending).toBe(false);
});
afterEach(() => {
  while (document.body.firstChild)
    document.body.removeChild(document.body.firstChild);
  jest.resetAllMocks();
  jest.useRealTimers();
});
it("discards a stale timezone-search offset after the entered date changes", async () => {
  jest.useFakeTimers();
  resolve.mockResolvedValue([
    option("2026-03-15T10:00:00.000Z", "exact", "2026-03-15T10:00:00.000")
  ]);
  const el = await mount({ allowTimeZoneSelection: true });
  await edit(el, { dateValue: "2026-03-15", timeValue: "10:00" });
  let finishOld;
  describe.mockImplementationOnce(
    () =>
      new Promise((done) => {
        finishOld = done;
      })
  );
  ui(el).dispatchEvent(
    new CustomEvent("zonesearch", { detail: { value: "London" } })
  );
  jest.advanceTimersByTime(250);
  await flush();
  resolve.mockResolvedValue([
    option("2026-07-15T09:00:00.000Z", "exact", "2026-07-15T10:00:00.000")
  ]);
  describe.mockResolvedValue({
    "Europe/London": [{ choice: "exact", offsetSeconds: 3600 }]
  });
  await edit(el, { dateValue: "2026-07-15", timeValue: "10:00" });
  jest.advanceTimersByTime(250);
  await flush();
  finishOld({ "Europe/London": [{ choice: "exact", offsetSeconds: 0 }] });
  await flush();
  expect(
    ui(el).timeZoneOptions.find((item) => item.value === "Europe/London").detail
  ).toBe("UTC+01:00");
});
it("date-only mode uses native Flow dates without timezone resolution", async () => {
  const el = await mount({ mode: "date", required: true });
  expect(el.validate().isValid).toBe(false);
  await edit(el, { dateValue: "2026-09-06", timeValue: "" });
  expect(el.dateValue).toBe("2026-09-06");
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(true);
  expect(resolve).not.toHaveBeenCalled();
  expect(project).not.toHaveBeenCalled();
});
it("requires an occurrence and retains both options after selection", async () => {
  const options = [
    option(undefined, "earlier"),
    option("2026-10-25T01:30:00.000Z", "later")
  ];
  resolve.mockResolvedValue(options);
  const el = await mount();
  await edit(el);
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
  ui(el).dispatchEvent(
    new CustomEvent("resolvechoice", {
      detail: { instantValue: options[1].instantValue }
    })
  );
  await flush();
  expect(el.dateTimeValue).toBe(options[1].instantValue);
  expect(ui(el).candidates).toHaveLength(2);
  expect(el.validate().isValid).toBe(true);
  await edit(el, { timeValue: "" });
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
});
it("shows gap boundaries and updates the visible local value after correction", async () => {
  const choices = [
    option("2026-03-29T00:59:59.999Z", "backward", "2026-03-29T00:59:59.999"),
    option("2026-03-29T01:00:00.000Z", "forward", "2026-03-29T02:00:00.000")
  ];
  resolve.mockResolvedValue(choices);
  const el = await mount();
  await edit(el, { dateValue: "2026-03-29" });
  expect(el.validate().isValid).toBe(false);
  ui(el).dispatchEvent(
    new CustomEvent("resolvechoice", {
      detail: { instantValue: choices[1].instantValue }
    })
  );
  await flush();
  expect(ui(el).timeValue).toBe("02:00:00.000");
  expect(el.dateTimeValue).toBe(choices[1].instantValue);
  expect(el.validate().isValid).toBe(true);
});
it("discards stale Apex responses and blocks navigation during a check", async () => {
  let finishOld;
  resolve.mockImplementationOnce(
    () =>
      new Promise((done) => {
        finishOld = done;
      })
  );
  const el = await mount();
  await edit(el);
  expect(el.validate().isValid).toBe(false);
  const latest = option(
    "2026-10-25T03:00:00.000Z",
    "exact",
    "2026-10-25T03:00:00.000"
  );
  resolve.mockResolvedValue([latest]);
  await edit(el, { timeValue: "03:00" });
  finishOld([option()]);
  await flush();
  expect(el.dateTimeValue).toBe(latest.instantValue);
});
it("keeps an initial later occurrence and exposes both choices", async () => {
  const later = option("2026-10-25T01:30:00.000Z", "later");
  project.mockResolvedValue(later);
  resolve.mockResolvedValue([option(undefined, "earlier"), later]);
  const el = await mount({ dateTimeValue: later.instantValue });
  expect(el.dateTimeValue).toBe(later.instantValue);
  expect(ui(el).selectedInstant).toBe(later.instantValue);
  expect(ui(el).candidates).toHaveLength(2);
});
it("clears a failed resolution and renders external errors only when requested", async () => {
  resolve.mockRejectedValue({ body: { message: "Permission denied" } });
  const el = await mount();
  await edit(el);
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().errorMessage).toBe("Permission denied");
  el.setCustomValidity("<b>External validation</b>");
  el.reportValidity();
  await flush();
  expect(
    control(el).shadowRoot.querySelector("lightning-formatted-rich-text").value
  ).toContain("External validation");
  el.setCustomValidity("");
  el.reportValidity();
  await flush();
  expect(
    control(el).shadowRoot.querySelector("lightning-formatted-rich-text")
  ).toBeNull();
});
it("rechecks a closed datetime before accepting the next open alternative", async () => {
  const next = option(
    "2026-10-27T09:00:00.000Z",
    "nextOpen",
    "2026-10-27T09:00:00.000"
  );
  check
    .mockResolvedValueOnce({
      isOpen: false,
      timeZoneId: "Europe/London",
      scheduleName: "Support",
      choices: [next]
    })
    .mockResolvedValue({ isOpen: true, timeZoneId: "Europe/London" });
  const el = await mount({
    operatingHoursMode: "id",
    operatingHoursId: "0OH000000000001AAA"
  });
  await edit(el);
  expect(el.dateTimeValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
  ui(el).dispatchEvent(
    new CustomEvent("openchoice", { detail: { value: next.instantValue } })
  );
  await flush();
  expect(el.dateTimeValue).toBe(next.instantValue);
  expect(check).toHaveBeenCalledTimes(2);
});
it("supplied records bypass saved-schedule queries and can restrict date-only input", async () => {
  supplied.mockResolvedValue({
    isOpen: false,
    timeZoneId: "Europe/London",
    previousDate: "2026-08-28",
    nextDate: "2026-09-01"
  });
  const el = await mount({
    mode: "date",
    operatingHoursMode: "supplied",
    operatingHoursRecord: { Name: "Unsaved", TimeZone: "Europe/London" },
    timeSlots: [{ DayOfWeek: "Monday", StartTime: "09:00", EndTime: "17:00" }]
  });
  await edit(el, { dateValue: "2026-08-31", timeValue: "" });
  expect(el.dateValue).toBeNull();
  expect(el.validate().isValid).toBe(false);
  expect(supplied.mock.calls[0][0].operatingHours.Id).toBeUndefined();
  expect(check).not.toHaveBeenCalled();
  expect(search).not.toHaveBeenCalled();
});
it("converts fixed values into the native-record bridge", async () => {
  const el = await mount({
    operatingHoursMode: "fixed",
    fixedHours: JSON.stringify({
      definition: { name: "Dynamic", timeZoneId: "UTC" },
      slots: [{ dayOfWeek: "Monday", startTime: "09:00", endTime: "17:00" }]
    })
  });
  await edit(el);
  expect(supplied.mock.calls[0][0].operatingHours).toEqual({
    Name: "Dynamic",
    TimeZone: "UTC"
  });
  expect(supplied.mock.calls[0][0].timeSlots[0].DayOfWeek).toBe("Monday");
  expect(supplied.mock.calls[0][0].timeSlots[0].StartTime).toBe(32400000);
});
it("loads only the Flow-supplied ID choices", async () => {
  search.mockResolvedValue([
    { value: "0OH000000000001AAA", label: "Support", timeZoneId: "UTC" }
  ]);
  const ids = ["0OH000000000001AAA"];
  const el = await mount({ operatingHoursMode: "ids", operatingHoursIds: ids });
  expect(search).toHaveBeenCalledWith(
    expect.objectContaining({ allowedIds: ids })
  );
  expect(ui(el).showScheduleSelection).toBe(true);
});
