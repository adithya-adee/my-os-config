import { join } from "path";
import { homedir } from "os";

const HOME = homedir();

export const config = {
  // ── Notes pipeline ──────────────────────────────────────────────────────────
  notes: {
    enabled:    true,
    source:     join(HOME, "Documents", "NOTES"),         // .rnote source files
    sourceBak:  join(HOME, "Documents", "Notes.bak"),     // local mirror of source
    stage:      join(HOME, "Documents", "NOTES-PDF"),     // exported PDFs
    stageBak:   join(HOME, "Documents", "NOTES-PDF.bak"), // local mirror of PDFs
    remote:     "google-drive:Notes-PDF",                 // unencrypted destination
  },

  // ── Library pipeline ────────────────────────────────────────────────────────
  library: {
    enabled: true,
    source:  join(HOME, "Documents", "Library"),
    remote:  "google-drive:Library",
    excludePatterns: [".*", "*.swp", "*.tmp", "*.part", "*.crdownload"],
  },

  // ── Tool constraints ────────────────────────────────────────────────────────
  exportTimeoutMs: 60_000,                           // kill stuck rnote-cli exports

  // ── rclone tuning (applied to all rclone calls) ─────────────────────────────
  rcloneFlags: [
    "--transfers", "8",
    "--checkers", "16",
    "--fast-list",
    "--retries", "3",
    "--low-level-retries", "10",
  ],
};
