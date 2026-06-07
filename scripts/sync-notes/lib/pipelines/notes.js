import { readdirSync, mkdirSync, existsSync } from "fs";
import { join, relative, dirname } from "path";

import { run, commandExists } from "../exec.js";
import { log, warn, fatal } from "../logger.js";
import { config } from "../config.js";
import { loadManifest, saveManifest, sha256File } from "../manifest.js";
import {
  assertRcloneInstalled, assertRemoteConfigured, verifyCredentials, rcloneSync,
} from "../rclone.js";

const {
  source: NOTES_DIR, sourceBak: NOTES_BAK,
  stage:  PDF_DIR,   stageBak:  PDF_BAK,
  remote: REMOTE,
} = config.notes;

// ── Generic local mirror (hash-based diff, no deletions) ─────────────────────
function localMirror(tag, src, dest) {
  if (!commandExists("rsync")) {
    fatal(tag, "rsync not found.", "Fix: sudo apt install rsync");
  }
  mkdirSync(dest, { recursive: true });
  log(tag, `Mirroring ${src} → ${dest}`);
  try {
    run(`rsync -a --checksum --partial "${src}/" "${dest}/"`, { stdio: "inherit" });
    log(tag, "Local backup complete.");
  } catch (err) {
    warn(tag, `rsync failed: ${err.message}`);
    warn(tag, "Continuing — source files are still intact.");
  }
}

// ── Export .rnote → PDF (hash-gated via manifest) ────────────────────────────
function findRnoteFiles(dir) {
  const results = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) results.push(...findRnoteFiles(full));
    else if (entry.name.endsWith(".rnote")) results.push(full);
  }
  return results;
}

function exportOne(rnotePath, pdfPath) {
  mkdirSync(dirname(pdfPath), { recursive: true });
  run(
    `flatpak run --command=rnote-cli com.github.flxzt.rnote ` +
      `export --on-conflict overwrite doc --output-file "${pdfPath}" "${rnotePath}"`,
    { stdio: "inherit", timeout: config.exportTimeoutMs }
  );
}

function exportPDFs() {
  try {
    run("flatpak run --command=rnote-cli com.github.flxzt.rnote --version",
        { stdio: "pipe" });
  } catch {
    fatal("export", "rnote-cli not found inside the Rnote flatpak.",
          "Fix: flatpak install flathub com.github.flxzt.rnote");
  }

  if (!existsSync(PDF_DIR)) mkdirSync(PDF_DIR, { recursive: true });

  const manifest = loadManifest();
  const failures = [];
  let exported = 0;

  for (const rnotePath of findRnoteFiles(NOTES_DIR)) {
    const rel     = relative(NOTES_DIR, rnotePath);
    const pdfPath = join(PDF_DIR, rel.replace(/\.rnote$/, ".pdf"));
    const hash    = sha256File(rnotePath);

    if (existsSync(pdfPath) && manifest[rnotePath] === hash) continue;

    log("export", rel);
    try {
      exportOne(rnotePath, pdfPath);
      manifest[rnotePath] = hash;
      exported++;
    } catch (err) {
      const reason = err.code === "ETIMEDOUT"
        ? `timed out after ${config.exportTimeoutMs / 1000}s`
        : err.message;
      warn("export", `${rel} — ${reason}`);
      failures.push(rel);
    }
  }

  saveManifest(manifest);

  if (exported === 0 && failures.length === 0) log("export", "All PDFs up to date (hash-checked).");
  else log("export", `Exported ${exported} file(s), ${failures.length} failed.`);

  return failures;
}

// ── Upload PDFs to GDrive (hash-based diff via --checksum) ───────────────────
function uploadPDFs() {
  assertRcloneInstalled();
  const [remoteName] = REMOTE.split(":");
  assertRemoteConfigured(remoteName);

  log("upload", "Verifying credentials...");
  if (!verifyCredentials(`${remoteName}:`)) {
    fatal("upload", `Credentials for "${remoteName}" are invalid or expired.`,
          `Fix: rclone config reconnect ${remoteName}:`);
  }

  log("upload", `Syncing PDFs → ${REMOTE}`);
  try {
    rcloneSync(`${PDF_DIR}/`, REMOTE, ["--checksum"]);
    log("upload", "Sync complete.");
  } catch (err) {
    warn("upload", `Sync failed: ${err.message}`);
    warn("upload", "PDFs are safe locally — will retry on next run.");
  }
}

export function runNotesPipeline() {
  if (!existsSync(NOTES_DIR)) {
    fatal("notes", `Source directory not found: ${NOTES_DIR}`);
  }

  localMirror("backup-src", NOTES_DIR, NOTES_BAK);
  const failures = exportPDFs();
  localMirror("backup-pdf", PDF_DIR, PDF_BAK);
  uploadPDFs();

  return failures;
}
