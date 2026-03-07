return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.diagnostic.config({
			update_in_insert = false,
			virtual_text = true,
			signs = true,
			underline = true,
			severity_sort = true,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local opts = { buffer = ev.buf }
				-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				--     -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				--     -- Diagnostics
				--     vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
				--     vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				--     vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			end,
		})
	end,
}
