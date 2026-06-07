import { createHash } from "crypto";
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "fs";
import { join, dirname } from "path";
import { homedir } from "os";

const MANIFEST_PATH = join(homedir(), ".local", "share", "sync-notes", "manifest.json");

export function loadManifest() {
  if (!existsSync(MANIFEST_PATH)) return {};
  try { return JSON.parse(readFileSync(MANIFEST_PATH, "utf8")); }
  catch { return {}; }
}

export function saveManifest(manifest) {
  mkdirSync(dirname(MANIFEST_PATH), { recursive: true });
  writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2));
}

export function sha256File(path) {
  return createHash("sha256").update(readFileSync(path)).digest("hex");
}
