import { createElement } from "lwc";
import Lookup from "c/chronoChoiceLookup";
afterEach(() => {
  document.body.innerHTML = "";
});
it("searches supplied choices, emits only a chosen value and can clear it", async () => {
  const el = createElement("c-chrono-choice-lookup", { is: Lookup });
  el.options = ["Europe/London", "Asia/Tokyo"].map((value) => ({
    value,
    label: value
  }));
  el.value = "Europe/London";
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  document.body.appendChild(el);
  const input = el.shadowRoot.querySelector("input");
  input.value = "tok";
  input.dispatchEvent(new Event("input"));
  await Promise.resolve();
  expect(choose).not.toHaveBeenCalled();
  expect(
    el.shadowRoot.querySelector('[data-value="Europe/London"]')
  ).toBeNull();
  el.shadowRoot.querySelector('[data-value="Asia/Tokyo"]').click();
  expect(choose.mock.calls[0][0].detail.value).toBe("Asia/Tokyo");
  el.shadowRoot.querySelector('[title="Clear selection"]').click();
  expect(choose.mock.calls[1][0].detail.value).toBe("");
});
const flush = async () => {
  for (let index = 0; index < 5; index++) await Promise.resolve();
};
async function mount(options = ["London", "Tokyo", "Sydney"]) {
  const el = createElement("c-chrono-choice-lookup", { is: Lookup });
  el.options = options.map((value) => ({ value, label: value }));
  document.body.appendChild(el);
  await flush();
  return el;
}
async function key(target, keyValue) {
  const event = new KeyboardEvent("keydown", {
    key: keyValue,
    bubbles: true,
    cancelable: true
  });
  target.dispatchEvent(event);
  await flush();
  return event;
}
it("cycles both ways with arrows and commits the focused choice with Enter", async () => {
  const el = await mount();
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  const input = el.shadowRoot.querySelector("input");
  input.focus();
  await key(input, "ArrowUp");
  const options = [...el.shadowRoot.querySelectorAll('[role="option"]')];
  expect(el.shadowRoot.activeElement).toBe(options[2]);
  await key(options[2], "ArrowDown");
  expect(el.shadowRoot.activeElement).toBe(options[0]);
  await key(options[0], "ArrowUp");
  expect(el.shadowRoot.activeElement).toBe(options[2]);
  const event = await key(options[2], "Enter");
  expect(event.defaultPrevented).toBe(true);
  expect(choose).toHaveBeenCalledTimes(1);
  expect(choose.mock.calls[0][0].detail.value).toBe("Sydney");
  expect(input.getAttribute("aria-expanded")).toBe("false");
  expect(el.shadowRoot.activeElement).toBe(input);
});
it("Escape closes without changing the value and returns focus to the input", async () => {
  const el = await mount();
  el.value = "London";
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  const input = el.shadowRoot.querySelector("input");
  input.focus();
  await key(input, "ArrowDown");
  await key(el.shadowRoot.activeElement, "Escape");
  expect(choose).not.toHaveBeenCalled();
  expect(el.shadowRoot.activeElement).toBe(input);
  expect(input.value).toBe("London");
  expect(el.shadowRoot.querySelector('[role="listbox"]')).toBeNull();
});
it("keeps internal focus open and allows Tab to leave without committing", async () => {
  jest.useFakeTimers();
  try {
    const el = await mount();
    const choose = jest.fn();
    el.addEventListener("choose", choose);
    const next = document.createElement("button");
    document.body.appendChild(next);
    const input = el.shadowRoot.querySelector("input");
    input.focus();
    await key(input, "ArrowDown");
    jest.runOnlyPendingTimers();
    await flush();
    expect(input.getAttribute("aria-expanded")).toBe("true");
    const event = await key(el.shadowRoot.activeElement, "Tab");
    expect(event.defaultPrevented).toBe(false);
    // jsdom does not implement the browser's default Tab navigation.
    next.focus();
    jest.runOnlyPendingTimers();
    await flush();
    expect(document.activeElement).toBe(next);
    expect(input.getAttribute("aria-expanded")).toBe("false");
    expect(choose).not.toHaveBeenCalled();
  } finally {
    jest.useRealTimers();
  }
});
it("does not commit free text or fail when arrows have no matching choices", async () => {
  const el = await mount([]);
  const choose = jest.fn();
  el.addEventListener("choose", choose);
  const input = el.shadowRoot.querySelector("input");
  input.focus();
  input.value = "unknown";
  input.dispatchEvent(new Event("input"));
  await key(input, "ArrowDown");
  await key(input, "ArrowUp");
  await key(input, "Enter");
  expect(choose).not.toHaveBeenCalled();
  expect(el.shadowRoot.activeElement).toBe(input);
  expect(el.shadowRoot.querySelector('[role="status"]').textContent).toContain(
    "No matching choices"
  );
});
