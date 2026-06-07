import { existsSync, mkdirSync } from "fs";

import { log, warn, fatal } from "../logger.js";
import { config } from "../config.js";
import {
  assertRcloneInstalled, assertRemoteConfigured, verifyCredentials, rcloneSync,
} from "../rclone.js";

const { source: LIB_DIR, remote: LIB_REMOTE, excludePatterns } = config.library;

export function runLibraryPipeline() {
  if (!existsSync(LIB_DIR)) {
    mkdirSync(LIB_DIR, { recursive: true });
    log("library", `Created ${LIB_DIR} (empty — skipping sync).`);
    return;
  }

  assertRcloneInstalled();
  const [remoteName] = LIB_REMOTE.split(":");
  assertRemoteConfigured(remoteName);

  log("library", "Verifying credentials...");
  if (!verifyCredentials(`${remoteName}:`)) {
    fatal(
      "library",
      `Credentials for "${remoteName}" are invalid or expired.`,
      `Fix: rclone config reconnect ${remoteName}:`
    );
  }

  const excludeArgs = excludePatterns.flatMap((p) => ["--exclude", p]);

  log("library", `Syncing → ${LIB_REMOTE}`);
  try {
    rcloneSync(`${LIB_DIR}/`, LIB_REMOTE, ["--checksum", ...excludeArgs]);
    log("library", "Library sync complete.");
  } catch (err) {
    warn("library", `Sync failed: ${err.message}`);
    warn("library", "Files are safe locally — will retry on next run.");
  }
}
