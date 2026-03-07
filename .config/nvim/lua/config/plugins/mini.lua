return {
	"nvim-mini/mini.nvim",
	config = function()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.statusline").setup()
	end,
}
