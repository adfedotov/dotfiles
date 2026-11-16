return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: step over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: step into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: step out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Condition: "))
			end,
			desc = "Conditional breakpoint",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle debug UI",
		},
		{
			"<leader>dx",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		require("nvim-dap-virtual-text").setup()

		dap.listeners.after.event_initialized["dapui"] = dapui.open
		dap.listeners.before.event_terminated["dapui"] = dapui.close
		dap.listeners.before.event_exited["dapui"] = dapui.close

		-- Python
		require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

		-- Node (JS/TS) via Mason's js-debug-adapter
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = { command = "js-debug-adapter", args = { "${port}" } },
		}
		for _, lang in ipairs({ "javascript", "typescript" }) do
			dap.configurations[lang] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
		end
	end,
}
