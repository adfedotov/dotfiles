return {
	{ "folke/lazydev.nvim", ft = "lua", opts = {} },

	{ "mason-org/mason.nvim", opts = {} },

	{
		"neovim/nvim-lspconfig", -- ships default server definitions used by vim.lsp.config
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- ── diagnostics look ──
			vim.diagnostic.config({
				severity_sort = true,
				virtual_text = { spacing = 2, prefix = "●" },
				float = { border = "rounded", source = true },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "",
					},
				},
			})

			-- ── shared settings for every server ──
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- ── per-server overrides ──
			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						disableOrganizeImports = true, -- ruff handles imports
						analysis = { typeCheckingMode = "standard" },
					},
				},
			})

			-- ── install & auto-enable servers ──
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"basedpyright",
					"ruff",
					"lua_ls",
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettierd",
					"stylua",
					"debugpy",
					"js-debug-adapter",
				},
			})

			-- ── keymaps when an LSP attaches ──
			-- 0.11+ already gives you: K hover, grn rename, gra code action, grr references,
			-- gri implementation, grt type def, gO symbols, <C-s> signature help, [d ]d diagnostics.
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local tb = require("telescope.builtin")
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", tb.lsp_definitions, "Definitions (picker)")
					map("grr", tb.lsp_references, "References")
					map("gri", tb.lsp_implementations, "Implementations")
					map("grt", tb.lsp_type_definitions, "Type definition")

					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false -- let basedpyright do hover
					end
					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>ch", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
								{ bufnr = ev.buf }
							)
						end, "Toggle inlay hints")
					end
				end,
			})
		end,
	},
}
