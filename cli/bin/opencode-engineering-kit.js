#!/usr/bin/env node
import { main } from "../src/cli.js";

try {
  const result = main(process.argv.slice(2));
  if (result && typeof result.then === "function") {
    result.catch((err) => {
      console.error(`[opencode-engineering-kit] error: ${err.message}`);
      process.exit(1);
    });
  }
} catch (err) {
  console.error(`[opencode-engineering-kit] error: ${err.message}`);
  process.exit(1);
}
