--[[
  Jupyter Notebook Support for Neovim

  SETUP REQUIRED:
  1. Install Python packages:
     pip install jupytext pynvim jupyter_client

  2. For image rendering (optional), you need a compatible terminal:
     - Kitty (recommended)
     - WezTerm
     - Or install ueberzug++

  HOW IT WORKS:
  - jupytext.nvim converts .ipynb files to .py format with cell markers (# %%)
  - This allows full LSP support (autocomplete, diagnostics) via Pyright
  - molten-nvim runs code cells interactively with Jupyter kernel
  - image.nvim renders plots and images inline (if terminal supports it)

  USAGE:
  1. Open any .ipynb file - it will be converted to Python format automatically
  2. Press <leader>mc to initialize Molten kernel
  3. Use <leader>ml to run current line or <leader>me in visual mode
  4. Press <leader>mo to show output
--]]

return {
  -- Edit .ipynb files as plain text using jupytext
  {
    "goerz/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        -- Convert to percent format (.py with # %% cell markers)
        -- This works best with LSP and syntax highlighting
        -- custom_language_formatting = {
        --   python = {
        --     extension = "py",
        --     style = "percent",
        --     force_ft = "python",
        --   },
        -- },
      })
    end,
  },

  -- Interactive code execution with Jupyter kernel
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "3rd/image.nvim", -- Optional: for image rendering
    },
    config = function()
      -- Molten configuration
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      -- Keymaps for Molten
      vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten" })
      vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "Evaluate operator" })
      vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "Evaluate line" })
      vim.keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
      vim.keymap.set("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Evaluate visual" })
      vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Delete Molten cell" })
      vim.keymap.set("n", "<leader>mo", ":MoltenShowOutput<CR>", { desc = "Show output" })
      vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Hide output" })

      -- Autocommand to initialize molten for Python files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Only initialize if not already initialized
          vim.keymap.set("n", "<leader>mc", function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              vim.cmd(("MoltenInit python3"))
            else
              vim.cmd("MoltenInit python3")
            end
          end, { desc = "Initialize Molten kernel", buffer = true })
        end,
      })
    end,
  },

  -- -- Optional: Image rendering support (requires compatible terminal)
  -- {
  --   "3rd/image.nvim",
  --   opts = {
  --     backend = "kitty", -- Change to "ueberzug" or "wezterm" if needed
  --     integrations = {
  --       markdown = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --       },
  --     },
  --     max_width = nil,
  --     max_height = nil,
  --     max_width_window_percentage = nil,
  --     max_height_window_percentage = 50,
  --     window_overlap_clear_enabled = false,
  --     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --     editor_only_render_when_focused = false,
  --     tmux_show_only_in_active_window = false,
  --     hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  --   },
  -- },
}
