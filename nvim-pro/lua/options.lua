local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv('HOME') .. '/.undodir'
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = 'yes'
opt.isfname:append('@-@')

opt.updatetime = 50

opt.colorcolumn = '80'

-- Enable soft wrap by default for all files
opt.wrap = true
opt.linebreak = true -- Break at word boundaries
opt.breakindent = true -- Preserve indentation in wrapped lines
opt.showbreak = '↪ ' -- Show indicator for wrapped lines
