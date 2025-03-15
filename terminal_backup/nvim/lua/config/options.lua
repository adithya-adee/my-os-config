-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set clipboard to use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable URL highlighting
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""

-- Highlight URLs
vim.cmd([[
  augroup HighlightURLs
    autocmd!
    autocmd VimEnter,BufEnter * syntax match URL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
    autocmd VimEnter,BufEnter * highlight URL ctermfg=blue guifg=blue gui=underline cterm=underline
  augroup END
]])

-- Uncomment and modify this if you want to use external clipboard tools
-- vim.g.clipboard = {
--   name = "system clipboard",
--   copy = {
--     ["+"] = "xclip -selection clipboard",
--     ["*"] = "xclip -selection clipboard",
--   },
--   paste = {
--     ["+"] = "xclip -selection clipboard -o",
--     ["*"] = "xclip -selection clipboard -o",
--   },
--   cache_enabled = 1,
-- }
