import { execSync } from "child_process";

export function run(cmd, opts = {}) {
  return execSync(cmd, { encoding: "utf8", ...opts });
}

export function commandExists(name) {
  try { run(`which ${name}`, { stdio: "pipe" }); return true; }
  catch { return false; }
}
