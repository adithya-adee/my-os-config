return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        -- Enable folding with treesitter
        vim.o.foldcolumn = '1' -- Show fold column
        vim.o.foldlevel = 99 -- Using ufo provider need a large value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider for all filetypes
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end,
        })

        -- Keymaps for folding
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })
        vim.keymap.set('n', 'zK', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, { desc = 'Peek folded lines' })
    end,
}
