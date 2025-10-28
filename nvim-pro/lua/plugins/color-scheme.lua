-- Multiple colorscheme options
-- To switch themes, comment out the current one and uncomment your preferred theme

return {
    -- Everforest - High contrast, eye-friendly (CURRENTLY ACTIVE)
    -- {
    --     "sainnhe/everforest",
    --     priority = 1000,
    --     config = function()
    --         vim.o.background = "dark"
    --         vim.g.everforest_background = "hard" -- Options: 'hard', 'medium', 'soft'
    --         vim.g.everforest_better_performance = 1
    --         vim.g.everforest_enable_italic = 1
    --         vim.cmd.colorscheme("everforest")
    --     end,
    -- },

    -- Catppuccin - Popular pastel theme with great contrast
    -- {
    --   "catppuccin/nvim",
    --   name = "catppuccin",
    --   priority = 1000,
    --   config = function()
    --     require("catppuccin").setup({
    --       flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
    --       transparent_background = false,
    --       term_colors = true,
    --       styles = {
    --         comments = { "italic" },
    --         conditionals = { "italic" },
    --       },
    --     })
    --     vim.cmd.colorscheme("catppuccin")
    --   end,
    -- },

    -- Cyberdream - Ultra high contrast, cyberpunk aesthetic
    -- {
    --   "scottmckendry/cyberdream.nvim",
    --   priority = 1000,
    --   config = function()
    --     require("cyberdream").setup({
    --       transparent = false,
    --       italic_comments = true,
    --       hide_fillchars = true,
    --       terminal_colors = true,
    --       theme = {
    --         variant = "default", -- Options: default, light
    --       },
    --     })
    --     vim.cmd.colorscheme("cyberdream")
    --   end,
    -- },
    --
    --
    {
        "Shatur/neovim-ayu",
        config = function()
            -- Apply the mirage variant on startup
            vim.cmd.colorscheme("ayu-mirage")
        end
    }
}
