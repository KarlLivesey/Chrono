import { createElement } from "lwc";
import Editor from "c/chronoFlowDateTimeEditor";
import zones from "@salesforce/apex/ChronoPickerController.getTimeZones";
jest.mock(
  "@salesforce/apex/ChronoPickerController.getTimeZones",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
beforeEach(() => {
  zones.mockResolvedValue(["Europe/London", "Asia/Tokyo"]);
});
const flush = async () => {
  for (let i = 0; i < 5; i++) await Promise.resolve();
};
afterEach(() => {
  document.body.innerHTML = "";
});

it("uses one initial-value field and routes each resource to its typed input", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "dateValue", value: "InitialDate", valueDataType: "reference" }
  ];
  const changed = jest.fn();
  const removed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  el.addEventListener("configuration_editor_input_value_deleted", removed);
  document.body.appendChild(el);
  const fields = [
    ...el.shadowRoot.querySelectorAll("c-chrono-flow-value-editor")
  ];
  const initial = fields.filter((field) => field.label === "Initial value");
  expect(initial).toHaveLength(1);
  expect(initial[0].value).toBe("InitialDate");
  expect(fields.some((field) => field.label === "Initial date/time")).toBe(
    false
  );
  initial[0].dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        value: "ChronoResult",
        reference: true,
        dataType: "String"
      }
    })
  );
  await flush();
  expect(removed.mock.calls[0][0].detail.name).toBe("dateValue");
  expect(changed.mock.calls[0][0].detail).toEqual({
    name: "initialChronoValue",
    newValue: "ChronoResult",
    newValueDataType: "reference"
  });
});

it("uses a supported-timezone lookup restricted to the fixed allowed list", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "allowTimeZoneSelection", value: true, valueDataType: "Boolean" },
    { name: "timeZoneSelectionMode", value: "list", valueDataType: "String" },
    { name: "timeZoneIdsText", value: "Europe/London", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  await flush();
  const field = [
    ...el.shadowRoot.querySelectorAll("c-chrono-flow-value-editor")
  ].find((item) => item.name === "timeZoneId");
  expect(field.searchable).toBe(true);
  expect(field.options).toEqual([
    { value: "Europe/London", label: "Europe/London" }
  ]);
});
it("edits an allowed timezone list and restores it without rewriting configuration", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "allowTimeZoneSelection", value: true, valueDataType: "Boolean" },
    { name: "timeZoneSelectionMode", value: "list", valueDataType: "String" },
    { name: "timeZoneIdsText", value: "Europe/London", valueDataType: "String" }
  ];
  const changed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  document.body.appendChild(el);
  await flush();
  expect(changed).not.toHaveBeenCalled();
  const list = el.shadowRoot.querySelector("c-chrono-flow-list-editor");
  expect(list.items).toEqual([
    { value: "Europe/London", label: "Europe/London" }
  ]);
  list.dispatchEvent(
    new CustomEvent("add", { detail: { value: "Asia/Tokyo" } })
  );
  await flush();
  expect(changed.mock.calls[0][0].detail).toEqual({
    name: "timeZoneIdsText",
    newValue: "Europe/London\nAsia/Tokyo",
    newValueDataType: "String"
  });
  list.dispatchEvent(
    new CustomEvent("remove", { detail: { value: "Europe/London" } })
  );
  await flush();
  expect(list.items).toEqual([{ value: "Asia/Tokyo", label: "Asia/Tokyo" }]);
});

it("requires a populated allowed list and rejects a default outside it", () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "allowTimeZoneSelection", value: true, valueDataType: "Boolean" },
    { name: "timeZoneSelectionMode", value: "list", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  expect(el.validate().length).toBeGreaterThan(0);
  el.inputVariables = [
    ...el.inputVariables,
    {
      name: "timeZoneIdsText",
      value: "Europe/London",
      valueDataType: "String"
    },
    { name: "timeZoneId", value: "Asia/Tokyo", valueDataType: "String" }
  ];
  expect(el.validate().map((error) => error.key)).toContain("timeZoneId");
});
it("validates independently locked hours and fixed offset configuration", () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "all", valueDataType: "String" },
    {
      name: "lockOperatingHoursSelection",
      value: true,
      valueDataType: "Boolean"
    },
    { name: "offsetOverride", value: "+25:00", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  expect(el.validate().map((item) => item.key)).toEqual(
    expect.arrayContaining([
      "operatingHoursId",
      "offsetOverride",
      "allowOffsetOverride"
    ])
  );
});
it("binds a Flow record collection using the reference event contract", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "records", valueDataType: "String" }
  ];
  el.builderContext = {
    variables: [
      {
        name: "Hours",
        dataType: "SObject",
        objectType: "OperatingHours",
        isCollection: true
      }
    ]
  };
  document.body.appendChild(el);
  const field = [
    ...el.shadowRoot.querySelectorAll("c-chrono-flow-value-editor")
  ].find((x) => x.name === "operatingHoursRecords");
  expect(field.builderContext.variables[0].name).toBe("Hours");
  expect(field.objectType).toBe("OperatingHours");
  const event = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", event);
  field.dispatchEvent(
    new CustomEvent("valuechange", {
      detail: {
        name: "operatingHoursRecords",
        value: "Hours",
        reference: true,
        dataType: "SObject[]"
      }
    })
  );
  await flush();
  expect(event.mock.calls[0][0].detail).toEqual({
    name: "operatingHoursRecords",
    newValue: "Hours",
    newValueDataType: "reference"
  });
  expect(el.validate()).toEqual([]);
});
it("configures fixed weekly slots without requiring a saved record", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "fixed", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  expect(el.validate().length).toBeGreaterThan(0);
  const listener = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", listener);
  [...el.shadowRoot.querySelectorAll("lightning-button")]
    .find((x) => x.label === "Use Mon–Fri, 09:00–17:00")
    .click();
  await flush();
  const data = JSON.parse(listener.mock.calls[0][0].detail.newValue);
  expect(data.slots).toHaveLength(5);
  expect(el.validate()).toEqual([]);
});
it("fixed partial holidays use clock inputs and convert midnight to end of day", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "fixed", valueDataType: "String" },
    {
      name: "fixedHours",
      value: JSON.stringify({
        definition: { name: "Support", timeZoneId: "UTC" },
        slots: [{ dayOfWeek: "Monday", startTime: "09:00", endTime: "17:00" }],
        holidays: [
          {
            dateValue: "2026-09-07",
            allDay: false,
            startTimeInMinutes: 720,
            endTimeInMinutes: 780
          }
        ]
      }),
      valueDataType: "String"
    }
  ];
  document.body.appendChild(el);
  await flush();
  const end = el.shadowRoot.querySelector('[data-field="endTimeInMinutes"]');
  expect(end.type).toBe("time");
  expect(end.value).toBe("13:00");
  const listener = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", listener);
  end.dispatchEvent(new CustomEvent("change", { detail: { value: "00:00" } }));
  await flush();
  expect(
    JSON.parse(listener.mock.calls[0][0].detail.newValue).holidays[0]
      .endTimeInMinutes
  ).toBe(1440);
});

it("uses a supported timezone lookup independent of the picker zone", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "fixed", valueDataType: "String" },
    { name: "timeZoneId", value: "Europe/London", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  await flush();
  const lookup = el.shadowRoot.querySelector(
    ".schedule-zone c-chrono-choice-lookup"
  );
  expect(lookup.options.map((item) => item.value)).toEqual([
    "Europe/London",
    "Asia/Tokyo"
  ]);
  const changed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  lookup.dispatchEvent(
    new CustomEvent("choose", { detail: { value: "Asia/Tokyo" } })
  );
  const detail = changed.mock.calls[0][0].detail;
  expect(detail.name).toBe("fixedHours");
  expect(JSON.parse(detail.newValue).definition.timeZoneId).toBe("Asia/Tokyo");
  expect(changed).toHaveBeenCalledTimes(1);
  lookup.dispatchEvent(new CustomEvent("choose", { detail: { value: "" } }));
  expect(el.validate().some((error) => error.key === "fixedHours")).toBe(true);
});

it("adds and removes weekly and holiday rows using compact controls", async () => {
  const el = createElement("c-chrono-flow-date-time-editor", { is: Editor });
  el.inputVariables = [
    { name: "operatingHoursMode", value: "fixed", valueDataType: "String" }
  ];
  document.body.appendChild(el);
  const changed = jest.fn();
  el.addEventListener("configuration_editor_input_value_changed", changed);
  for (const label of ["Add hours", "Add holiday"]) {
    const button = [...el.shadowRoot.querySelectorAll("lightning-button")].find(
      (item) => item.label === label
    );
    expect(button.variant).toBe("base");
    button.click();
  }
  await flush();
  expect(el.shadowRoot.querySelectorAll(".schedule-row")).toHaveLength(2);
  const remove = [
    ...el.shadowRoot.querySelectorAll(".schedule-row lightning-button-icon")
  ];
  expect(remove[0].alternativeText).toContain("Monday");
  remove[0].click();
  await flush();
  remove[1].click();
  await flush();
  const saved = JSON.parse(changed.mock.calls.at(-1)[0].detail.newValue);
  expect(saved.slots).toEqual([]);
  expect(saved.holidays).toEqual([]);
});
