import { hoursSetup, hoursModeFor } from "../editorState";

it.each([
  "none",
  "all",
  "id",
  "ids",
  "record",
  "records",
  "supplied",
  "fixed",
  "filter"
])("preserves the saved %s schedule mode", (mode) => {
  expect(hoursModeFor(hoursSetup(mode, () => false))).toBe(mode);
  expect(hoursModeFor(hoursSetup(mode, () => true))).toBe(mode);
});

it("distinguishes individual and collection Flow inputs", () => {
  expect(hoursSetup("id", () => true)).toEqual({
    policy: "fixed",
    source: "flow",
    data: "ids"
  });
  expect(hoursSetup("records", () => false)).toEqual({
    policy: "list",
    source: "flow",
    data: "records"
  });
});
