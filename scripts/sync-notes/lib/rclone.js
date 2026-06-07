import { execFileSync } from "child_process";

import { run, commandExists } from "./exec.js";
import { fatal } from "./logger.js";
import { config } from "./config.js";

export function assertRcloneInstalled() {
  if (!commandExists("rclone")) {
    fatal("rclone", "rclone binary not found.", "Fix: sudo apt install rclone");
  }
}

export function getConfiguredRemotes() {
  try {
    return run("rclone listremotes", { stdio: "pipe" })
      .split("\n")
      .map((r) => r.replace(/:$/, "").trim())
      .filter(Boolean);
  } catch {
    return [];
  }
}

function remoteName(spec) {
  return spec.replace(/:.*$/, "");
}

export function assertRemoteConfigured(spec) {
  const name = remoteName(spec);
  if (!getConfiguredRemotes().includes(name)) {
    fatal(
      "rclone",
      `Remote "${name}" is not configured.`,
      `Fix: run \`rclone config\` and create a remote named "${name}".`
    );
  }
}

// 45s timeout — generous so a cold OAuth refresh has time to complete.
export function verifyCredentials(spec) {
  try {
    execFileSync("rclone", ["lsd", spec, "--max-depth", "1"], {
      stdio: "pipe",
      timeout: 45_000,
    });
    return true;
  } catch {
    return false;
  }
}

// execFileSync (not shell) so exclude patterns like ".*" / "*.swp" aren't glob-expanded.
export function rcloneSync(src, dest, extraArgs = []) {
  const args = ["sync", src, dest, ...config.rcloneFlags, ...extraArgs, "--progress"];
  execFileSync("rclone", args, { stdio: "inherit" });
}
