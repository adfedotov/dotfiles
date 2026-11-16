return {
	-- ───────── File tree ─────────
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
			{ "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file" },
		},
		opts = {
			view = { width = 35 },
			renderer = {
				group_empty = true,
				highlight_git = true,
				indent_markers = { enable = true },
			},
			filters = { dotfiles = false, custom = { "^\\.git$", "node_modules", "__pycache__" } },
			git = { ignore = false },
			update_focused_file = { enable = true },
			actions = { open_file = { quit_on_open = false } },
		},
	},

	-- ───────── Telescope ─────────
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Files",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>fw",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Word under cursor",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>fs",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"<leader>fS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end,
				desc = "Workspace symbols",
			},
			{
				"<leader>fk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fR",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume last picker",
			},
			{
				"<leader>gc",
				function()
					require("telescope.builtin").git_commits()
				end,
				desc = "Git commits",
			},
			{
				"<leader>gs",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "Git status",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Search buffer",
			},
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules/",
						"%.git/",
						"target/",
						"build/",
						"dist/",
						"__pycache__/",
						"%.venv/",
						"%.next/",
					},
					layout_config = { horizontal = { preview_width = 0.55 } },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files = { hidden = true },
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
		end,
	},

	-- ───────── Git ─────────
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(m, l, r, d)
					vim.keymap.set(m, l, r, { buffer = bufnr, desc = d })
				end
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
				map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
				map("n", "<leader>glb", gs.toggle_current_line_blame, "Toggle Current Line Blame")
			end,
		},
	},

	-- ───────── Editing helpers ─────────
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
