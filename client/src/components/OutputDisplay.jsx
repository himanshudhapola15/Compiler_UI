import React from "react";
import { TreeWithSVG } from "./TreeNodeWithLines";
import { hierarchy } from "d3-hierarchy";

function parseOutputToTree(output) {
  const lines = output.replace(/\r\n/g, "\n").split("\n").filter(Boolean);
  const root = { children: [] };
  const stack = [{ level: -1, node: root }];
  let idCounter = 0;

  for (const line of lines) {
    const match = line.match(/^(\s*)Node Type: (.+)$/);
    if (!match) continue;

    const indent = match[1].length;
    const rest = match[2];
    const level = Math.floor(indent / 2);

    const nameMatch = rest.match(/Name: ([^,]+),?/);
    const valueMatch = rest.match(/Value: ([^,]+)/);

    const name = nameMatch ? nameMatch[1].trim() : null;
    const value = valueMatch ? valueMatch[1].trim() : null;

    const content = name ? `${name}: ${value}` : `Value: ${value}`;
    const newNode = { id: `node-${idCounter++}`, content, children: [] };

    while (stack.length && stack[stack.length - 1].level >= level) {
      stack.pop();
    }

    stack[stack.length - 1].node.children.push(newNode);
    stack.push({ level, node: newNode });
  }

  return root.children;
}

export default function OutputDisplay({ result }) {
  const rawOutput = result.output || "";
  const cleanOutput = rawOutput.replace(/\r\n/g, "\n").trim();

  const parseTreeStart = cleanOutput
    .split("\n")
    .findIndex((line) => line.toLowerCase().includes("node type:"));

  const treeText =
    parseTreeStart >= 0
      ? cleanOutput.split("\n").slice(parseTreeStart).join("\n")
      : "";

  const parsedTree = parseTreeStart >= 0 ? parseOutputToTree(treeText) : [];

  return (
    <div className="mt-8 bg-white shadow rounded p-4">
      <h2 className="text-xl font-semibold mb-2">Lexer Output (Tokens)</h2>
      <pre className="bg-gray-100 p-2 rounded overflow-auto whitespace-pre-wrap text-sm font-mono">
        {result.tokens || "No tokens generated."}
      </pre>

      <h2 className="text-xl font-semibold mt-6 mb-4">Parse Tree</h2>
      {parsedTree.length > 0 ? (
        <TreeWithSVG tree={parsedTree} />
      ) : (
        <p className="text-gray-500">No parser output or invalid format.</p>
      )}
    </div>
  );
}
