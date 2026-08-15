#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { main as installMain } from "./install.js";
import { main as listMain } from "./list.js";
import { main as searchMain } from "./search.js";
import { main as doctorMain } from "./doctor.js";
import { main as upgradeMain } from "./upgrade.js";
import { main as exportMain } from "./export.js";
import { mainStatus, mainStart, mainStop } from "./manage.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export const HELP = `
OpenCode Engineering Kit CLI

Usage:
  opencode-engineering-kit <command> [options]

Commands:
  install     Install skills, agents, commands, context into .opencode/ of a project (or globally with --global)
  status      Show where the kit is installed and whether it is enabled
  start       Re-enable the kit (restore opencode.json wiring)
  stop        Disable the kit (keep files, remove opencode.json wiring)
  list        List assets (skills, agents, prompts, templates) from a kit checkout
  search      Search asset names and descriptions by keyword
  doctor      Check the kit integrity (schema, indexes, security scan, dependencies)
  upgrade     Re-install with --force from the remote repository
  export      Generate harness packages (.claude, .cursor, CLAUDE.md) from assets
  --version   Print version
  --help      Show this help

Run "opencode-engineering-kit <command> --help" for command-specific options.
`;

export function main(argv) {
  const [cmd, ...rest] = argv;
  switch (cmd) {
    case "install": return installMain(rest);
    case "status": return mainStatus(rest);
    case "start": return mainStart(rest);
    case "stop": return mainStop(rest);
    case "list": return listMain(rest);
    case "search": return searchMain(rest);
    case "doctor": return doctorMain(rest);
    case "upgrade": return upgradeMain(rest);
    case "export": return exportMain(rest);
    case "--version": case "-v": {
      const pkg = JSON.parse(fs.readFileSync(path.join(__dirname, "..", "package.json"), "utf8"));
      console.log(pkg.version);
      return;
    }
    case "--help": case "-h": case undefined:
      console.log(HELP);
      return;
    default:
      // Backward compatibility: bare options were previously forwarded to install
      if (cmd.startsWith("--")) {
        return installMain(argv);
      }
      throw new Error(`unknown command: ${cmd}\n${HELP}`);
  }
}

export default main;
