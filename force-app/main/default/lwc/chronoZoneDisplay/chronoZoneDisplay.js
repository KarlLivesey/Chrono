// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import locale from "@salesforce/i18n/locale";
import userTimeZone from "@salesforce/i18n/timeZone";
import { exactMillis } from "c/chronoInputValues";
/** Formats one exact instant in each requested zone, with offsets calculated for that instant. */
export default class ChronoZoneDisplay extends LightningElement {
  @api label = "Across timezones";
  @api value;
  @api dateTimeValue;
  @api timeZoneIds;
  @api timeZoneIdsText;
  @api dateStyle = "short";
  get rows() {
    const zones = [
      ...new Set(
        [
          ...(this.timeZoneIds || []),
          ...(this.timeZoneIdsText || "").split(/[\s,;]+/)
        ].filter(Boolean)
      )
    ];
    if (!zones.length) zones.push(userTimeZone);
    if (zones.length > 50)
      return [{ key: "error", error: "Display at most 50 timezones." }];
    try {
      if (this.value && this.dateTimeValue)
        throw new Error("Supply one ISO value or one native datetime.");
      if (!this.value && !this.dateTimeValue) return [];
      const instant = new Date(exactMillis(this.value || this.dateTimeValue));
      return zones.map((zone) => {
        try {
          const language = locale.replace(/_/g, "-");
          const options = { timeZone: zone };
          const datetime = new Intl.DateTimeFormat(language, {
            ...options,
            dateStyle: this.dateStyle,
            timeStyle: "short"
          }).format(instant);
          const abbreviation = new Intl.DateTimeFormat(language, {
            ...options,
            timeZoneName: "short"
          })
            .formatToParts(instant)
            .find((part) => part.type === "timeZoneName")?.value;
          const offset = new Intl.DateTimeFormat("en", {
            ...options,
            timeZoneName: "longOffset"
          })
            .formatToParts(instant)
            .find((part) => part.type === "timeZoneName")
            ?.value.replace("GMT", "UTC");
          return {
            key: zone,
            zone,
            datetime,
            offset: `${abbreviation} · ${offset}`
          };
        } catch {
          return { key: zone, zone, error: `Unsupported timezone: ${zone}` };
        }
      });
    } catch (error) {
      return [{ key: "error", error: error.message }];
    }
  }
}
