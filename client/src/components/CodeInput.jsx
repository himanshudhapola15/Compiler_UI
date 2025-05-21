import { useState } from "react";

export default function CodeInput({ onSubmit }) {
  const [code, setCode] = useState("");
  const [fileName, setFileName] = useState("No file chosen");

  const handleFileUpload = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    setFileName(file.name);

    const reader = new FileReader();
    reader.onload = (e) => setCode(e.target.result);
    reader.readAsText(file);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!code.trim()) return alert("Please provide code or upload a file.");
    onSubmit({ code });
  };

  return (
    <form onSubmit={handleSubmit} className="mb-6">
      <label className="block mb-2 font-medium">Upload C File:</label>

      <div className="flex items-center space-x-4 mb-4">
        <label className="bg-blue-600 text-white px-4 py-2 rounded cursor-pointer hover:bg-blue-700">
          Choose File
          <input
            type="file"
            accept=".c,.cm,.txt"
            onChange={handleFileUpload}
            className="hidden"
          />
        </label>
        <span className="text-sm text-gray-600">{fileName}</span>
      </div>

      <label className="block mb-2 font-medium">Or Write Code:</label>
      <textarea
        className="w-full p-2 border rounded h-64 font-mono text-sm"
        placeholder="Type your C subset code here..."
        value={code}
        onChange={(e) => setCode(e.target.value)}
      />

      <button
        type="submit"
        className="mt-4 bg-green-600 text-white py-2 px-4 rounded hover:bg-green-700"
      >
        Compile
      </button>
    </form>
  );
}
