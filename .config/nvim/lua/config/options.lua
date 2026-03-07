-- Editor options
local opt = vim.opt

-- Indentation (defaults - will be overridden by editorconfig/prettier)
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftwidth = 2 -- Size of an indent
opt.softtabstop = 2 -- Number of spaces for <Tab> in insert mode
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically

opt.clipboard = "unnamedplus"

-- Enable EditorConfig support (built into Neovim)
-- This will automatically read .editorconfig files in your projects
vim.g.editorconfig = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Search
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Override ignorecase if search has uppercase

-- UI
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.termguicolors = true

-- Files
opt.undofile = true -- Persistent undo history
opt.swapfile = false -- No swap files
