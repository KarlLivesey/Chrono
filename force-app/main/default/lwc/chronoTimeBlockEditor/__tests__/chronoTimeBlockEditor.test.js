import { createElement } from "lwc";
import Editor from "c/chronoTimeBlockEditor";
const flush = async () => {
  for (let i = 0; i < 5; i++) await Promise.resolve();
};
function mount(value) {
  const el = createElement("c-chrono-time-block-editor", { is: Editor });
  el.value = value;
  document.body.appendChild(el);
  return el;
}
afterEach(() => {
  document.body.innerHTML = "";
});
it("adds independent blocks and changes their priority without changing their keys", async () => {
  const el = mount();
  const changed = jest.fn();
  el.addEventListener("change", changed);
  el.shadowRoot.querySelector("lightning-button").click();
  await flush();
  el.shadowRoot.querySelector("lightning-button").click();
  await flush();
  let values = JSON.parse(changed.mock.calls.at(-1)[0].detail.value);
  expect(values.map((v) => v.key)).toEqual(["block_1", "block_2"]);
  expect(values[0].uid).toBeUndefined();
  el.shadowRoot
    .querySelector('lightning-button-icon[data-index="1"][data-step="-1"]')
    .click();
  await flush();
  values = JSON.parse(changed.mock.calls.at(-1)[0].detail.value);
  expect(values.map((v) => v.key)).toEqual(["block_2", "block_1"]);
  expect(el.validate()).toBe("");
});
it("edits holiday rules, weekdays and the exclusive end of day", async () => {
  const el = mount(
    JSON.stringify([
      {
        key: "holiday",
        label: "Holiday",
        weekdays: "1,2,3,4,5",
        startTime: "08:00",
        endTime: "12:00"
      }
    ])
  );
  const changed = jest.fn();
  el.addEventListener("change", changed);
  await flush();
  el.shadowRoot
    .querySelector("lightning-combobox")
    .dispatchEvent(new CustomEvent("change", { detail: { value: "holiday" } }));
  await flush();
  el.shadowRoot
    .querySelector('lightning-button-stateful[data-day="6"]')
    .click();
  await flush();
  const midnight = [...el.shadowRoot.querySelectorAll("lightning-input")].find(
    (input) => input.type === "checkbox"
  );
  midnight.checked = true;
  midnight.dispatchEvent(new CustomEvent("change"));
  await flush();
  const value = JSON.parse(changed.mock.calls.at(-1)[0].detail.value)[0];
  expect(value.dayType).toBe("holiday");
  expect(value.weekdays).toBe("1,2,3,4,5,6");
  expect(value.endTime).toBe("24:00");
  expect(el.validate()).toBe("");
});
it("preserves malformed definitions rather than overwriting them", async () => {
  const el = mount("bad json");
  const changed = jest.fn();
  el.addEventListener("change", changed);
  await flush();
  expect(el.validate()).toContain("cannot be read");
  expect(el.value).toBe("bad json");
  expect(el.shadowRoot.querySelector("lightning-button").disabled).toBe(true);
  expect(changed).not.toHaveBeenCalled();
});
it("requires blocks and unique keys and retains the last selected weekday", async () => {
  const el = mount("[]");
  expect(el.validate()).toContain("at least one");
  el.value = JSON.stringify([
    { key: "one", weekdays: "1", startTime: "08:00", endTime: "12:00" },
    { key: "one", weekdays: "1", startTime: "08:00", endTime: "12:00" }
  ]);
  await flush();
  expect(el.validate()).toContain("unique");
  const changed = jest.fn();
  el.addEventListener("change", changed);
  el.shadowRoot
    .querySelector('lightning-button-stateful[data-index="0"][data-day="1"]')
    .click();
  await flush();
  expect(
    JSON.parse(changed.mock.calls.at(-1)[0].detail.value)[0].weekdays
  ).toBe("1");
});
it("reports malformed saved field types without breaking the editor", async () => {
  const el = mount(
    '[{"key":42,"weekdays":5,"startTime":"08:00","endTime":12}]'
  );
  await flush();
  expect(el.validate()).toContain("cannot be read");
  expect(el.shadowRoot.querySelector('[role="alert"]')).not.toBeNull();
});
