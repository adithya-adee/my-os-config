return {
  {
    "axieax/urlview.nvim",
    cmd = { "UrlView" },
    config = function()
      require("urlview").setup({
        -- default configuration
        default_title = "URLs",
        default_picker = "telescope",
        default_action = "system",
        -- Prompt to be shown in the picker
        prompt = "Open URL> ",
        -- Configure the telescope UI
        telescope = {
          show_preview = true,
        },
      })
      
      -- Add keymaps for URL viewing
      vim.keymap.set("n", "<leader>fu", "<cmd>UrlView<cr>", { desc = "View buffer URLs" })
      vim.keymap.set("n", "<leader>fU", "<cmd>UrlView lazy<cr>", { desc = "View plugin URLs" })
    end,
  },
  
  -- Enhanced URL handling with netrw
  {
    "vim-scripts/utl.vim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      vim.g.utl_cfg_hdl_scm_http = "silent !xdg-open '%u'"
      vim.g.utl_cfg_hdl_scm_http_system = "silent !xdg-open '%u'"
      
      if vim.fn.has("mac") == 1 then
        vim.g.utl_cfg_hdl_scm_http = "silent !open '%u'"
        vim.g.utl_cfg_hdl_scm_http_system = "silent !open '%u'"
      elseif vim.fn.has("win32") == 1 then
        vim.g.utl_cfg_hdl_scm_http = "silent !start cmd /c start '%u'"
        vim.g.utl_cfg_hdl_scm_http_system = "silent !start cmd /c start '%u'"
      end
    end,
  },
} 