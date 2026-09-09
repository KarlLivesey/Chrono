// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Regenerate numeric/date component order from Node ICU for Salesforce locale IDs.
// Runtime month/day names remain Salesforce context-user localisation.
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
const root = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "../.."
);
const locales = JSON.parse(
  fs.readFileSync(path.join(root, "scripts/actions/salesforce-locales.json"))
);
const styles = ["short", "medium", "long", "full"];
const kinds = ["date", "time", "datetime", "yearMonth", "monthDay"];
const sample = new Date("2006-02-03T05:08:09Z");
const quote = (value) => `'${value.replaceAll("'", "''")}'`;
function pattern(locale, kind, style) {
  const options = {
    timeZone: "UTC",
    calendar: "gregory",
    numberingSystem: "latn"
  };
  if (["date", "datetime"].includes(kind)) options.dateStyle = style;
  if (["time", "datetime"].includes(kind))
    options.timeStyle = style === "short" ? "short" : "medium";
  if (["yearMonth", "monthDay"].includes(kind)) {
    options.month =
      style === "short" ? "2-digit" : style === "medium" ? "short" : "long";
    if (kind === "yearMonth") options.year = "numeric";
    else options.day = "2-digit";
  }
  const formatter = new Intl.DateTimeFormat(locale, options);
  const cycle = formatter.resolvedOptions().hourCycle;
  const parts = formatter.formatToParts(sample);
  return parts
    .map((part) => {
      switch (part.type) {
        case "year":
          return "yyyy";
        case "era":
          return quote(part.value);
        case "month":
          return /^\d+$/.test(part.value)
            ? part.value.length === 2
              ? "MM"
              : "M"
            : style === "medium"
              ? "MMM"
              : "MMMM";
        case "day":
          return part.value.length === 2 ? "dd" : "d";
        case "hour":
          return (["h11", "h12"].includes(cycle) ? "h" : "H").repeat(
            part.value.length === 2 ? 2 : 1
          );
        case "minute":
          return "mm";
        case "second":
          return "ss";
        case "weekday":
          return style === "full" ? "EEEE" : "EEE";
        case "dayPeriod":
          return "a";
        case "literal":
          return quote(
            part.value.replaceAll("\u202f", " ").replaceAll("\u00a0", " ")
          );
        default:
          throw new Error(`Unsupported Intl part ${part.type} for ${locale}`);
      }
    })
    .join("");
}
const records = [];
for (const id of locales) {
  // Salesforce legacy locale language aliases; Intl uses BCP 47 identifiers.
  const locale = id
    .replaceAll("_", "-")
    .replace(/^iw(?=-|$)/, "he")
    .replace(/^in(?=-|$)/, "id")
    .replace(/^ji(?=-|$)/, "yi");
  const values = kinds.flatMap((kind) =>
    styles.map((style) => pattern(locale, kind, style))
  );
  records.push([id, values]);
}
const apexQuote = (s) =>
  `'${s.replaceAll("\\", "\\\\").replaceAll("'", "\\'")}'`;
let apex =
  "// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause\n/** @description Generated Gregorian locale/style patterns. Regenerate with scripts/actions/generate-locale-patterns.mjs. */\npublic with sharing class ChronoLocalePatterns {\n";
apex +=
  "  private static Map<String,List<String>> patterns=new Map<String,List<String>>{\n" +
  records
    .map(
      ([id, values]) =>
        `    ${apexQuote(id)}=>new List<String>{${values.map(apexQuote).join(",")}}`
    )
    .join(",\n") +
  "\n  };\n";
apex += `  public static String getPattern(String locale,String kind,String style) {
    Integer kindIndex=new List<String>{'date','time','datetime','yearMonth','monthDay'}.indexOf(kind);
    Integer styleIndex=new List<String>{'short','medium','long','full'}.indexOf(style);
    if(kindIndex<0 || styleIndex<0) { throw new ChronoException('Choose a supported format kind and short, medium, long or full style.'); }
    if(!patterns.containsKey(locale)) { return null; }
    return patterns.get(locale)[kindIndex*4+styleIndex];
  }
}\n`;
const dest = path.join(root, "force-app/main/default/classes");
fs.writeFileSync(path.join(dest, "ChronoLocalePatterns.cls"), apex);
fs.copyFileSync(
  path.join(dest, "ChronoDurationMath.cls-meta.xml"),
  path.join(dest, "ChronoLocalePatterns.cls-meta.xml")
);
console.log(
  `Generated ${records.length} locales; ${apex.length} source characters.`
);
