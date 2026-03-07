return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	branch = "master",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"lua",
				"javascript",
				"typescript",
				"c",
				"python",
				"markdown",
				"vim",
				"vimdoc",
				"json",
				"sql",
				"terraform",
				"yaml",
				"bash",
				"tsx",
			},

			sync_install = false,

			auto_install = false,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true,
			},
		})
	end,
}
