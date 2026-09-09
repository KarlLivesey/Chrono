// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { matches, outputChildren, roots } from "./resources";

/** Typed resource tree. Schema requests are shared only within this picker. */
export class ResourceCatalog {
  constructor(
    context,
    outputs,
    valueType,
    objectType,
    describe,
    acceptedTypes = []
  ) {
    this.context = context || {};
    this.outputs = outputs || {};
    this.valueType = valueType;
    this.objectType = objectType;
    this.describe = describe;
    this.acceptedTypes = acceptedTypes.length
      ? acceptedTypes
      : [{ valueType, objectType }];
    this.fields = new Map();
  }
  accepts(item) {
    return this.acceptedTypes.some((type) =>
      matches(item, type.valueType, type.objectType)
    );
  }
  async schema(objectType) {
    if (!this.fields.has(objectType)) {
      const request = this.describe({ objectApiName: objectType }).catch(
        (error) => {
          this.fields.delete(objectType);
          throw error;
        }
      );
      this.fields.set(objectType, request);
    }
    return this.fields.get(objectType);
  }
  async recordFields(item) {
    return (await this.schema(item.objectType)).map((field) => ({
      ...field,
      value: item.value + "." + field.name,
      group: item.label
    }));
  }
  async node(item, visited = new Set()) {
    const selectable = this.accepts(item);
    let children = [];
    if (!item.isCollection && !visited.has(item.value)) {
      const next = new Set([...visited, item.value]);
      if (item.children) {
        children = (
          await Promise.all(
            outputChildren(item.value, this.outputs).map((child) =>
              this.node(child, next)
            )
          )
        ).filter(Boolean);
      } else if (
        item.dataType === "SObject" &&
        item.objectType &&
        this.acceptedTypes.some(
          (type) =>
            !type.valueType.endsWith("[]") && !type.valueType.startsWith("Apex")
        ) &&
        !selectable
      ) {
        const fields = await this.recordFields(item);
        children = (
          await Promise.all(
            fields.map(async (field) => {
              const accepted = this.accepts(field);
              // Prove a relationship has compatible fields before displaying it.
              // Further relationships expand on navigation rather than following cycles.
              const nested =
                field.dataType === "SObject" && field.objectType
                  ? (await this.recordFields(field))
                      .filter((value) => this.accepts(value))
                      .map((value) => ({
                        ...value,
                        selectable: true,
                        children: []
                      }))
                  : [];
              return accepted || nested.length
                ? {
                    ...field,
                    selectable: accepted,
                    children: nested,
                    relationship: !!nested.length
                  }
                : null;
            })
          )
        ).filter(Boolean);
      }
    }
    return selectable || children.length
      ? { ...item, selectable, children }
      : null;
  }
  async load() {
    const outcomes = await Promise.allSettled(
      roots(this.context, this.outputs).map((item) => this.node(item))
    );
    return {
      nodes: outcomes
        .filter((item) => item.status === "fulfilled")
        .map((item) => item.value)
        .filter(Boolean),
      incomplete: outcomes.some((item) => item.status === "rejected")
    };
  }
}

/** Search compatible leaves, including fields underneath named containers. */
export function searchNodes(nodes, query) {
  const term = query.trim().toLowerCase();
  if (!term) return nodes;
  const found = [];
  const visit = (items) => {
    for (const item of items) {
      if (
        item.selectable &&
        (item.label + " " + item.value).toLowerCase().includes(term)
      )
        found.push(item);
      visit(item.children || []);
    }
  };
  visit(nodes);
  return [...new Map(found.map((item) => [item.value, item])).values()];
}
