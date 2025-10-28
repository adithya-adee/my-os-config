return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                width = 20,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
        })
    end,
    keys = {
        {
            "<leader>e",
            function()
                require("nvim-tree.api").tree.toggle()
            end,
            desc = "Toggle file explorer",
        },
    },
}
