export default function OutputDisplay({ result }) {
  return (
    <div className="mt-8 bg-white shadow rounded p-4">
      <h2 className="text-xl font-semibold mb-2">Lexer Output (Tokens)</h2>
      <pre className="bg-gray-100 p-2 rounded overflow-auto whitespace-pre-wrap">
        {result.tokens || "No tokens generated."}
      </pre>

      <h2 className="text-xl font-semibold mt-6 mb-2">Parser Output</h2>
      <pre className="bg-gray-100 p-2 rounded overflow-auto whitespace-pre-wrap">
        {result.output || "No parser output."}
      </pre>
    </div>
  );
}
