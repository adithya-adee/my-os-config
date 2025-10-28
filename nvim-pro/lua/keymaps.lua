local map = vim.keymap

map.set('i', 'jk', '<Esc>', { nowait = true, desc = 'Exit insert mode with jk' })
map.set('v', 'jk', '<Esc>', { nowait = true, desc = 'Exit insert mode with jk' })
map.set('i', 'jj', '<Esc>', { nowait = true, desc = 'Exit insert mode with jj' })

map.set('n', '<C-h>', '<C-w>h', { desc = 'Toggle to left screen' })
map.set('n', '<C-l>', '<C-l>h', { desc = 'Toggle to right screen' })
