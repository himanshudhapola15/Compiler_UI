const express = require("express");
const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const cors = require("cors");
require("dotenv").config();

const app = express();

app.use(cors({ origin: "*" }));
app.use(express.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.post("/compile", (req, res) => {
  if (!req.body.code) {
    return res.status(400).json({ error: "Code is required" });
  }

  const codeFilePath = path.join(__dirname, "parser" ,"parser_text.cm");
  const tokenFilePath = path.join(__dirname, "parser", "tokens.txt");
  const buildScriptPath = path.join(__dirname, "parser", "build.bat");

  console.log(buildScriptPath)

  try {
    fs.writeFileSync(codeFilePath, req.body.code);
  } catch (writeErr) {
    return res.status(500).json({ error: "Failed to write code file." });
  }

  exec(
    `"${buildScriptPath}"`,
    { cwd: path.join(__dirname, "parser") },
    (error, stdout, stderr) => {
      if (error) {
        console.error("Build error:", error);
        return res.status(500).json({ error: stderr || error.message });
      }

      let tokens = "";
      try {
        tokens = fs.readFileSync(tokenFilePath, "utf8");
        console.log("TOKENS: ", tokens);
      } catch (readErr) {
        console.error("Error reading tokens.txt:", readErr);
        tokens = "Error reading tokens.";
      }
      console.log("TOKENS", tokens);
      res.json({
        output: stdout,
        tokens: tokens,
      });
    }
  );
});

app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
