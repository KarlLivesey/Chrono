import { rankPages } from "./search.mjs";

const root = document.documentElement;
const themeButton = document.querySelector(".theme-button");
const themes = ["system", "light", "dark"];
let theme = "system";
try {
  theme = localStorage.getItem("chrono-docs-theme") || "system";
} catch {
  /* Storage can be disabled; use system preference. */
}
function applyTheme(value) {
  theme = themes.includes(value) ? value : "system";
  if (theme === "system") delete root.dataset.theme;
  else root.dataset.theme = theme;
  themeButton.textContent = `Theme: ${theme}`;
  themeButton.setAttribute(
    "aria-label",
    `Colour theme: ${theme}. Change theme`
  );
}
applyTheme(theme);
themeButton.addEventListener("click", () => {
  applyTheme(themes[(themes.indexOf(theme) + 1) % themes.length]);
  try {
    localStorage.setItem("chrono-docs-theme", theme);
  } catch {
    /* Selection still applies to this page. */
  }
});

const navigation = document.querySelector(".mobile-navigation");
const mobile = matchMedia("(max-width: 800px)");
navigation.open = !mobile.matches;
mobile.addEventListener("change", (event) => {
  navigation.open = !event.matches;
});

const input = document.querySelector("#site-search");
document.addEventListener("keydown", (event) => {
  if (
    event.key === "/" &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.altKey &&
    !event.target.closest?.("input, textarea, [contenteditable=true]")
  ) {
    event.preventDefault();
    input.focus();
  }
});

for (const pre of document.querySelectorAll("pre")) {
  const wrapper = document.createElement("div");
  wrapper.className = "code-shell";
  pre.before(wrapper);
  wrapper.append(pre);
  const button = document.createElement("button");
  button.type = "button";
  button.className = "copy-code";
  button.textContent = "Copy";
  button.setAttribute("aria-label", "Copy code example");
  button.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(pre.textContent);
      button.textContent = "Copied";
    } catch {
      button.textContent = "Select code to copy";
    }
    setTimeout(() => {
      button.textContent = "Copy";
    }, 2200);
  });
  wrapper.append(button);
}

const results = document.querySelector("#search-results");
if (results) {
  const status = document.querySelector("#search-status");
  let pages;
  let revision = 0;
  let pending;
  async function search() {
    const ownRevision = ++revision;
    const query = input.value.trim();
    const url = new URL(location.href);
    if (query) url.searchParams.set("q", query);
    else url.searchParams.delete("q");
    history.replaceState(null, "", url);
    results.replaceChildren();
    if (!query) {
      status.textContent =
        "Search for an action, a method or the task you want to complete.";
      return;
    }
    status.textContent = "Searching documentation…";
    try {
      if (!pages) {
        pending ||= fetch(
          `${document.body.dataset.base}search-index.json`
        ).then((response) => {
          if (!response.ok) throw new Error("Search index unavailable");
          return response.json();
        });
        pages = await pending;
      }
      if (revision !== ownRevision) return;
      const matches = rankPages(pages, query);
      status.textContent = matches.length
        ? `${matches.length === 40 ? "Top 40" : matches.length} results for “${query}”`
        : `No results for “${query}”. Try a method name, “holiday”, “offset” or “Flow”.`;
      for (const match of matches) {
        const item = document.createElement("li");
        const category = document.createElement("span");
        category.className = "result-category";
        category.textContent = match.category;
        const heading = document.createElement("h2");
        const link = document.createElement("a");
        link.href = `${document.body.dataset.base}${match.url}`;
        link.textContent = match.title;
        const excerpt = document.createElement("p");
        excerpt.textContent = match.excerpt;
        heading.append(link);
        item.append(category, heading, excerpt);
        results.append(item);
      }
    } catch {
      if (revision !== ownRevision) return;
      pending = null;
      status.textContent =
        "Search could not load. Try again, or browse the guide and reference indexes in the menu.";
    }
  }
  input.value = new URLSearchParams(location.search).get("q") || "";
  let timer;
  input.addEventListener("input", () => {
    clearTimeout(timer);
    timer = setTimeout(search, 120);
  });
  document.querySelector(".site-search").addEventListener("submit", (event) => {
    event.preventDefault();
    search();
  });
  search();
}
