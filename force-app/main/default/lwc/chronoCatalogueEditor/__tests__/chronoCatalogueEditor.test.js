import { createElement } from "lwc";
import Editor from "c/chronoCatalogueEditor";
jest.mock(
  "@salesforce/apex/ChronoPickerController.getTimeZones",
  () => ({
    default: jest.fn().mockResolvedValue(["Europe/London", "America/New_York"])
  }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoFlowEditorController.getFields",
  () => ({ default: jest.fn().mockResolvedValue([]) }),
  { virtual: true }
);
const input = (name, value, valueDataType = "String") => ({
  name,
  value,
  valueDataType
});
const flush = async () => {
  for (let i = 0; i < 8; i++) await Promise.resolve();
};
function mount(kind, values) {
  const el = createElement("c-chrono-catalogue-editor", { is: Editor });
  el.kind = kind;
  el.inputVariables = values;
  document.body.appendChild(el);
  return el;
}
const field = (el, name) =>
  [...el.shadowRoot.querySelectorAll("c-chrono-flow-value-editor")].find(
    (item) => item.name === name
  );
afterEach(() => {
  document.body.replaceChildren();
});
it("offers only month/day components without requiring a made-up year", async () => {
  const el = mount("CreateValue", [
    input("valueType", "PlainMonthDay"),
    input("month", 2, "Number"),
    input("day", 29, "Number")
  ]);
  await flush();
  expect(field(el, "year")).toBeUndefined();
  expect(field(el, "hour")).toBeUndefined();
  expect(el.validate()).toEqual([]);
  expect(
    field(el, "valueType").options.some((option) => option.value === "Duration")
  ).toBe(false);
});
it("uses native Date and clock inputs for replacement without asking for ISO text", async () => {
  const el = mount("ReplaceValue", [
    input("valueType", "PlainDateTime"),
    input("dateValue", "StartDate", "reference"),
    input("timeValue", "09:00")
  ]);
  await flush();
  expect(field(el, "dateValue").valueType).toBe("Date");
  expect(field(el, "timeValue").literalType).toBe("time");
  expect(field(el, "value")).toBeUndefined();
  expect(el.validate()).toEqual([]);
});
it("shows one side of Unix conversion and clears incompatible old inputs", async () => {
  const el = mount("EpochValue", [
    input("operation", "fromEpoch"),
    input("epochValue", -0.001, "Number"),
    input("epochUnit", "second")
  ]);
  await flush();
  expect(field(el, "valueType")).toBeUndefined();
  expect(field(el, "value")).toBeUndefined();
  expect(el.validate()).toEqual([]);
  const removed = jest.fn();
  el.addEventListener("configuration_editor_input_value_deleted", removed);
  field(el, "operation").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "operation",
        value: "toEpoch",
        dataType: "String",
        reference: false
      }
    })
  );
  await flush();
  expect(field(el, "epochValue")).toBeUndefined();
  expect(field(el, "valueType")).toBeDefined();
  expect(removed.mock.calls.map((call) => call[0].detail.name)).toContain(
    "epochValue"
  );
});
it("retains native format when a reference is cleared before replacement", async () => {
  const el = mount("ValueDetails", [
    input("valueType", "Instant"),
    input("instantValue", "StartInstant", "reference"),
    input("timeZoneId", "Europe/London")
  ]);
  await flush();
  field(el, "instantValue").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "instantValue",
        value: null,
        dataType: "Datetime",
        reference: true
      }
    })
  );
  await flush();
  expect(field(el, "instantValue")).toBeDefined();
  expect(field(el, "value")).toBeUndefined();
});
it("requires an explicit parsing pattern", async () => {
  const el = mount("ParseValue", [
    input("valueType", "PlainDate"),
    input("text", "03/04/2026")
  ]);
  await flush();
  expect(el.validate().map((error) => error.key)).toContain("pattern");
});
it("filters collection resources to the correct global request class", async () => {
  const el = createElement("c-chrono-catalogue-editor", { is: Editor });
  el.kind = "ValueDetails";
  el.collection = true;
  el.inputVariables = [input("items", "Requests", "reference")];
  document.body.appendChild(el);
  await flush();
  const selector = el.shadowRoot.querySelector("c-chrono-flow-resource-picker");
  expect(selector.objectType).toBe("skel__ChronoValueDetailsInput");
  expect(selector.valueType).toBe("Apex[]");
  expect(el.validate()).toEqual([]);
});
it("routes fixed interval lines and a resource collection into mutually exclusive inputs", async () => {
  const el = mount("RangeTools", [
    input("operation", "subtract"),
    input("valueType", "PlainDate"),
    input("value", "2026-01-01"),
    input("endValue", "2026-02-01"),
    input("rangesText", "2026-01-03/2026-01-04")
  ]);
  await flush();
  expect(field(el, "ranges").literalType).toBe("textarea");
  expect(field(el, "ranges").value).toBe("2026-01-03/2026-01-04");
  const deleted = jest.fn();
  el.addEventListener("configuration_editor_input_value_deleted", deleted);
  field(el, "ranges").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "ranges",
        value: "BusyIntervals",
        reference: true,
        dataType: "String"
      }
    })
  );
  await flush();
  expect(field(el, "ranges").reference).toBe(true);
  expect(deleted.mock.calls.map((call) => call[0].detail.name)).toContain(
    "rangesText"
  );
  expect(field(el, "ranges").valueType).toBe("String[]");
});
it("uses one native collection selector with the correct element type", async () => {
  const el = mount("CollectionTools", [
    input("operation", "sort"),
    input("valueType", "Instant"),
    input("datetimes", "Timestamps", "reference")
  ]);
  await flush();
  expect(field(el, "datetimes").valueType).toBe("DateTime[]");
  expect(field(el, "datetimes").referenceOnly).toBe(true);
  expect(field(el, "dates")).toBeUndefined();
  expect(field(el, "values")).toBeUndefined();
});
it("shows supplied native operating records instead of a competing ID field", async () => {
  const el = mount("Availability", [
    input("operation", "validateSchedule"),
    input("operatingHours", "MySchedule", "reference")
  ]);
  await flush();
  expect(field(el, "operatingHoursId")).toBeUndefined();
  expect(field(el, "operatingHours").objectType).toBe("OperatingHours");
  expect(field(el, "timeSlots").valueType).toBe("SObject[]");
  expect(field(el, "timeSlots").objectType).toBe("TimeSlot");
  expect(field(el, "valueType")).toBeUndefined();
});
it("retains one native end-date input and its optional local clock", async () => {
  const el = mount("RangeTools", [
    input("operation", "contains"),
    input("valueType", "PlainDateTime"),
    input("dateValue", "Start", "reference"),
    input("timeValue", "09:00"),
    input("endDate", "Finish", "reference")
  ]);
  await flush();
  expect(field(el, "endDate").valueType).toBe("Date");
  expect(field(el, "endTime")).toBeDefined();
  expect(field(el, "endValue")).toBeUndefined();
});
it("keeps native auxiliary resource choices while replacing a binding", async () => {
  const el = mount("RangeTools", [
    input("operation", "contains"),
    input("valueType", "PlainDate"),
    input("pointDate", "Target", "reference")
  ]);
  await flush();
  expect(field(el, "pointDate").valueType).toBe("Date");
  expect(field(el, "pointValue")).toBeUndefined();
  field(el, "pointDate").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "pointDate",
        value: null,
        reference: true,
        dataType: "Date"
      }
    })
  );
  await flush();
  expect(field(el, "pointDate")).toBeDefined();
  expect(field(el, "pointValue")).toBeUndefined();
});
it("removes incompatible values when choosing duration formatting", async () => {
  const el = mount("FormatValue", [
    input("operation", "value"),
    input("valueType", "PlainDate"),
    input("value", "2026-09-07")
  ]);
  await flush();
  field(el, "operation").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "operation",
        value: "duration",
        reference: false,
        dataType: "String"
      }
    })
  );
  await flush();
  expect(field(el, "valueType").value).toBeUndefined();
  expect(field(el, "valueType").options.map((option) => option.value)).toEqual([
    "Duration"
  ]);
  expect(field(el, "value").value).toBeUndefined();
});

it("configures an appointment screen without exposing unrelated operations", async () => {
  const el = mount("Availability", [
    input("valueType", "Instant"),
    input("value", "2026-09-08T09:00:00Z")
  ]);
  el.fixedOperation = "appointments";
  await flush();
  expect(field(el, "operation")).toBeUndefined();
  expect(field(el, "label")).toBeDefined();
  expect(field(el, "required")).toBeDefined();
  expect(field(el, "duration")).toBeDefined();
});
it("configures allocation blocks inline or from Text resources and exposes native holidays", async () => {
  const el = mount("TimeAllocation", [
    input("valueType", "Instant"),
    input("instantValue", "Start", "reference"),
    input("endInstant", "End", "reference"),
    input("timeZoneId", "Europe/London"),
    input("blocksText", "Blocks", "reference")
  ]);
  await flush();
  expect(field(el, "blocksText").literalType).toBe("time-blocks");
  expect(field(el, "blocksText").reference).toBe(true);
  expect(field(el, "holidays").objectType).toBe("Holiday");
  expect(
    field(el, "overlapMode").options.map((option) => option.value)
  ).toEqual(["strict", "lax", "duplicate", "split"]);
  expect(field(el, "value")).toBeUndefined();
  expect(el.validate()).toEqual([]);
});
it("reports missing allocation blocks once with a unique render key", async () => {
  const el = mount("TimeAllocation", [
    input("valueType", "Instant"),
    input("instantValue", "Start", "reference"),
    input("endInstant", "End", "reference"),
    input("timeZoneId", "Europe/London")
  ]);
  await flush();
  const errors = el.validate();
  expect(errors.filter((error) => error.key === "blocksText")).toHaveLength(1);
  expect(new Set(errors.map((error) => error.key)).size).toBe(errors.length);
});
