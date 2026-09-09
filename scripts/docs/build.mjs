// Build static documentation. Only checked-in Markdown is rendered; raw HTML is escaped.
import { Marked } from "marked";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "../.."
);
const docs = path.join(root, "docs");
const output = path.join(root, ".docs-site");
const config = JSON.parse(
  await fs.readFile(path.join(docs, "site.json"), "utf8")
);
const escape = (value) =>
  String(value).replace(
    /[&<>"']/g,
    (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        c
      ]
  );
const plainText = (value) =>
  value
    .replace(/<[^>]*>/g, "")
    .replace(/[`*_#]/g, "")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1");

async function markdownFiles(directory) {
  const entries = await fs.readdir(directory, { withFileTypes: true });
  const groups = await Promise.all(
    entries.map((entry) =>
      entry.isDirectory()
        ? markdownFiles(path.join(directory, entry.name))
        : entry.name.endsWith(".md")
          ? [path.join(directory, entry.name)]
          : []
    )
  );
  return groups.flat().sort();
}

const files = [
  path.join(docs, "index.md"),
  path.join(docs, "time-allocation.md"),
  path.join(docs, "bulk-apex-services.md"),
  path.join(docs, "bulk-working-time-service.md"),
  path.join(docs, "service-audit-2026-09.md"),
  ...(await markdownFiles(path.join(docs, "handbook"))),
  ...(await markdownFiles(path.join(docs, "reference")))
];
const pages = [];

function navigation(current, prefix) {
  return config.navigation
    .map(
      (group) =>
        `<section class="nav-group"><h2>${escape(group.label)}</h2><ul>${group.items
          .map(([label, route]) => {
            const active = route === current;
            const parent =
              route.startsWith("reference/") &&
              current.startsWith(path.posix.dirname(route) + "/");
            return `<li><a href="${prefix}${route.replace(/\.md$/, ".html")}"${active ? ' aria-current="page"' : ""}${parent && !active ? ' class="current-section"' : ""}>${escape(label)}</a></li>`;
          })
          .join("")}</ul></section>`
    )
    .join("");
}

function shell({
  route,
  title,
  content,
  headings,
  description = "",
  home = false
}) {
  const depth = route.split("/").length - 1;
  const prefix = "../".repeat(depth);
  const current = route.replace(/\.html$/, ".md");
  const section = route.startsWith("reference/")
    ? "Reference"
    : home
      ? "The Chrono handbook"
      : "Guide";
  const toc = headings
    .filter((h) => h.depth === 2)
    .map((h) => `<li><a href="#${h.id}">${escape(h.text)}</a></li>`)
    .join("");
  const html = `<!doctype html>
<html lang="en-GB"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escape(title)} · Chrono</title><meta name="description" content="${escape(description.slice(0, 190))}">
<meta name="color-scheme" content="light dark"><meta name="theme-color" content="#f6f4ee">
<link rel="canonical" href="${config.url}/${route}"><link rel="icon" href="${prefix}assets/mark.svg" type="image/svg+xml">
<link rel="stylesheet" href="${prefix}assets/site.css"><script type="module" src="${prefix}assets/site.mjs"></script></head>
<body data-base="${prefix}" class="${home ? "home-page" : "document-page"}">
<a class="skip-link" href="#content">Skip to content</a>
<header class="site-header"><a class="brand" href="${prefix}index.html" aria-label="Chrono documentation home"><img src="${prefix}assets/mark.svg" alt="" width="31" height="31"><span>Chrono<span class="brand-caption">Salesforce date &amp; time</span></span></a>
<form class="site-search" role="search" action="${prefix}search.html"><label class="sr-only" for="site-search">Search documentation</label><span class="search-symbol" aria-hidden="true">⌕</span><input id="site-search" name="q" type="search" placeholder="Find a guide, action or method…" autocomplete="off"><kbd aria-hidden="true">/</kbd></form>
<div class="header-actions"><a class="release" href="${prefix}handbook/releases.html">v${config.version}<span class="release-dot" aria-hidden="true"></span></a><button class="theme-button" type="button" aria-label="Change colour theme">Theme: system</button><a class="repo-link" href="https://github.com/KarlLivesey/Chrono">GitHub <span aria-hidden="true">↗</span></a></div></header>
<div class="layout"><aside class="sidebar"><details class="mobile-navigation" open><summary>Documentation menu</summary><nav aria-label="Documentation">${navigation(current, prefix)}</nav></details></aside>
<main id="content" tabindex="-1"><div class="eyebrow">${section} <span>/</span> ${escape(home ? "Release " + config.version : title)}</div>
<article>${content}</article><footer class="article-footer"><p>Chrono ${config.version} · <code>skel</code> namespace</p><p>Check release notes for released and development API availability. <a href="${prefix}handbook/releases.html">Validation &amp; release notes</a></p></footer></main>
<aside class="contents" aria-label="On this page">${toc ? `<p>On this page</p><ol>${toc}</ol>` : ""}<a class="contents-help" href="${prefix}handbook/troubleshooting.html">Need a hand?<br><span>Troubleshooting →</span></a></aside></div>
<footer class="site-footer"><span>Chrono. A Salesforce library by Karl.</span><span>BSD-3-Clause <span aria-hidden="true">·</span> <a href="${prefix}licence.txt">Licence</a></span></footer>
</body></html>`;
  return html;
}

// This directory contains only generated artifacts; remove obsolete routes on rebuild.
await fs.rm(output, { recursive: true, force: true });
await fs.mkdir(output, { recursive: true });
for (const file of files) {
  const source = await fs.readFile(file, "utf8");
  const relative = path.relative(docs, file).split(path.sep).join("/");
  const route = relative.replace(/\.md$/, ".html");
  const headings = [];
  const ids = new Map();
  const renderer = {
    heading({ tokens, depth }) {
      const rendered = this.parser.parseInline(tokens);
      const text = plainText(rendered);
      const base =
        text
          .toLowerCase()
          .replace(/&\w+;/g, "")
          .replace(/[^a-z0-9\s-]/g, "")
          .trim()
          .replace(/\s+/g, "-") || "section";
      const count = ids.get(base) || 0;
      ids.set(base, count + 1);
      const id = base + (count ? "-" + count : "");
      headings.push({ text, id, depth });
      return `<h${depth} id="${id}">${rendered}${depth > 1 ? `<a class="heading-anchor" href="#${id}" aria-label="Link to ${escape(text)}">#</a>` : ""}</h${depth}>`;
    },
    html({ text }) {
      return escape(text);
    },
    link({ href, title, tokens }) {
      if (
        !/^(https?:|mailto:|#|[./]|[\w-])/i.test(href) ||
        /^(javascript|data|vbscript):/i.test(href)
      ) {
        throw new Error(`Unsafe documentation link: ${href}`);
      }
      const url = href.replace(/\.md(?=#|$)/, ".html");
      return `<a href="${escape(url)}"${title ? ` title="${escape(title)}"` : ""}>${this.parser.parseInline(tokens)}</a>`;
    },
    table(token) {
      const header = token.header
        .map((c) => `<th scope="col">${this.parser.parseInline(c.tokens)}</th>`)
        .join("");
      const rows = token.rows
        .map(
          (row) =>
            `<tr>${row.map((c) => `<td>${this.parser.parseInline(c.tokens)}</td>`).join("")}</tr>`
        )
        .join("");
      return `<div class="table-scroll" role="region" aria-label="Reference table" tabindex="0"><table><thead><tr>${header}</tr></thead><tbody>${rows}</tbody></table></div>`;
    }
  };
  const marked = new Marked({ renderer });
  const content = marked.parse(source);
  const title = headings.find((h) => h.depth === 1)?.text;
  if (!title) throw new Error(`Missing title: ${relative}`);
  const description = plainText(source)
    .split("\n")
    .slice(2)
    .filter(Boolean)
    .join(" ");
  const destination = path.join(output, route);
  await fs.mkdir(path.dirname(destination), { recursive: true });
  await fs.writeFile(
    destination,
    shell({
      route,
      title,
      content,
      headings,
      description,
      home: route === "index.html"
    })
  );
  pages.push({
    title,
    url: route,
    category: route.startsWith("reference/") ? route.split("/")[1] : "guide",
    text: plainText(source)
  });
}

await fs.cp(path.join(docs, "assets"), path.join(output, "assets"), {
  recursive: true
});
await fs.cp(path.join(docs, "examples"), path.join(output, "examples"), {
  recursive: true
});
await fs.copyFile(path.join(root, "LICENSE"), path.join(output, "licence.txt"));
await fs.writeFile(
  path.join(output, "search-index.json"),
  JSON.stringify(pages)
);
await fs.writeFile(path.join(output, ".nojekyll"), "");
await fs.writeFile(
  path.join(output, "search.html"),
  shell({
    route: "search.html",
    title: "Search documentation",
    headings: [],
    content:
      '<h1>Find your answer.</h1><p id="search-status" role="status">Search for an action, a method or the task you want to complete.</p><ol id="search-results" class="search-results"></ol><noscript><p>Search requires JavaScript. Browse the guide menu or the action, Apex and component indexes instead.</p></noscript>'
  })
);
await fs.writeFile(
  path.join(output, "404.html"),
  shell({
    route: "404.html",
    title: "Page not found",
    headings: [],
    content:
      '<h1>This page has moved.</h1><p>Start with the <a href="index.html">handbook</a> or <a href="search.html">search the reference</a>.</p>'
  })
);
await fs.writeFile(
  path.join(output, "sitemap.xml"),
  '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' +
    pages.map((p) => `<url><loc>${config.url}/${p.url}</loc></url>`).join("") +
    "</urlset>"
);
await fs.writeFile(
  path.join(output, "build.json"),
  JSON.stringify(
    {
      version: config.version,
      packageVersionId: config.packageVersionId,
      pages: pages.length
    },
    null,
    2
  ) + "\n"
);
console.log(`Built ${pages.length} documentation pages in ${output}`);
