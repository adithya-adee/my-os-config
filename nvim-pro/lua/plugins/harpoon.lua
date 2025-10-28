return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon_status, harpoon = pcall(require, 'harpoon')
    if not harpoon_status then
      return
    end

    harpoon:setup()
  end,
  keys = {
    { "<leader>a", function() require("harpoon"):list():add() end, desc = "harpoon file" },
    { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "harpoon quick menu" },
    { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1" },
    { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2" },
    { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3" },
    { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4" },
  },
}