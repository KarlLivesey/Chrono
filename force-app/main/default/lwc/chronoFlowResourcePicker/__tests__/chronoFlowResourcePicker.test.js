import { createElement } from "lwc";
import Picker from "c/chronoFlowResourcePicker";
import getFields from "@salesforce/apex/ChronoFlowEditorController.getFields";
jest.mock(
  "@salesforce/apex/ChronoFlowEditorController.getFields",
  () => ({ default: jest.fn() }),
  { virtual: true }
);
const flush = async () => {
  for (let i = 0; i < 40; i++) await Promise.resolve();
};
it("accepts a declared union of native and specific Chrono Flow types", async () => {
  getFields.mockResolvedValue([]);
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.acceptedTypes = [
    { valueType: "Date" },
    { valueType: "DateTime" },
    { valueType: "Apex", objectType: "ChronoZonedDateTime" }
  ];
  el.builderContext = {
    variables: [
      { name: "Day", dataType: "Date" },
      { name: "Instant", dataType: "DateTime" },
      {
        name: "Chrono",
        dataType: "Apex",
        apexClass: "skel.ChronoZonedDateTime"
      },
      {
        name: "Wrong",
        dataType: "Apex",
        apexClass: "skel.ChronoWorkingTimeInput"
      },
      { name: "Many", dataType: "Date", isCollection: true }
    ]
  };
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  for (const name of ["Day", "Instant", "Chrono"])
    expect(
      el.shadowRoot.querySelector(`[data-value="${name}"]`)
    ).not.toBeNull();
  for (const name of ["Wrong", "Many"])
    expect(el.shadowRoot.querySelector(`[data-value="${name}"]`)).toBeNull();
});
afterEach(() => {
  document.body.innerHTML = "";
  jest.clearAllMocks();
});
it("searches compatible nested fields directly and never commits typed text", async () => {
  getFields.mockResolvedValue([
    { name: "TimeZoneSidKey", label: "Timezone", dataType: "String" },
    { name: "IsActive", label: "Active", dataType: "Boolean" }
  ]);
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.builderContext = { variables: [{ name: "Count", dataType: "Number" }] };
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  document.body.appendChild(el);
  const input = el.shadowRoot.querySelector("input");
  input.value = "timezone";
  input.dispatchEvent(new Event("input"));
  await flush();
  expect(
    el.shadowRoot.querySelector('[data-value="$User.TimeZoneSidKey"]')
  ).not.toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Count"]')).toBeNull();
  expect(choose).not.toHaveBeenCalled();
  input.value = "Arbitrary.NotAResource";
  input.dispatchEvent(new Event("input"));
  await flush();
  expect(el.shadowRoot.querySelectorAll("[data-option]")).toHaveLength(0);
  input.dispatchEvent(
    new KeyboardEvent("keydown", { key: "Enter", bubbles: true })
  );
  expect(choose).not.toHaveBeenCalled();
});

it("hides output groups with no compatible descendants", async () => {
  getFields.mockResolvedValue([{ name: "Name", dataType: "String" }]);
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.valueType = "DateTime";
  el.automaticOutputVariables = {
    Wrong: [{ apiName: "text", dataType: "String" }],
    Right: [{ apiName: "when", dataType: "DateTime" }],
    Empty: []
  };
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  expect(el.shadowRoot.querySelector('[data-value="Wrong"]')).toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Empty"]')).toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="$User"]')).toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Right"]')).not.toBeNull();
});

it("supports keyboard navigation, internal focus, Escape and clear", async () => {
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.valueType = "String[]";
  el.value = "Zones";
  el.builderContext = {
    variables: [{ name: "Zones", dataType: "String", isCollection: true }]
  };
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  document.body.appendChild(el);
  const input = el.shadowRoot.querySelector("input");
  expect(input.value).toBe("Zones");
  input.focus();
  input.dispatchEvent(
    new KeyboardEvent("keydown", { key: "ArrowDown", bubbles: true })
  );
  await flush();
  input.dispatchEvent(
    new KeyboardEvent("keydown", { key: "ArrowDown", bubbles: true })
  );
  const option = el.shadowRoot.querySelector('[data-value="Zones"]');
  expect(el.shadowRoot.activeElement).toBe(option);
  await new Promise((done) => setTimeout(done, 5));
  expect(el.shadowRoot.querySelector('[role="listbox"]')).not.toBeNull();
  option.dispatchEvent(
    new KeyboardEvent("keydown", { key: "Escape", bubbles: true })
  );
  await flush();
  expect(el.shadowRoot.querySelector('[role="listbox"]')).toBeNull();
  expect(el.shadowRoot.activeElement).toBe(input);
  expect(input.value).toBe("Zones");
  el.shadowRoot.querySelector('[title="Clear resource"]').click();
  expect(choose.mock.calls[0][0].detail.value).toBe("");
});

it("ignores schema results after dismissal", async () => {
  let finish;
  getFields.mockReturnValue(
    new Promise((resolve) => {
      finish = resolve;
    })
  );
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  document.body.appendChild(el);
  const input = el.shadowRoot.querySelector("input");
  input.click();
  await flush();
  input.dispatchEvent(
    new KeyboardEvent("keydown", { key: "Escape", bubbles: true })
  );
  finish([{ name: "Name", label: "Name", dataType: "String" }]);
  await flush();
  expect(el.shadowRoot.querySelector('[role="listbox"]')).toBeNull();
});

it("selects compatible supplied records without requiring schema access", async () => {
  getFields.mockRejectedValue(new Error("No object read permission"));
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.valueType = "SObject";
  el.objectType = "OperatingHours";
  el.builderContext = {
    variables: [
      {
        name: "UnsavedHours",
        dataType: "SObject",
        objectType: "OperatingHours"
      }
    ]
  };
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  el.shadowRoot.querySelector('[data-value="UnsavedHours"]').click();
  expect(choose.mock.calls[0][0].detail.value).toBe("UnsavedHours");
  expect(getFields).not.toHaveBeenCalledWith({
    objectApiName: "OperatingHours"
  });
});

it("refreshes compatible options when the required type changes", async () => {
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.valueType = "String[]";
  el.builderContext = {
    variables: [
      { name: "Zones", dataType: "String", isCollection: true },
      { name: "Dates", dataType: "Date", isCollection: true }
    ]
  };
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  expect(el.shadowRoot.querySelector('[data-value="Zones"]')).not.toBeNull();
  el.valueType = "Date[]";
  await flush();
  expect(el.shadowRoot.querySelector('[role="listbox"]')).toBeNull();
  el.shadowRoot.querySelector("input").click();
  await flush();
  expect(el.shadowRoot.querySelector('[data-value="Zones"]')).toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Dates"]')).not.toBeNull();
});
it("browses a record field and emits the exact Flow reference", async () => {
  getFields.mockResolvedValue([
    { name: "TimeZoneSidKey", label: "Timezone", dataType: "String" },
    { name: "IsActive", label: "Active", dataType: "Boolean" }
  ]);
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  el.valueType = "String";
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  el.shadowRoot.querySelector('button[data-value="$User"]').click();
  await flush();
  expect(getFields).toHaveBeenCalledWith({ objectApiName: "User" });
  expect(
    el.shadowRoot.querySelector('[data-value="$User.IsActive"]')
  ).toBeNull();
  const selected = jest.fn();
  el.addEventListener("choose", selected);
  el.shadowRoot
    .querySelector('button[data-value="$User.TimeZoneSidKey"]')
    .click();
  expect(selected.mock.calls[0][0].detail.value).toBe("$User.TimeZoneSidKey");
  expect(el.value).toBe("");
});
it("filters collections by exact Apex type and preserves an unlisted existing reference", async () => {
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  Object.assign(el, {
    value: "Screen.Output",
    valueType: "Apex[]",
    objectType: "ChronoWorkingTimeInput",
    builderContext: {
      variables: [
        {
          name: "Slots",
          dataType: "Apex",
          apexClass: "skel.ChronoWorkingTimeInput",
          isCollection: true
        },
        {
          name: "Other",
          dataType: "Apex",
          apexClass: "other.ChronoWorkingTimeInput",
          isCollection: true
        },
        {
          name: "Single",
          dataType: "Apex",
          apexClass: "skel.ChronoWorkingTimeInput",
          isCollection: false
        }
      ]
    }
  });
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  expect(el.shadowRoot.querySelector('[data-value="Slots"]')).not.toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Other"]')).toBeNull();
  expect(el.shadowRoot.querySelector('[data-value="Single"]')).toBeNull();
  expect(el.value).toBe("Screen.Output");
  expect(el.shadowRoot.textContent).not.toContain(
    "Enter an unlisted reference"
  );
});
it("supports typed automatic action outputs", async () => {
  const el = createElement("c-chrono-flow-resource-picker", { is: Picker });
  Object.assign(el, {
    valueType: "DateTime",
    automaticOutputVariables: {
      Convert: [
        { apiName: "dateTimeValue", dataType: "DateTime", maxOccurs: 1 },
        { apiName: "values", dataType: "DateTime", maxOccurs: -1 }
      ]
    }
  });
  document.body.appendChild(el);
  el.shadowRoot.querySelector("input").click();
  await flush();
  el.shadowRoot.querySelector('button[data-value="Convert"]').click();
  await flush();
  expect(
    el.shadowRoot.querySelector('[data-value="Convert.dateTimeValue"]')
  ).not.toBeNull();
  expect(
    el.shadowRoot.querySelector('[data-value="Convert.values"]')
  ).toBeNull();
});
