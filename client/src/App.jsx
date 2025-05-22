import { useState } from "react";
import CodeInput from "./components/CodeInput";
import OutputDisplay from "./components/OutputDisplay";

export default function App() {
  const [result, setResult] = useState({
    tokens: "",
    output: "",
  });

  const handleCompile = async ({ code }) => {
    try {
      const response = await fetch("http://localhost:5000/compile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      });
      console.log("RESPONSE: ", response);
      const data = await response.json();
      setResult({
        tokens: data.tokens || "",
        output: data.output || "",
      });
    } catch (err) {
      setResult({
        tokens: "",
        output: `❌ Compilation failed: ${err.message}`,
      });
    }
  };

  return (
    <div className="max-w-5xl mx-auto py-10">
      <h1 className="text-3xl font-bold text-center mb-8">C Subset Compiler</h1>
      <CodeInput onSubmit={handleCompile} />
      <OutputDisplay result={result} />
    </div>
  );
}
