import React, { useEffect, useRef, useState } from "react";
import { hierarchy, tree as d3tree } from "d3-hierarchy";

// Draw a line with an arrow
function drawLine(from, to) {
  return (
    <line
      key={`${from.x}-${from.y}-${to.x}-${to.y}`}
      x1={from.x}
      y1={from.y}
      x2={to.x}
      y2={to.y}
      stroke="black"
      strokeWidth={2}
      markerEnd="url(#arrow)"
    />
  );
}

function NodeCircle({ node }) {
  return (
    <foreignObject x={node.x - 30} y={node.y - 30} width={60} height={60}>
      <div className="w-14 h-14 rounded-full border-2 border-black bg-white flex items-center justify-center text-center text-xs font-bold">
        {node.data.content}
      </div>
    </foreignObject>
  );
}

export function TreeWithSVG({ tree }) {
  const [nodes, setNodes] = useState([]);
  const [links, setLinks] = useState([]);
  const containerRef = useRef(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const containerWidth = containerRef.current.offsetWidth;
    const root = hierarchy({ content: "ROOT", children: tree });
    const treeLayout = d3tree().nodeSize([100, 120]);
    const layoutRoot = treeLayout(root);

    const nodePositions = layoutRoot.descendants().map((d) => ({
      ...d,
      x: d.x + containerWidth / 2,
      y: d.y + 50,
    }));

    const linkPositions = layoutRoot.links().map((link) => ({
      from: {
        x: link.source.x + containerWidth / 2,
        y: link.source.y + 50 + 30,
      },
      to: {
        x: link.target.x + containerWidth / 2,
        y: link.target.y + 50 - 30,
      },
    }));

    setNodes(nodePositions);
    setLinks(linkPositions);
  }, [tree]);

  return (
    <div ref={containerRef} className="relative min-h-[700px] w-full">
      <svg className="absolute top-0 left-0 w-full h-full">
        <defs>
          <marker
            id="arrow"
            markerWidth="10"
            markerHeight="10"
            refX="6"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L9,3 z" fill="black" />
          </marker>
        </defs>
        {links.map((link) => drawLine(link.from, link.to))}
        {nodes.map((node, i) => (
          <NodeCircle key={i} node={node} />
        ))}
      </svg>
    </div>
  );
}
