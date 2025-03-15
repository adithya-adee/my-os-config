-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Enable URL opening with Ctrl+click
if vim.fn.has("mac") == 1 then
  vim.keymap.set("", "<C-LeftMouse>", function()
    local word = vim.fn.expand("<cWORD>")
    if word:match("^https?://") then
      vim.fn.system({ "open", word })
    end
  end, { desc = "Open URL under cursor (macOS)" })
elseif vim.fn.has("unix") == 1 then
  vim.keymap.set("", "<C-LeftMouse>", function()
    local word = vim.fn.expand("<cWORD>")
    if word:match("^https?://") then
      vim.fn.system({ "xdg-open", word })
    end
  end, { desc = "Open URL under cursor (Linux)" })
elseif vim.fn.has("win32") == 1 then
  vim.keymap.set("", "<C-LeftMouse>", function()
    local word = vim.fn.expand("<cWORD>")
    if word:match("^https?://") then
      vim.fn.system({ "cmd.exe", "/c", "start", word })
    end
  end, { desc = "Open URL under cursor (Windows)" })
end
