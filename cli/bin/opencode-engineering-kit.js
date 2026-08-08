#!/usr/bin/env node
import { main } from "../src/install.js";

main(process.argv.slice(2)).catch((err) => {
  console.error(`[opencode-engineering-kit] error: ${err.message}`);
  process.exit(1);
});
