// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
export const choices = (pairs) =>
  pairs.map(([value, label]) => ({ value, label }));
export function hoursSetup(mode, reference) {
  const policy =
    mode === "none"
      ? "none"
      : mode === "all"
        ? "all"
        : ["ids", "records", "filter"].includes(mode)
          ? "list"
          : "fixed";
  const source =
    mode === "fixed"
      ? "entered"
      : mode === "filter"
        ? "filter"
        : ["record", "records", "supplied"].includes(mode) ||
            (mode === "id" && reference("operatingHoursId")) ||
            (mode === "ids" && reference("operatingHoursIds"))
          ? "flow"
          : "here";
  const data = ["record", "records"].includes(mode)
    ? "records"
    : mode === "supplied"
      ? "supplied"
      : "ids";
  return { policy, source, data };
}
export function hoursModeFor({ policy, source, data }) {
  if (["none", "all"].includes(policy)) return policy;
  if (source === "entered") return "fixed";
  if (source === "filter") return "filter";
  if (source === "here") return policy === "fixed" ? "id" : "ids";
  if (data === "records") return policy === "fixed" ? "record" : "records";
  if (data === "ids") return policy === "fixed" ? "id" : "ids";
  return data;
}
