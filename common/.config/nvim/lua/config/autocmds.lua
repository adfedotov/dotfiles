vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- reload file if changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "checktime",
})
