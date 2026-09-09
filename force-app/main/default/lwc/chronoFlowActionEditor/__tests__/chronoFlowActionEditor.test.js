import { createElement } from "lwc";
import Editor from "c/chronoFlowActionEditor";
import ConvertEditor from "c/chronoConvertEditor";
jest.mock(
  "@salesforce/apex/ChronoPickerController.getTimeZones",
  () => ({
    default: jest.fn().mockResolvedValue(["Europe/London", "Asia/Tokyo"])
  }),
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/ChronoFlowEditorController.getFields",
  () => ({ default: jest.fn().mockResolvedValue([]) }),
  { virtual: true }
);
const flush = async () => {
  for (let i = 0; i < 8; i++) await Promise.resolve();
};
const input = (name, value, valueDataType = "String") => ({
  name,
  value,
  valueDataType
});
function mount(kind, inputs, collection = false) {
  const el = createElement("c-chrono-flow-action-editor", { is: Editor });
  el.kind = kind;
  el.collection = collection;
  el.inputVariables = inputs;
  document.body.appendChild(el);
  return el;
}
const field = (el, name) =>
  [...el.shadowRoot.querySelectorAll("c-chrono-flow-value-editor")].find(
    (item) => item.name === name
  );
afterEach(() => {
  document.body.innerHTML = "";
});
it("opens an existing native action with only its selected source representation", async () => {
  const el = mount("Convert", [
    input("valueType", "Instant"),
    input("instantValue", "Picker.dateTimeValue", "reference"),
    input("targetType", "ZonedDateTime"),
    input("timeZoneId", "America/New_York")
  ]);
  await flush();
  expect(field(el, "instantValue").reference).toBe(true);
  expect(field(el, "value")).toBeUndefined();
  expect(field(el, "dateValue")).toBeUndefined();
  expect(field(el, "timeValue")).toBeUndefined();
  expect(el.validate()).toEqual([]);
  const removed = jest.fn();
  el.addEventListener("configuration_editor_input_value_deleted", removed);
  el.shadowRoot
    .querySelector("lightning-combobox")
    .dispatchEvent(new CustomEvent("change", { detail: { value: "iso" } }));
  await flush();
  expect(removed.mock.calls.map((call) => call[0].detail.name)).toEqual([
    "instantValue"
  ]);
  expect(field(el, "value")).toBeDefined();
  expect(el.validate().some((item) => item.key === "value")).toBe(true);
});
it("does not lose the source selector after Flow echoes a cleared binding", async () => {
  const el = mount("Convert", [
    input("valueType", "PlainDate"),
    input("value", "2026-09-07")
  ]);
  await flush();
  let control = field(el, "value");
  control.shadowRoot
    .querySelector("lightning-button-menu")
    .dispatchEvent(
      new CustomEvent("select", { detail: { value: "reference" } })
    );
  el.inputVariables = [input("valueType", "PlainDate")];
  await flush();
  control = field(el, "value");
  const picker = control.shadowRoot.querySelector(
    "c-chrono-flow-resource-picker"
  );
  expect(picker).not.toBeNull();
  const changed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  picker.dispatchEvent(
    new CustomEvent("choose", {
      detail: { value: "DateText", dataType: "String" }
    })
  );
  await flush();
  expect(changed.mock.calls[0][0].detail).toEqual({
    name: "value",
    newValue: "DateText",
    newValueDataType: "reference"
  });
  el.inputVariables = [
    input("valueType", "PlainDate"),
    input("value", "DateText", "reference")
  ];
  await flush();
  expect(field(el, "value").value).toBe("DateText");
});
it("preserves typed native Date and local time inputs", async () => {
  const el = mount("Convert", [
    input("valueType", "PlainDateTime"),
    input("dateValue", "ChosenDate", "reference"),
    input("timeValue", "09:30")
  ]);
  await flush();
  expect(field(el, "dateValue").valueType).toBe("Date");
  expect(field(el, "timeValue").literalType).toBe("time");
  expect(el.validate()).toEqual([]);
});
it("filters units and clears the other arithmetic representation", async () => {
  const el = mount("Adjust", [
    input("valueType", "PlainDate"),
    input("value", "2026-09-07"),
    input("amount", 1, "Number"),
    input("unit", "days")
  ]);
  await flush();
  expect(field(el, "unit").options.map((item) => item.value)).toEqual([
    "years",
    "months",
    "weeks",
    "days"
  ]);
  const mode = [...el.shadowRoot.querySelectorAll("lightning-combobox")].find(
    (item) => item.label === "Add or subtract using"
  );
  mode.dispatchEvent(
    new CustomEvent("change", { detail: { value: "duration" } })
  );
  await flush();
  expect(field(el, "amount")).toBeUndefined();
  expect(field(el, "unit")).toBeUndefined();
  expect(field(el, "duration")).toBeDefined();
});
it("validates working-time required fields and numeric zero", async () => {
  const el = mount("WorkingTime", [
    input("startValue", "2026-09-07T09:00Z"),
    input("timeZoneId", "Europe/London"),
    input("amount", 0, "Number"),
    input("unit", "hours"),
    input("scheduleType", "OperatingHours"),
    input("scheduleId", "Hours.Id", "reference")
  ]);
  await flush();
  expect(el.validate()).toEqual([]);
});
it("filters collection inputs to the exact request type", () => {
  const el = mount("Difference", [input("items", "Pairs", "reference")], true);
  const picker = el.shadowRoot.querySelector("c-chrono-flow-resource-picker");
  expect(picker.valueType).toBe("Apex[]");
  expect(picker.objectType).toBe("ChronoDifferenceInput");
  expect(el.validate()).toEqual([]);
});
it("registers a wrapper that forwards Flow events and validation", async () => {
  const el = createElement("c-chrono-convert-editor", { is: ConvertEditor });
  el.inputVariables = [];
  const changed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  document.body.appendChild(el);
  await flush();
  expect(el.validate().length).toBeGreaterThan(0);
  const shared = el.shadowRoot.querySelector("c-chrono-flow-action-editor");
  field(shared, "valueType").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "valueType",
        value: "PlainDate",
        dataType: "String",
        reference: false
      }
    })
  );
  expect(changed.mock.calls[0][0].detail.newValue).toBe("PlainDate");
});

it("keeps native input format while switching a populated resource to a literal", async () => {
  const el = mount("Convert", [
    input("valueType", "Instant"),
    input("instantValue", "InitialValue", "reference")
  ]);
  await flush();
  const control = field(el, "instantValue");
  control.shadowRoot
    .querySelector("lightning-button-menu")
    .dispatchEvent(new CustomEvent("select", { detail: { value: "literal" } }));
  el.inputVariables = [input("valueType", "Instant")];
  await flush();
  expect(field(el, "instantValue")).toBeDefined();
  expect(field(el, "value")).toBeUndefined();
  expect(
    field(el, "instantValue").shadowRoot.querySelector("lightning-input").type
  ).toBe("datetime");
});
it("offers native Date at both calendar difference endpoints and keeps the remainder explanation", async () => {
  const el = mount("CalendarDifference", [
    input("valueType", "PlainDate"),
    input("dateValue", "StartDate", "reference"),
    input("endDate", "EndDate", "reference")
  ]);
  await flush();
  expect(field(el, "dateValue").valueType).toBe("Date");
  expect(field(el, "endDate").valueType).toBe("Date");
  expect(field(el, "endValue")).toBeUndefined();
  expect(field(el, "largestUnit").helpText).toContain(
    "remainder can be ignored"
  );
  expect(el.validate()).toEqual([]);
});
it("clears only the second native representation when its format changes", async () => {
  const el = mount("Compare", [
    input("valueType", "PlainDate"),
    input("dateValue", "StartDate", "reference"),
    input("endDate", "EndDate", "reference")
  ]);
  await flush();
  el.shadowRoot
    .querySelectorAll("lightning-combobox")[1]
    .dispatchEvent(new CustomEvent("change", { detail: { value: "iso" } }));
  await flush();
  expect(field(el, "endDate")).toBeUndefined();
  expect(field(el, "endValue")).toBeDefined();
  expect(field(el, "dateValue").value).toBe("StartDate");
});
it("limits local resolution and period operations to meaningful source types", async () => {
  for (const kind of [
    "ResolveLocal",
    "PeriodBoundary",
    "CheckWorkingTime",
    "FindWorkingTime"
  ]) {
    const el = mount(kind, [input("valueType", "PlainDate")]);
    await flush();
    expect(
      field(el, "valueType").options.some((item) => item.value === "Duration")
    ).toBe(false);
    if (kind === "ResolveLocal")
      expect(field(el, "resolution").options.map((item) => item.value)).toEqual(
        ["inspect", "earlier", "later", "backward", "forward"]
      );
    el.remove();
  }
});
it("validates rounding increments and shows only day rounding for a date", async () => {
  const el = mount("Round", [
    input("valueType", "PlainDate"),
    input("value", "2026-09-07"),
    input("unit", "day"),
    input("increment", 0, "Number")
  ]);
  await flush();
  expect(field(el, "unit").options.map((item) => item.value)).toEqual(["day"]);
  expect(el.validate().some((error) => error.key === "increment")).toBe(true);
});
it.each([
  "CheckWorkingTime",
  "FindWorkingTime",
  "Compare",
  "PeriodBoundary",
  "Round",
  "ResolveLocal",
  "CalendarDifference"
])("filters the %s collection by its exact request type", async (kind) => {
  const el = mount(kind, [], true);
  await flush();
  const picker = el.shadowRoot.querySelector("c-chrono-flow-resource-picker");
  expect(picker.objectType).toBe(`Chrono${kind}Input`);
  expect(picker.valueType).toBe("Apex[]");
});
it("offers native dates and optional clocks for both difference endpoints", async () => {
  const el = mount("Difference", [
    input("startDate", "StartDate", "reference"),
    input("endDate", "EndDate", "reference"),
    input("startTime", "09:00"),
    input("timeZoneId", "Europe/London"),
    input("endTimeZoneId", "America/New_York")
  ]);
  await flush();
  expect(field(el, "startDate").valueType).toBe("Date");
  expect(field(el, "endDate").valueType).toBe("Date");
  expect(field(el, "startTime").literalType).toBe("time");
  expect(field(el, "startValue")).toBeUndefined();
  expect(field(el, "endDisambiguation")).toBeDefined();
  expect(el.validate()).toEqual([]);
  const removed = jest.fn();
  el.addEventListener("configuration_editor_input_value_deleted", removed);
  el.shadowRoot
    .querySelector('[data-prefix="start"]')
    .dispatchEvent(
      new CustomEvent("change", { detail: { value: "datetime" } })
    );
  await flush();
  expect(removed.mock.calls.map(([event]) => event.detail.name)).toEqual([
    "startDate",
    "startTime"
  ]);
  expect(field(el, "startInstant")).toBeDefined();
  expect(field(el, "endDate").value).toBe("EndDate");
});
it.each(["WorkingTime", "Difference", "CheckWorkingTime", "FindWorkingTime"])(
  "%s uses compatible native record selectors and clears conflicting schedule sources",
  async (kind) => {
    const idName = kind === "WorkingTime" ? "scheduleId" : "operatingHoursId";
    const el = mount(kind, [
      input("scheduleType", "OperatingHours"),
      input(idName, "SavedHours.Id", "reference")
    ]);
    await flush();
    const selector = [
      ...el.shadowRoot.querySelectorAll("lightning-combobox")
    ].find((item) => item.label === "Working hours");
    const removed = jest.fn();
    el.addEventListener("configuration_editor_input_value_deleted", removed);
    selector.dispatchEvent(
      new CustomEvent("change", { detail: { value: "records" } })
    );
    await flush();
    expect(field(el, idName)).toBeUndefined();
    expect(removed.mock.calls[0][0].detail.name).toBe(idName);
    expect(field(el, "operatingHours").objectType).toBe("OperatingHours");
    expect(field(el, "timeSlots").valueType).toBe("SObject[]");
    expect(field(el, "timeSlots").objectType).toBe("TimeSlot");
    expect(field(el, "holidays").objectType).toBe("Holiday");
    expect(field(el, "operatingHours").referenceOnly).toBe(true);
    expect(el.validate().some((item) => item.key === "operatingHours")).toBe(
      true
    );
    field(el, "operatingHours").dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          name: "operatingHours",
          value: "HoursRecord",
          reference: true,
          dataType: "SObject"
        }
      })
    );
    await flush();
    // Flow echoes the persisted binding when reopening the editor.
    el.inputVariables = [...el.inputVariables];
    await flush();
    expect(field(el, "operatingHours").value).toBe("HoursRecord");
    selector.dispatchEvent(
      new CustomEvent("change", { detail: { value: "saved" } })
    );
    await flush();
    expect(field(el, "operatingHours")).toBeUndefined();
    expect(field(el, idName)).toBeDefined();
  }
);
it("removes native OperatingHours bindings when switching to BusinessHours", async () => {
  const el = mount("WorkingTime", [
    input("scheduleType", "OperatingHours"),
    input("operatingHours", "Hours", "reference"),
    input("timeSlots", "Slots", "reference")
  ]);
  await flush();
  field(el, "scheduleType").dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "scheduleType",
        value: "BusinessHours",
        reference: false,
        dataType: "String"
      }
    })
  );
  await flush();
  expect(
    el.inputVariables.some((item) =>
      ["operatingHours", "timeSlots"].includes(item.name)
    )
  ).toBe(false);
  expect(field(el, "scheduleId")).toBeDefined();
  const selector = [
    ...el.shadowRoot.querySelectorAll("lightning-combobox")
  ].find((item) => item.label === "Working hours");
  expect(selector.options.map((item) => item.value)).toEqual(["saved"]);
});
it("requires an explicit zone for local difference inputs while allowing an independent end zone", async () => {
  const el = mount("Difference", [
    input("startValue", "2026-09-07"),
    input("endValue", "2026-09-08")
  ]);
  await flush();
  expect(el.validate().some((item) => item.key === "timeZoneId")).toBe(true);
  el.inputVariables = [
    input("startInstant", "2026-09-07T08:00:00Z", "DateTime"),
    input("endDate", "2026-09-08", "Date"),
    input("endTimeZoneId", "Europe/London")
  ];
  await flush();
  expect(el.validate()).toEqual([]);
});
