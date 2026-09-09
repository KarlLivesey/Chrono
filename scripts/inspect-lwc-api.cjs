/** Read LWC contracts with the Babel parser already used by the LWC test toolchain. */
const { parse } = require("@babel/parser");
const fs = require("node:fs");

function shape(node) {
  if (Array.isArray(node)) return node.map(shape);
  if (!node || typeof node !== "object") return node;
  return Object.fromEntries(
    Object.entries(node)
      .filter(
        ([key]) =>
          ![
            "start",
            "end",
            "loc",
            "extra",
            "leadingComments",
            "trailingComments",
            "innerComments"
          ].includes(key)
      )
      .map(([key, value]) => [key, shape(value)])
  );
}

function contract(source) {
  const ast = parse(source, {
    sourceType: "module",
    plugins: ["decorators-legacy"]
  });
  const declarations = ast.program.body;
  const apiNames = new Set(
    declarations
      .filter((n) => n.type === "ImportDeclaration" && n.source.value === "lwc")
      .flatMap((n) =>
        n.specifiers
          .filter((s) => s.imported?.name === "api")
          .map((s) => s.local.name)
      )
  );
  const exported = declarations.find(
    (n) => n.type === "ExportDefaultDeclaration"
  )?.declaration;
  const klass =
    exported?.type === "Identifier"
      ? declarations.find(
          (n) => n.type === "ClassDeclaration" && n.id.name === exported.name
        )
      : exported;
  if (!klass || klass.type !== "ClassDeclaration") {
    if (apiNames.size)
      throw new Error("Public API import without an exported component class");
    return null;
  }
  const bases = new Set(
    declarations
      .filter((n) => n.type === "ImportDeclaration" && n.source.value === "lwc")
      .flatMap((n) =>
        n.specifiers
          .filter((s) => s.imported?.name === "LightningElement")
          .map((s) => s.local.name)
      )
  );
  if (!bases.has(klass.superClass?.name))
    throw new Error(
      "Unrecognised component inheritance; extend the contract inspector explicitly"
    );
  const members = klass.body.body;
  const exposed = new Set(
    members
      .filter((m) => m.decorators?.some((d) => apiNames.has(d.expression.name)))
      .map((m) => m.key.name)
  );
  return members
    .filter((m) => exposed.has(m.key.name))
    .map((m) => {
      if (m.computed)
        throw new Error(
          "Computed public LWC names require explicit contract support"
        );
      const result = {
        name: m.key.name,
        kind: m.type === "ClassProperty" ? "property" : m.kind
      };
      if (m.type === "ClassProperty") result.default = shape(m.value);
      else result.parameters = shape(m.params);
      if (m.async) result.async = true;
      if (m.generator) result.generator = true;
      return result;
    })
    .sort((a, b) => (a.name + a.kind).localeCompare(b.name + b.kind));
}

const sources = JSON.parse(fs.readFileSync(0, "utf8"));
process.stdout.write(
  JSON.stringify(
    Object.fromEntries(
      Object.entries(sources).map(([name, source]) => [name, contract(source)])
    )
  )
);
