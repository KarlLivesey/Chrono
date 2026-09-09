import {
  durationParts,
  durationText,
  partialText,
  exactMillis
} from "c/chronoInputValues";
it("keeps calendar units separate and truncates fractional seconds", () => {
  const value = durationParts("-P1Y2M3W4DT5H6M7.987654321S");
  expect(value).toEqual({
    negative: true,
    months: 14,
    days: 25,
    hours: 5,
    minutes: 6,
    seconds: 7.987
  });
  expect(durationText(value)).toBe("-P14M25DT18367.987S");
  expect(durationText({ ...value, seconds: 7.99999999 })).toBe(
    "-P14M25DT18367.999S"
  );
});
it("rejects unsupported or unsafe duration data", () => {
  for (const value of ["P", "PT", "P1DT", "-P1M-1D", "nope"])
    expect(() => durationParts(value)).toThrow();
  expect(() => durationText({ ...durationParts("PT0S"), days: -1 })).toThrow();
  expect(() => durationParts("PT999999999999999999H")).toThrow();
  expect(durationText(durationParts("-PT0.0009S"))).toBe("PT0S");
});
it("validates partial dates without inventing a real missing year", () => {
  expect(partialText("monthday", null, 2, 29)).toBe("--02-29");
  expect(partialText("yearmonth", 2026, 2, null)).toBe("2026-02");
  expect(() => partialText("monthday", null, 4, 31)).toThrow();
  expect(() => partialText("yearmonth", 0, 2, null)).toThrow();
});
it("requires exact values and distinguishes repeated wall times", () => {
  expect(
    exactMillis("2026-10-25T01:30:00+00:00[Europe/London]") -
      exactMillis("2026-10-25T01:30:00+01:00[Europe/London]")
  ).toBe(3600000);
  expect(() => exactMillis("2026-10-25T01:30")).toThrow();
});

test("exact datetime validation rejects normalised dates and preserves truncated precision", () => {
  for (const value of [
    "2026-02-30T10:00:00Z",
    "2026-04-31T10:00:00Z",
    "0000-01-01T10:00:00Z",
    "2026-01-01T24:00:00Z",
    "2026-01-01T00:00:00+24:00",
    "0001-01-01T00:00:00+01:00"
  ])
    expect(() => exactMillis(value)).toThrow();
  expect(exactMillis("2024-02-29T12:30:01.123456789Z")).toBe(
    Date.parse("2024-02-29T12:30:01.123Z")
  );
  expect(exactMillis("2026-09-08T10:15+05:45")).toBe(
    Date.parse("2026-09-08T04:30:00Z")
  );
});
