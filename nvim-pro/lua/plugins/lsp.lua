return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- Setup Mason first
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "ts_ls", "pyright", "clangd" },
        })

        -- Get completion capabilities from cmp_nvim_lsp
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            end,
        })

        -- Setup language servers using the new API
        -- Configure lua_ls separately with its specific settings
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'require' }
                    }
                }
            }
        })
        vim.lsp.enable("lua_ls")

        vim.lsp.config("lua_ls", {
            analysis = {
                typeCheckingMode = "strict",
                autoImportCompletions = true,

                -- Add library paths if needed, especially for stubs
                -- extraPaths = {
                --     -- Example, adjust for your environment if needed
                --     "./.venv/Lib/site-packages",
                -- },
            },
        })
        vim.lsp.enable("pyright")

        -- Configure other servers
        local servers = { "ts_ls", "clangd" }
        for _, server in ipairs(servers) do
            vim.lsp.config(server, {
                capabilities = capabilities,
            })
            vim.lsp.enable(server)
        end
    end,
}
