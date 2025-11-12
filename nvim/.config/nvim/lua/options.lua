require("nvchad.options")

-- Enable absolute line numbers on cursor & relative line numbers elsewhere
vim.opt.number = true
vim.opt.relativenumber = true

-- Show dedicated sign column next to line numbers
vim.opt.signcolumn = "yes"

-- Highlight 80th column with vertical line
vim.opt.colorcolumn = "100"

-- Enable cursorline (highlights current line & line number)
vim.o.cursorline = true
vim.o.cursorlineopt = "both"

-- Indents = 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Set backspace behavior
vim.opt.backspace = { "indent", "eol", "start" }

-- Sync nvim register & system clipboard
vim.opt.clipboard:append("unnamedplus")

-- Store undo history in dedicated directory
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true

-- Enable auto-reload for external file changes
vim.o.autoread = true

-- Enable highlight, incremental, and smart-case search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable 24-bit true color support
vim.opt.termguicolors = true

-- Enable line wrapping
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.linebreak = true

-- No scrolloff (centering handled in autocmds.lua)
vim.opt.scrolloff = 0

-- Configure split pane directions
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Makes neovim more responsive
vim.opt.updatetime = 50

-- Remove top visual margin (after disabling tabufline)
vim.opt.showtabline = 0

-- vim-tmux-navigator: autosave on navigation leave (2 = :wall, saves all buffers)
---@diagnostic disable-next-line: inject-field
vim.g.tmux_navigator_save_on_switch = 2
