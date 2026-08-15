import { main as installMain } from "./install.js";

export const HELP = `
OpenCode Engineering Kit CLI - upgrade

Re-installs the kit into the current project with --force, refreshing every
asset and the opencode.json wiring from the latest remote revision.

Usage:
  opencode-engineering-kit upgrade [options]

Options (same as install):
  --target <dir>    Target project directory (default: current directory)
  --repo <repo>     GitHub repository to fetch from (default: devtiagoabreu/opencode-engineering-kit)
  --branch <name>   Git branch/tag (default: main)
  --only <list>     Comma-separated subset: skills,agents,commands,context,assets
  --dry-run         Print what would be done without touching the filesystem
  --help            Show this help
`;

export function main(argv) {
  const normalized = [];
  let help = false;
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--help" || argv[i] === "-h") { help = true; continue; }
    normalized.push(argv[i]);
  }
  if (help) {
    console.log(HELP);
    return;
  }
  return installMain(["install", "--force", ...normalized]);
}
