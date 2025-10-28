return {
    'andrewferrier/wrapping.nvim',
    config = function()
        require('wrapping').setup({
            auto_set_mode_filetype_allowlist = {
                'asciidoc',
                'gitcommit',
                'latex',
                'mail',
                'markdown',
                'rst',
                'tex',
                'text',
            },
            notify_on_switch = false,
        })

        -- Ensure diagnostics/errors also wrap
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                prefix = '●',
            },
            float = {
                wrap = true,
                max_width = math.floor(vim.o.columns * 0.8),
            },
        })

        -- Movement keymaps for wrapped lines
        vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true, desc = 'Move down visual line' })
        vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true, desc = 'Move up visual line' })
        vim.keymap.set('n', '0', 'g0', { noremap = true, silent = true, desc = 'Go to start of visual line' })
        vim.keymap.set('n', '$', 'g$', { noremap = true, silent = true, desc = 'Go to end of visual line' })
    end,
}
