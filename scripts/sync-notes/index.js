#!/usr/bin/env node
import { config } from "./lib/config.js";
import { log } from "./lib/logger.js";
import { runNotesPipeline } from "./lib/pipelines/notes.js";
import { runLibraryPipeline } from "./lib/pipelines/library.js";

const exportFailures = [];

if (config.notes.enabled) {
  log("main", "▶ Notes pipeline");
  exportFailures.push(...runNotesPipeline());
} else {
  log("main", "Notes pipeline disabled — skipping.");
}

if (config.library.enabled) {
  log("main", "▶ Library pipeline");
  runLibraryPipeline();
} else {
  log("main", "Library pipeline disabled — skipping.");
}

console.log("\n[main] Done.");
// Exit 1 if any rnote exports failed so CI/scripts can detect partial runs
process.exit(exportFailures.length > 0 ? 1 : 0);
