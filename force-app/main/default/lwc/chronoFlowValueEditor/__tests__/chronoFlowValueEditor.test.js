import { createElement } from "lwc";
import Editor from "c/chronoFlowValueEditor";
jest.mock(
  "@salesforce/apex/ChronoFlowEditorController.getFields",
  () => ({ default: jest.fn().mockResolvedValue([]) }),
  { virtual: true }
);
const flush = async () => {
  for (let i = 0; i < 5; i++) await Promise.resolve();
};
function mount(properties = {}) {
  const el = createElement("c-chrono-flow-value-editor", { is: Editor });
  Object.assign(
    el,
    { name: "initialValue", label: "Initial value" },
    properties
  );
  document.body.appendChild(el);
  return el;
}
function select(el, value) {
  el.shadowRoot
    .querySelector("lightning-button-menu")
    .dispatchEvent(new CustomEvent("select", { detail: { value } }));
}
afterEach(() => {
  document.body.innerHTML = "";
});

it("keeps the mode menu and labelled input together, with optional help", () => {
  const el = mount({
    value: "2026-09-07",
    valueType: "Date",
    helpText: "A local date"
  });
  const row = el.shadowRoot.querySelector(".value-row");
  expect(row.querySelector("lightning-button-menu").iconName).toBe(
    "utility:event"
  );
  expect(row.querySelector("lightning-input").variant).toBe("label-hidden");
  expect(row.querySelector("lightning-input").label).toBe("Initial value");
  expect(row.querySelector("lightning-input").type).toBe("date");
  expect(el.shadowRoot.querySelector("lightning-helptext").content).toBe(
    "A local date"
  );
  const items = [...row.querySelectorAll("lightning-menu-item")];
  expect(items.map((item) => [item.label, item.checked])).toEqual([
    ["Search Resources", false],
    ["Enter Date", true]
  ]);
  expect(el.shadowRoot.querySelector("lightning-combobox")).toBeNull();
});

it("changes modes without clearing an already selected mode", async () => {
  const el = mount({ value: "Keep this" });
  const changed = jest.fn();
  el.addEventListener("valuechange", changed);
  select(el, "literal");
  select(el, "unsupported");
  expect(changed).not.toHaveBeenCalled();
  select(el, "reference");
  expect(changed.mock.calls[0][0].detail).toMatchObject({
    name: "initialValue",
    value: null,
    reference: true
  });
  el.reference = true;
  el.value = "InitialDate";
  await flush();
  expect(el.shadowRoot.querySelector("lightning-button-menu").iconName).toBe(
    "utility:collection"
  );
  select(el, "reference");
  expect(changed).toHaveBeenCalledTimes(1);
  select(el, "literal");
  expect(changed.mock.calls[1][0].detail).toMatchObject({
    value: null,
    reference: false
  });
});

it("preserves resource type filtering and passes the selected native type through", () => {
  const types = [
    { valueType: "Date" },
    { valueType: "DateTime" },
    { valueType: "String" }
  ];
  const context = { variables: [{ name: "InitialDate", dataType: "Date" }] };
  const el = mount({
    reference: true,
    acceptedTypes: types,
    builderContext: context
  });
  const changed = jest.fn();
  el.addEventListener("valuechange", changed);
  const picker = el.shadowRoot.querySelector("c-chrono-flow-resource-picker");
  expect(picker.acceptedTypes).toEqual(types);
  picker.dispatchEvent(
    new CustomEvent("choose", {
      detail: { value: "InitialDate", dataType: "Date" }
    })
  );
  expect(changed.mock.calls[0][0].detail).toMatchObject({
    value: "InitialDate",
    dataType: "Date",
    reference: true
  });
});

it("keeps resource-only fields as a single lookup", () => {
  const el = mount({ referenceOnly: true });
  expect(el.shadowRoot.querySelector("lightning-button-menu")).toBeNull();
  expect(
    el.shadowRoot.querySelector("c-chrono-flow-resource-picker")
  ).not.toBeNull();
});

it("keeps checkbox values boolean with an accessible label", () => {
  const el = mount({ valueType: "Boolean", value: true });
  const changed = jest.fn();
  el.addEventListener("valuechange", changed);
  const input = el.shadowRoot.querySelector("lightning-input");
  expect(input.checked).toBe(true);
  expect(input.label).toBe("Initial value");
  input.checked = false;
  input.dispatchEvent(new CustomEvent("change"));
  expect(changed.mock.calls[0][0].detail).toMatchObject({
    value: false,
    reference: false,
    dataType: "Boolean"
  });
});

it("retains the timezone lookup for fixed selections", () => {
  const options = [{ label: "London", value: "Europe/London" }];
  const el = mount({ searchable: true, options });
  const changed = jest.fn();
  el.addEventListener("valuechange", changed);
  const lookup = el.shadowRoot.querySelector("c-chrono-choice-lookup");
  expect(lookup.options).toEqual(options);
  lookup.dispatchEvent(
    new CustomEvent("choose", { detail: { value: "Europe/London" } })
  );
  expect(changed.mock.calls[0][0].detail).toMatchObject({
    value: "Europe/London",
    reference: false
  });
});
