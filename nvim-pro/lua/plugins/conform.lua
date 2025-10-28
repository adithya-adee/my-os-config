return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>fm",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                make = { "cmakelang" },
                cpp = { "clang-format" },
                java = { "google-java-format" },
                python = { "ruff_format", "ruff_organize_imports" },
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "json-lsp" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
            },
            -- Formatter-specific settings for 4-space indentation
            formatters = {
                prettier = {
                    prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                },
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                ["clang-format"] = {
                    prepend_args = { "--style={IndentWidth: 4, UseTab: Never}" },
                },
                ["google-java-format"] = {
                    prepend_args = {},
                },
                ruff_format = {
                    prepend_args = { "--config", "indent-width=4" },
                },
            },
            -- Format on save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
