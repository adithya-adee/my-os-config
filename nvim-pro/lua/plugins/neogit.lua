return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>",        desc = "Open Neogit" },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
    { "<leader>gp", "<cmd>Neogit push<cr>",   desc = "Git push" },
    { "<leader>gl", "<cmd>Neogit pull<cr>",   desc = "Git pull" },
  },
  config = function()
    require("neogit").setup({
      integrations = {
        telescope = true,
        diffview = true,
      },
    })
  end,
}
