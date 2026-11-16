local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
-- o.scrolloff = 8
o.wrap = false
o.splitright = true
o.splitbelow = true

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

o.undofile = true
o.swapfile = false
-- o.updatetime = 250
o.timeoutlen = 400
o.clipboard = "unnamedplus"
-- o.mouse = "a"
o.completeopt = { "menu", "menuone", "noselect" }
o.confirm = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.bo.shiftwidth = 4
		vim.bo.tabstop = 4
	end,
})
