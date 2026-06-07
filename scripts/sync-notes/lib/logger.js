export const log  = (tag, msg) => console.log(`[${tag}] ${msg}`);
export const warn = (tag, msg) => console.warn(`[${tag}] ⚠  ${msg}`);

export function fatal(tag, msg, hint = "") {
  console.error(`[${tag}] ✗  ${msg}`);
  if (hint) console.error(`${"".padStart(tag.length + 6)}${hint}`);
  process.exit(2);
}
